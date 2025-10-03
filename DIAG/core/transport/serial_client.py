from __future__ import annotations

from typing import Optional


class SerialClient:
    """Raw serial fallback client for direct PID polling."""

    def __init__(self, port: str, baudrate: int = 115200, timeout: float = 1.0) -> None:
        self._port = port
        self._baudrate = baudrate
        self._timeout = timeout
        self._serial = None

    def connect(self) -> None:
        """Open a serial connection to the adapter."""
        # TODO: use pyserial to open the port with retries
        raise NotImplementedError("connect is not implemented yet")

    def read_pid(self, pid: str) -> Optional[float]:
        """Send a mode 01 request for the given PID."""
        # TODO: implement ISO-15765 message formatting and parsing
        raise NotImplementedError("read_pid is not implemented yet")

    def close(self) -> None:
        """Close the serial connection safely."""
        # TODO: ensure the serial port is closed and cleaned up
        raise NotImplementedError("close is not implemented yet")
