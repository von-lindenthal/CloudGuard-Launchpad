from __future__ import annotations

import logging
import os
from dataclasses import dataclass
from typing import Dict

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
        compliances: Dict[str, str]

    @app.get("/health")
    def health() -> Dict[str, str]:
        return {"status": "ok"}

    @app.get("/ready")
    def ready() -> Dict[str, str]:
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
        return jsonify(status.__dict__)

    @app.post("/api/v1/echo")
    def echo():
        payload = request.get_json(silent=True) or {}
        logger.info("Echo request received", extra={"payload": payload})
        masked_payload = {key: ("***" if "password" in key else value) for key, value in payload.items()}
        return jsonify({"received": masked_payload}), 200

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
