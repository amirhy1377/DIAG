from __future__ import annotations

import datetime as dt
from typing import Dict, List, Optional


class DTCManager:
    """Handles reading, clearing, and caching DTCs."""

    def __init__(self) -> None:
        self._snapshot: Dict[str, List[str]] = {
            "current": [],
            "pending": [],
            "permanent": [],
        }
        self._updated_at: Optional[dt.datetime] = None

    def read(self) -> Dict[str, object]:
        """Return a copy of the cached DTC snapshot."""
        return {
            "codes": {bucket: list(values) for bucket, values in self._snapshot.items()},
            "updated_at": self._updated_at.isoformat() if self._updated_at else None,
        }

    def update(
        self,
        *,
        current: Optional[List[str]] = None,
        pending: Optional[List[str]] = None,
        permanent: Optional[List[str]] = None,
    ) -> Dict[str, object]:
        """Update the cached snapshot and return the new value."""
        if current is not None:
            self._snapshot["current"] = list(current)
        if pending is not None:
            self._snapshot["pending"] = list(pending)
        if permanent is not None:
            self._snapshot["permanent"] = list(permanent)
        self._updated_at = dt.datetime.utcnow()
        return self.read()

    def clear(self) -> Dict[str, object]:
        """Clear stored DTCs on the vehicle."""
        return self.update(current=[], pending=[], permanent=[])


__all__ = ["DTCManager"]
