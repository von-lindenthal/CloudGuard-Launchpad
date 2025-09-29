import json

from app.src.main import create_app


def test_health_endpoint():
    client = create_app().test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_ready_endpoint():
    client = create_app().test_client()
    response = client.get("/ready")
    assert response.status_code == 200
    data = response.get_json()
    assert data["healthy"] is True
    assert "iso_27001" in data["compliances"]


def test_echo_masks_password():
    app = create_app()
    client = app.test_client()
    payload = {"username": "alice", "password": "secret"}
    response = client.post("/api/v1/echo", json=payload)
    assert response.status_code == 200
    body = response.get_json()
    assert body["received"]["password"] == "***"
    assert body["received"]["username"] == "alice"
