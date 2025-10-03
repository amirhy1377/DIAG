from __future__ import annotations

import threading
import time
from pathlib import Path
from typing import Dict, List

import pyarrow as pa
import pyarrow.parquet as pq

SCHEMA = pa.schema(
    [
        ("timestamp", pa.float64()),
        ("pid", pa.string()),
        ("value", pa.float64()),
        ("unit", pa.string()),
        ("session_id", pa.string()),
    ]
)


class ParquetLogger:
    """Buffered writer for Parquet datasets with safe flushing."""

    def __init__(
        self, root_path: str, session_id: str, flush_threshold: int = 200
    ) -> None:
        self._root = Path(root_path)
        self._root.mkdir(parents=True, exist_ok=True)
        self._session_id = session_id
        self._flush_threshold = max(1, flush_threshold)
        self._buffer: List[Dict[str, object]] = []
        self._lock = threading.Lock()
        self._closed = False

    def write(self, pid: str, value: float, unit: str) -> None:
        """Append a row to the buffer and flush when needed."""
        row = {
            "timestamp": time.time(),
            "pid": pid,
            "value": float(value),
            "unit": unit,
            "session_id": self._session_id,
        }
        with self._lock:
            self._ensure_open()
            self._buffer.append(row)
            if len(self._buffer) >= self._flush_threshold:
                self._flush_unlocked()

    def handle_sample(self, sample: Dict[str, object]) -> None:
        """Convenience hook to accept scheduler telemetry samples."""
        value = sample.get("value")
        pid = sample.get("pid")
        unit = sample.get("unit", "")
        if pid is None or value is None:
            return
        try:
            numeric_value = float(value)
        except (TypeError, ValueError):
            return
        self.write(str(pid), numeric_value, str(unit))

    def flush(self) -> None:
        """Flush buffered rows to the Parquet dataset."""
        with self._lock:
            self._ensure_open()
            self._flush_unlocked()

    def close(self) -> None:
        """Flush any buffered data and mark the logger as closed."""
        with self._lock:
            if self._closed:
                return
            self._flush_unlocked()
            self._closed = True

    def _flush_unlocked(self) -> None:
        if not self._buffer:
            return
        table = pa.Table.from_pylist(self._buffer, schema=SCHEMA)
        pq.write_to_dataset(
            table, root_path=str(self._root), partition_cols=["session_id"]
        )
        self._buffer.clear()

    def _ensure_open(self) -> None:
        if self._closed:
            raise RuntimeError("ParquetLogger has been closed")

    def __enter__(self) -> "ParquetLogger":
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        self.close()

    def __del__(self) -> None:
        try:
            self.close()
        except Exception:
            # Destructors should never raise.
            pass


__all__ = ["ParquetLogger", "SCHEMA"]
