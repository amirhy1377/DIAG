from __future__ import annotations

import asyncio
from dataclasses import dataclass, field
from contextlib import suppress
from typing import Any, Dict, List, Optional

from fastapi import Body, FastAPI, HTTPException, WebSocket, WebSocketDisconnect
from pydantic import BaseModel, Field, validator

from core.capabilities.cache import CapabilityCache
from services.dtc_manager import DTCManager
from services.log_pipeline import ParquetLogger
from services.pid_reader import DEFAULT_PID_SPECS, SimulatedPIDReader
from services.poll_scheduler import PollScheduler
from services.session_controller import SessionController, SessionMetadata
from app.ws import stream_scheduler

DEFAULT_PIDS = list(DEFAULT_PID_SPECS.keys())

app = FastAPI(title="DIAG Dashboard API", version="0.1.0")


@dataclass
class ApplicationState:
    lock: asyncio.Lock = field(default_factory=asyncio.Lock)
    session_controller: SessionController = field(default_factory=SessionController)
    dtc_manager: DTCManager = field(default_factory=DTCManager)
    capability_cache: CapabilityCache = field(default_factory=CapabilityCache)
    scheduler: Optional[PollScheduler] = None
    logger: Optional[ParquetLogger] = None
    reader: Optional[SimulatedPIDReader] = None
    vin: str = "UNKNOWN"
    adapter_id: str = "loopback"


STATE = ApplicationState()


class StartSessionRequest(BaseModel):
    port: str = "loopback"
    vin: Optional[str] = None
    adapter_id: Optional[str] = None
    rate: float = Field(5.0, gt=0.1, le=50.0, description="Target poll rate in Hz")
    pids: List[str] = Field(default_factory=lambda: DEFAULT_PIDS.copy())
    log_root: str = Field("./logs", description="Directory for session logs")
    seed: Optional[int] = Field(
        default=None, description="Seed for deterministic telemetry"
    )

    @validator("pids")
    def _ensure_pids(cls, value: List[str]) -> List[str]:
        if not value:
            raise ValueError("At least one PID must be provided")
        # Remove duplicates while preserving order.
        seen: Dict[str, None] = {}
        for pid in value:
            seen.setdefault(pid, None)
        return list(seen.keys())


class StartSessionResponse(BaseModel):
    ok: bool
    session: Dict[str, Any]
    poll_interval: float
    poll_rate_hz: float
    pid_count: int


class StopSessionResponse(BaseModel):
    ok: bool
    session: Optional[Dict[str, Any]]


class SessionStatusResponse(BaseModel):
    active: bool
    session: Optional[Dict[str, Any]]


class PIDResponse(BaseModel):
    supported: List[str]
    source: str


class DTCResponse(BaseModel):
    ok: bool
    snapshot: Dict[str, Any]


def _serialise_session(metadata: SessionMetadata) -> Dict[str, Any]:
    return {
        "session_id": metadata.session_id,
        "started_at": metadata.started_at.isoformat(),
        "ended_at": metadata.ended_at.isoformat() if metadata.ended_at else None,
        "vin": metadata.vin,
        "adapter_id": metadata.adapter_id,
        "vehicle_profile": dict(metadata.vehicle_profile),
        "sw_version": metadata.sw_version,
    }


@app.get("/health")
def health() -> Dict[str, Any]:
    """Basic health probe for readiness checks."""
    return {"ok": True}


@app.get("/v1/session/status", response_model=SessionStatusResponse)
async def session_status() -> SessionStatusResponse:
    async with STATE.lock:
        active = STATE.session_controller.active
        return SessionStatusResponse(
            active=bool(active), session=_serialise_session(active) if active else None
        )


