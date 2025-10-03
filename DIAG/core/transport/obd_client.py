from __future__ import annotations

from typing import Any, Dict, Iterable


class OBDClient:
    """High level wrapper around python-OBD."""

    def __init__(self, port: str, baudrate: int = 115200) -> None:
        self._port = port
        self._baudrate = baudrate
        self._connection = None

    def connect(self) -> None:
        """Connect to python-OBD and configure defaults."""
        # TODO: instantiate python-OBD connection with retry and backoff
        raise NotImplementedError("connect is not implemented yet")

    def query_pid(self, pid: str) -> Dict[str, Any]:
        """Query a PID and return normalized data."""
        # TODO: wrap python-OBD responses and convert units
        raise NotImplementedError("query_pid is not implemented yet")

    def supported_pids(self) -> Iterable[str]:
        """Return discovered supported PIDs."""
        # TODO: hook into capability cache and discovery flow
        return []
