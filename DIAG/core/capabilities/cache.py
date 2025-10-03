from __future__ import annotations

import datetime as dt
from dataclasses import dataclass
from typing import Dict, Optional, Set, Tuple


@dataclass
class CapabilityEntry:
    """Persistence-friendly structure for capability metadata."""

    pids: Set[str]
    expires_at: dt.datetime


class CapabilityCache:
    """In-memory capability cache with simple TTL semantics."""

    def __init__(self) -> None:
        self._store: Dict[Tuple[str, str], CapabilityEntry] = {}

    def get(self, vin: str, adapter_id: str) -> Optional[CapabilityEntry]:
        """Return the cached entry if present and not expired."""
        key = (vin, adapter_id)
        entry = self._store.get(key)
        if not entry:
            return None
        if dt.datetime.utcnow() >= entry.expires_at:
            self._store.pop(key, None)
            return None
        return CapabilityEntry(pids=set(entry.pids), expires_at=entry.expires_at)

    def set(self, vin: str, adapter_id: str, pids: Set[str], ttl_days: int = 7) -> None:
        """Persist the capability list for the VIN and adapter combination."""
        expires_at = dt.datetime.utcnow() + dt.timedelta(days=max(1, ttl_days))
        self._store[(vin, adapter_id)] = CapabilityEntry(
            pids=set(pids), expires_at=expires_at
        )

    def invalidate(self, vin: str, adapter_id: str) -> None:
        """Drop the cached entry if it exists."""
        self._store.pop((vin, adapter_id), None)

    def clear(self) -> None:
        """Remove all cached capability entries."""
        self._store.clear()


__all__ = ["CapabilityCache", "CapabilityEntry"]
