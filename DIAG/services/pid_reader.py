from __future__ import annotations

import asyncio
import random
import time
from dataclasses import dataclass
from typing import Dict, Tuple


@dataclass(frozen=True)
class PIDSpec:
    """Metadata describing how to synthesise a PID measurement."""

    unit: str
    value_range: Tuple[float, float]
    baseline: float


DEFAULT_PID_SPECS: Dict[str, PIDSpec] = {
    "RPM": PIDSpec(unit="rpm", value_range=(600.0, 7200.0), baseline=1100.0),
    "SPEED": PIDSpec(unit="km/h", value_range=(0.0, 210.0), baseline=32.0),
    "COOLANT_TEMP": PIDSpec(unit="degC", value_range=(70.0, 130.0), baseline=90.0),
    "THROTTLE_POS": PIDSpec(unit="%", value_range=(4.0, 100.0), baseline=12.0),
}


class SimulatedPIDReader:
    """Generates plausible PID samples for development and testing."""

    def __init__(self, seed: int | None = None, noise: float = 0.08) -> None:
        self._rng = random.Random(seed)
        self._noise = max(0.0, min(noise, 1.0))
        self._specs = dict(DEFAULT_PID_SPECS)

    def register_spec(self, pid: str, spec: PIDSpec) -> None:
        """Register or override metadata for a PID."""
        self._specs[pid] = spec

    async def read(self, pid: str) -> Dict[str, float | str]:
        """Return a simulated reading for *pid* with timestamp metadata."""
        spec = self._specs.get(pid)
        if not spec:
            spec = PIDSpec(unit="", value_range=(0.0, 1.0), baseline=0.5)
            self._specs[pid] = spec
        minimum, maximum = spec.value_range
        amplitude = (maximum - minimum) / 2.0
        midpoint = minimum + amplitude
        jitter = (self._rng.random() - 0.5) * 2.0 * amplitude * self._noise
        drift = (self._rng.random() - 0.5) * amplitude * 0.02
        value = max(minimum, min(maximum, midpoint + jitter + drift))
        await asyncio.sleep(0)
        return {
            "pid": pid,
            "value": float(round(value, 4)),
            "unit": spec.unit,
            "timestamp": time.time(),
        }


__all__ = ["PIDSpec", "SimulatedPIDReader", "DEFAULT_PID_SPECS"]
