FROM public.ecr.aws/docker/library/python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8080

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app/requirements-dev.txt requirements-dev.txt
RUN pip install --no-cache-dir -r requirements-dev.txt --no-deps

COPY app/src ./src

EXPOSE 8080

CMD ["gunicorn", "src.main:app", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-"]
