# Dockerfile for VTuber TVS99 Manager (CLI, API, Scheduler, WebUI)
FROM python:3.11-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir fastapi uvicorn pyyaml schedule jinja2 requests

EXPOSE 8000 8088

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
