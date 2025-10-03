import asyncio
from pathlib import Path

import pytest

from core.capabilities.cache import CapabilityCache
from services.log_pipeline import ParquetLogger
from services.pid_reader import SimulatedPIDReader
from services.poll_scheduler import PollScheduler
from services.session_controller import SessionController


@pytest.mark.asyncio
async def test_poll_scheduler_dispatches_samples() -> None:
    reader = SimulatedPIDReader(seed=42)
    scheduler = PollScheduler(interval=0.01, pids=["RPM"], reader=reader.read, session_id="test-session")
    queue = scheduler.subscribe()
    assert scheduler.interval == pytest.approx(0.01, rel=1e-6)
    assert scheduler.rate_hz == pytest.approx(100.0, rel=1e-6)

    await scheduler.start()
    message = await asyncio.wait_for(queue.get(), timeout=0.5)
    assert message["pid"] == "RPM"
    assert message["session_id"] == "test-session"

    await scheduler.stop()
    sentinel = await asyncio.wait_for(queue.get(), timeout=0.5)
    assert sentinel is None
    scheduler.unsubscribe(queue)


def test_parquet_logger_flush(tmp_path: Path) -> None:
    logger = ParquetLogger(str(tmp_path), "session-123", flush_threshold=1)
    logger.write("RPM", 1200.0, "rpm")
    logger.flush()
    files = list(tmp_path.rglob("*.parquet"))
    assert files, "expected parquet output"
    logger.close()


def test_capability_cache_roundtrip() -> None:
    cache = CapabilityCache()
    cache.set("VIN123", "ELM", {"RPM", "SPEED"})
    entry = cache.get("VIN123", "ELM")
    assert entry is not None
    assert entry.pids == {"RPM", "SPEED"}
    cache.invalidate("VIN123", "ELM")
    assert cache.get("VIN123", "ELM") is None


def test_session_controller_abort() -> None:
    controller = SessionController()
    controller.start(vin="VIN123", adapter_id="ELM327")
    assert controller.active is not None
    controller.abort()
    assert controller.active is None
    assert controller.stop() is None

