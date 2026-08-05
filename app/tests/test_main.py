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


def test_echo_masks_nested_and_case_insensitive_passwords():
    app = create_app()
    client = app.test_client()
    payload = {
        "profile": {"Password": "secret", "token": "abc"},
        "items": [{"db_password": "hidden"}, {"value": 1}],
    }
    response = client.post("/api/v1/echo", json=payload)

    assert response.status_code == 200
    body = response.get_json()
    assert body["received"]["profile"]["Password"] == "***"
    assert body["received"]["profile"]["token"] == "abc"
    assert body["received"]["items"][0]["db_password"] == "***"
    assert body["received"]["items"][1]["value"] == 1
