from __future__ import annotations

import asyncio
import itertools
import time
from contextlib import suppress
from typing import Any, Awaitable, Callable, Dict, Iterable, Optional, Set

TelemetrySample = Dict[str, Any]
TelemetryReader = Callable[[str], Awaitable[TelemetrySample | None] | TelemetrySample | None]
TelemetrySink = Callable[[TelemetrySample], Awaitable[None] | None]


class PollScheduler:
    """Schedules PID polling at a target interval and fans out telemetry."""

    def __init__(
        self,
        interval: float,
        pids: Iterable[str],
        reader: TelemetryReader,
        *,
        session_id: str | None = None,
    ) -> None:
        self._interval = max(0.01, float(interval))
        self._pids = list(dict.fromkeys(pids))
        self._reader = reader
        self._session_id = session_id
        self._running = False
        self._task: Optional[asyncio.Task[None]] = None
        self._subscribers: Set[asyncio.Queue] = set()
        self._sinks: Set[TelemetrySink] = set()
        self._lock = asyncio.Lock()
        self._sequence = itertools.count()

    @property
    def pids(self) -> list[str]:
        return list(self._pids)

    @property
    def interval(self) -> float:
        return self._interval

    @property
    def rate_hz(self) -> float:
        return 0.0 if self._interval <= 0 else 1.0 / self._interval

    @property
    def session_id(self) -> Optional[str]:
        return self._session_id

    def set_session_id(self, session_id: str) -> None:
        self._session_id = session_id

    def subscribe(self, max_queue_size: int = 64) -> asyncio.Queue:
        queue: asyncio.Queue = asyncio.Queue(maxsize=max(1, max_queue_size))
        self._subscribers.add(queue)
        return queue

    def unsubscribe(self, queue: asyncio.Queue) -> None:
        self._subscribers.discard(queue)

    def add_sink(self, sink: TelemetrySink) -> None:
        self._sinks.add(sink)

    def remove_sink(self, sink: TelemetrySink) -> None:
        self._sinks.discard(sink)

    async def start(self) -> None:
        """Start the background polling loop."""
        async with self._lock:
            if self._task and not self._task.done():
                return
            self._running = True
            self._task = asyncio.create_task(self._run(), name="poll-scheduler")

    async def stop(self) -> None:
        """Stop the background polling loop and notify subscribers."""
        async with self._lock:
            self._running = False
            if self._task:
                self._task.cancel()
                with suppress(asyncio.CancelledError):
                    await self._task
                self._task = None
        await self._notify_shutdown()

    async def _run(self) -> None:
        try:
            loop = asyncio.get_event_loop()
            while self._running:
                cycle_started = loop.time()
                for pid in self._pids:
                    if not self._running:
                        break
                    sample = await self._read(pid)
                    if sample is None:
                        continue
                    enriched = self._decorate(sample)
                    await self._dispatch(enriched)
                elapsed = loop.time() - cycle_started
                sleep_for = max(0.0, self._interval - elapsed)
                if sleep_for:
                    await asyncio.sleep(sleep_for)
        finally:
            await self._notify_shutdown()

    async def _read(self, pid: str) -> TelemetrySample | None:
        result = self._reader(pid)
        if asyncio.iscoroutine(result):
            result = await result
        return result

    def _decorate(self, sample: TelemetrySample) -> TelemetrySample:
        sequence = next(self._sequence)
        payload = dict(sample)
        payload.setdefault("timestamp", time.time())
        payload.setdefault("pid", "unknown")
        payload.setdefault("value", None)
        payload.setdefault("unit", "")
        payload["sequence"] = sequence
        if self._session_id is not None:
            payload.setdefault("session_id", self._session_id)
        return payload

    async def _dispatch(self, sample: TelemetrySample) -> None:
        await self._publish(sample)
        await self._fanout(sample)

    async def _publish(self, sample: TelemetrySample) -> None:
        dead: Set[asyncio.Queue] = set()
        for queue in list(self._subscribers):
            try:
                queue.put_nowait(sample)
            except asyncio.QueueFull:
                try:
                    queue.get_nowait()
                except asyncio.QueueEmpty:
                    pass
                try:
                    queue.put_nowait(sample)
                except asyncio.QueueFull:
                    dead.add(queue)
            except RuntimeError:
                dead.add(queue)
        for queue in dead:
            self._subscribers.discard(queue)

    async def _fanout(self, sample: TelemetrySample) -> None:
        for sink in list(self._sinks):
            result = sink(sample)
            if asyncio.iscoroutine(result):
                try:
                    await result
                except Exception:
                    self._sinks.discard(sink)

    async def _notify_shutdown(self) -> None:
        for queue in list(self._subscribers):
            try:
                queue.put_nowait(None)
            except asyncio.QueueFull:
                pass
            except RuntimeError:
                pass


__all__ = ["PollScheduler", "TelemetrySample", "TelemetryReader", "TelemetrySink"]
