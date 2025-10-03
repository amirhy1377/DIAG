from fastapi.testclient import TestClient

from app.api import app


def test_session_lifecycle_and_stream(tmp_path) -> None:
    client = TestClient(app)
    start_resp = client.post("/v1/session/start", json={"log_root": str(tmp_path), "rate": 5.0})
    assert start_resp.status_code == 200
    payload = start_resp.json()
    assert payload["ok"] is True
    assert payload["session"]["session_id"]
    assert abs(payload["poll_interval"] - 0.2) < 1e-6
    assert abs(payload["poll_rate_hz"] - 5.0) < 1e-6

    status_resp = client.get("/v1/session/status")
    assert status_resp.json()["active"] is True

    duplicate_resp = client.post("/v1/session/start")
    assert duplicate_resp.status_code == 409

    with client.websocket_connect("/ws/telemetry") as websocket:
        status_message = websocket.receive_json()
        assert status_message["type"] == "status"
        assert status_message["status"] == "streaming"
        telemetry = websocket.receive_json()
        assert telemetry["type"] == "telemetry"
        assert telemetry["payload"]["pid"] in {"RPM", "SPEED", "COOLANT_TEMP", "THROTTLE_POS"}

    stop_resp = client.post("/v1/session/stop")
    assert stop_resp.status_code == 200
    assert stop_resp.json()["ok"] is True

    status_resp = client.get("/v1/session/status")
    assert status_resp.json()["active"] is False


def test_dtc_endpoints() -> None:
    client = TestClient(app)
    read_resp = client.get("/v1/dtc")
    assert read_resp.status_code == 200
    assert read_resp.json()["snapshot"]["codes"] == {"current": [], "pending": [], "permanent": []}

    clear_resp = client.post("/v1/dtc/clear")
    assert clear_resp.status_code == 200
    assert clear_resp.json()["snapshot"]["codes"] == {"current": [], "pending": [], "permanent": []}