@app.post("/v1/session/start", response_model=StartSessionResponse)
async def start_session(
    payload: StartSessionRequest | None = Body(default=None),
) -> StartSessionResponse:
    request = payload or StartSessionRequest()

    async with STATE.lock:
        if STATE.session_controller.active:
            raise HTTPException(
                status_code=409, detail="A diagnostic session is already running"
            )
        metadata = STATE.session_controller.start(
            vin=request.vin, adapter_id=request.adapter_id or request.port
        )

    reader = SimulatedPIDReader(seed=request.seed)
    scheduler = PollScheduler(
        interval=1.0 / request.rate,
        pids=request.pids,
        reader=reader.read,
        session_id=metadata.session_id,
    )
    logger = ParquetLogger(request.log_root, metadata.session_id)
    scheduler.add_sink(logger.handle_sample)

    try:
        await scheduler.start()
        actual_interval = round(scheduler.interval, 6)
        actual_rate = round(scheduler.rate_hz, 6)
        vin = request.vin or "UNKNOWN"
        adapter_id = request.adapter_id or request.port

        async with STATE.lock:
            STATE.reader = reader
            STATE.scheduler = scheduler
            STATE.logger = logger
            STATE.vin = vin
            STATE.adapter_id = adapter_id
            STATE.capability_cache.set(vin, adapter_id, set(scheduler.pids))
            metadata.vehicle_profile.update(
                {
                    "port": request.port,
                    "pids": ",".join(scheduler.pids),
                    "target_rate_hz": str(request.rate),
                    "actual_rate_hz": f"{actual_rate:.6f}",
                    "poll_interval_s": f"{actual_interval:.6f}",
                }
            )
            session_payload = _serialise_session(metadata)
    except asyncio.CancelledError:
        raise
    except Exception as exc:
        with suppress(Exception):
            await scheduler.stop()
        with suppress(Exception):
            logger.close()
        async with STATE.lock:
            STATE.session_controller.abort()
        raise HTTPException(
            status_code=500, detail="Failed to start diagnostic session"
        ) from exc

    return StartSessionResponse(
        ok=True,
        session=session_payload,
        poll_interval=actual_interval,
        poll_rate_hz=actual_rate,
        pid_count=len(scheduler.pids),
    )


@app.post("/v1/session/stop", response_model=StopSessionResponse)
async def stop_session() -> StopSessionResponse:
    async with STATE.lock:
        scheduler = STATE.scheduler
        logger = STATE.logger
        STATE.scheduler = None
        STATE.reader = None
        STATE.logger = None

    if scheduler:
        await scheduler.stop()
    if logger:
        logger.close()

    async with STATE.lock:
        metadata = STATE.session_controller.stop()
        if not metadata:
            raise HTTPException(status_code=400, detail="No active diagnostic session")
        return StopSessionResponse(ok=True, session=_serialise_session(metadata))


@app.get("/v1/pids", response_model=PIDResponse)
async def list_pids() -> PIDResponse:
    async with STATE.lock:
        scheduler = STATE.scheduler
        if scheduler and scheduler.pids:
            return PIDResponse(supported=scheduler.pids, source="session")
        cached = STATE.capability_cache.get(STATE.vin, STATE.adapter_id)
        if cached:
            return PIDResponse(supported=sorted(cached.pids), source="cache")
        return PIDResponse(supported=DEFAULT_PIDS.copy(), source="defaults")


@app.get("/v1/dtc", response_model=DTCResponse)
async def get_dtc() -> DTCResponse:
    snapshot = STATE.dtc_manager.read()
    return DTCResponse(ok=True, snapshot=snapshot)


@app.post("/v1/dtc/clear", response_model=DTCResponse)
async def clear_dtc() -> DTCResponse:
    snapshot = STATE.dtc_manager.clear()
    return DTCResponse(ok=True, snapshot=snapshot)


@app.websocket("/ws/telemetry")
async def telemetry(ws: WebSocket) -> None:
    await ws.accept()
    scheduler = STATE.scheduler
    try:
        if not scheduler:
            await ws.send_json({"type": "status", "status": "idle"})
            await ws.close(code=1000)
            return
        await stream_scheduler(ws, scheduler)
    except WebSocketDisconnect:
        pass
    finally:
        with suppress(Exception):
            await ws.close()
