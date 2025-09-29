SHELL := /bin/bash

.PHONY: install install-dev test lint security docker-build docker-run format

install:
	python -m venv .venv
	. .venv/bin/activate && pip install -r app/requirements.txt

install-dev: install
	. .venv/bin/activate && pip install -r app/requirements-dev.txt

lint:
	. .venv/bin/activate && flake8 app/src app/tests

security:
	. .venv/bin/activate && bandit -r app/src
	. .venv/bin/activate && pip-audit -r app/requirements.txt

test:
	. .venv/bin/activate && pytest

format:
	. .venv/bin/activate && black app/src app/tests

docker-build:
	docker build -t cyber-sec-app:local .

docker-run:
	docker run --rm -p 8080:8080 cyber-sec-app:local
