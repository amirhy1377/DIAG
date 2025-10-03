"""Validator for ELM327 style adapters."""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, asdict
from typing import List


@dataclass
class ValidationResult:
    port: str
    firmware: str
    latency_ms: float
    score: int
    warnings: List[str]
    passed: bool


def validate(port: str) -> ValidationResult:
    """Run validation against the target port."""
    # TODO: implement real serial checks and timing measurements
    return ValidationResult(
        port=port,
        firmware="unknown",
        latency_ms=0.0,
        score=0,
        warnings=["Validator not implemented"],
        passed=False,
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Validate an ELM327 adapter")
    parser.add_argument(
        "port", help="Serial port identifier, e.g. COM3 or /dev/ttyUSB0"
    )
    args = parser.parse_args(argv)

    result = validate(args.port)
    print(json.dumps(asdict(result), indent=2))
    return 0 if result.passed else 1


if __name__ == "__main__":
    sys.exit(main())
