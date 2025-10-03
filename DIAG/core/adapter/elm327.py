from __future__ import annotations

from dataclasses import dataclass
from typing import Optional

try:
    import serial  # type: ignore
except ImportError:  # pragma: no cover - pyserial is an optional dependency
    serial = None  # type: ignore


@dataclass
class AdapterConfig:
    """Configuration values required to talk to an ELM327 device."""

    port: str
    baudrate: int = 115200
    timeout: float = 1.0


class ELM327Adapter:
    """Thin wrapper around an ELM327 compatible interface."""

    def __init__(self, config: AdapterConfig) -> None:
        self._config = config
        self._serial: Optional["serial.Serial"] = None

    def connect(self) -> None:
        """Establish a serial connection and perform AT init."""
        if serial is None:  # pragma: no cover - handled via dependency management
            raise RuntimeError("pyserial is not installed; cannot connect to adapter")
        if self._serial and self._serial.is_open:
            return
        try:
            self._serial = serial.Serial(
                port=self._config.port,
                baudrate=self._config.baudrate,
                timeout=self._config.timeout,
            )
        except Exception as exc:  # serial.SerialException, but keep loose typing
            raise ConnectionError(
                f"Failed to open serial port {self._config.port}: {exc}"
            ) from exc
        self._initialise()

    def _initialise(self) -> None:
        commands = ("ATZ", "ATE0", "ATL0", "ATS0", "ATH0")
        for command in commands:
            try:
                self.send(command)
            except Exception:
                break

    def send(self, command: str) -> None:
        """Send a raw AT or OBD-II command."""
        if not self._serial or not self._serial.is_open:
            raise RuntimeError("Adapter is not connected")
        payload = command.strip().encode("ascii") + b"\r"
        self._serial.write(payload)

    def read(self) -> str:
        """Read a response line from the adapter."""
        if not self._serial or not self._serial.is_open:
            raise RuntimeError("Adapter is not connected")
        data = self._serial.readline().decode("ascii", errors="ignore").strip()
        return data

    def close(self) -> None:
        if self._serial and self._serial.is_open:
            self._serial.close()

    def healthcheck(self) -> bool:
        """Run a lightweight health check on the adapter."""
        return bool(self._serial and self._serial.is_open)


__all__ = ["AdapterConfig", "ELM327Adapter"]
