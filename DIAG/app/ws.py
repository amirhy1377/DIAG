from __future__ import annotations

import asyncio
from contextlib import suppress

from fastapi import WebSocket

from services.poll_scheduler import PollScheduler


async def stream_scheduler(ws: WebSocket, scheduler: PollScheduler) -> None:
    """Stream telemetry samples from *scheduler* to an accepted websocket."""
    queue = scheduler.subscribe()
    try:
        await ws.send_json({"type": "status", "status": "streaming", "session_id": scheduler.session_id})
        while True:
            message = await queue.get()
            if message is None:
                break
            await ws.send_json({"type": "telemetry", "payload": message})
    finally:
        scheduler.unsubscribe(queue)


async def idle_stream(ws: WebSocket, delay: float = 1.0) -> None:
    """Send periodic status updates while no scheduler is active."""
    try:
        await ws.send_json({"type": "status", "status": "idle"})
        while True:
            await asyncio.sleep(delay)
            await ws.send_json({"type": "status", "status": "idle"})
    finally:
        with suppress(Exception):
            await ws.close()
