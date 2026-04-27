FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    APP_ENV=container \
    AWS_REGION=eu-west-2 \
    LOG_LEVEL=INFO \
    PYTHONPATH=/workspace/app

WORKDIR /workspace

RUN addgroup --system app && adduser --system --ingroup app app

COPY requirements.txt /workspace/app/requirements.txt

RUN python -m pip install --upgrade pip && \
    python -m pip install -r /workspace/app/requirements.txt

COPY alembic.ini /workspace/app/alembic.ini
COPY migrations /workspace/app/migrations
COPY crudapp /workspace/app/crudapp

RUN chown -R app:app /workspace

USER app

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health/live', timeout=3)"

CMD ["gunicorn", "crudapp.main:app", "--worker-class", "uvicorn.workers.UvicornWorker", "--workers", "2", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-", "--timeout", "60"]