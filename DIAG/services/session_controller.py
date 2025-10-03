from __future__ import annotations

import uuid
from dataclasses import asdict, dataclass, field
from datetime import datetime
from typing import Dict, Optional


@dataclass
class SessionMetadata:
    """Tracks metadata about a diagnostic session."""

    session_id: str
    started_at: datetime
    ended_at: Optional[datetime] = None
    vin: Optional[str] = None
    adapter_id: Optional[str] = None
    vehicle_profile: Dict[str, str] = field(default_factory=dict)
    sw_version: str = "0.1.0"


class SessionController:
    """Lifecycle management for diagnostic sessions."""

    def __init__(self) -> None:
        self._session: Optional[SessionMetadata] = None

    def start(
        self, vin: Optional[str] = None, adapter_id: Optional[str] = None
    ) -> SessionMetadata:
        """Start a new diagnostic session."""
        if self._session is not None:
            raise RuntimeError("A diagnostic session is already active")
        self._session = SessionMetadata(
            session_id=str(uuid.uuid4()),
            started_at=datetime.utcnow(),
            vin=vin,
            adapter_id=adapter_id,
        )
        return self._session

    def stop(self) -> Optional[SessionMetadata]:
        """Stop the active diagnostic session."""
        if not self._session:
            return None
        self._session.ended_at = datetime.utcnow()
        session = self._session
        self._session = None
        return session

    def abort(self) -> None:
        """Abort the active session without marking it completed."""
        self._session = None

    @property
    def active(self) -> Optional[SessionMetadata]:
        """Return the active session if available."""
        return self._session

    def snapshot(self) -> Optional[Dict[str, object]]:
        """Return a serialisable snapshot of the active session."""
        if not self._session:
            return None
        return self._serialise(self._session)

    @staticmethod
    def _serialise(metadata: SessionMetadata) -> Dict[str, object]:
        payload = asdict(metadata)
        payload["started_at"] = metadata.started_at.isoformat()
        payload["ended_at"] = (
            metadata.ended_at.isoformat() if metadata.ended_at else None
        )
        return payload


__all__ = ["SessionController", "SessionMetadata"]
