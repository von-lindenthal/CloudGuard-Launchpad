from __future__ import annotations

import logging
import os
from dataclasses import asdict, dataclass
from collections.abc import Mapping, Sequence

from flask import Flask, jsonify, request

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_app() -> Flask:
    app = Flask(__name__)

    app.config.from_mapping(
        APP_NAME=os.getenv("APP_NAME", "cyber-sec-app"),
        VERSION=os.getenv("APP_VERSION", "0.1.0"),
    )

    @dataclass
    class Status:
        service: str
        version: str
        healthy: bool
        compliances: dict[str, str]

    def mask_sensitive_data(value):
        if isinstance(value, Mapping):
            masked = {}
            for key, item in value.items():
                if isinstance(key, str) and "password" in key.lower():
                    masked[key] = "***"
                else:
                    masked[key] = mask_sensitive_data(item)
            return masked

        if isinstance(value, list):
            return [mask_sensitive_data(item) for item in value]

        if isinstance(value, tuple):
            return tuple(mask_sensitive_data(item) for item in value)

        if isinstance(value, Sequence) and not isinstance(value, (str, bytes, bytearray)):
            return [mask_sensitive_data(item) for item in value]

        return value

    @app.get("/health")
    def health() -> dict[str, str]:
        return {"status": "ok"}

    @app.get("/ready")
    def ready() -> dict[str, str]:
        status = Status(
            service=app.config["APP_NAME"],
            version=app.config["VERSION"],
            healthy=True,
            compliances={
                "iso_27001": "baseline-controls",
                "nist_csf": "identify-protect-detect",
                "cis": "level-1",
            },
        )
        return jsonify(asdict(status))

    @app.post("/api/v1/echo")
    def echo():
        payload = request.get_json(silent=True)
        if not isinstance(payload, dict):
            payload = {}

        logger.info("Echo request received with %s fields", len(payload))
        masked_payload = mask_sensitive_data(payload)
        return jsonify({"received": masked_payload}), 200

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
