# Validation Checklist (manual smoke tests)

1) Build image

```bash
docker build -f Dockerfile-<name> -t <name>:local .
```

2) Start service

```bash
SCRIPTS/start_<name>.sh
```

3) Check logs
- Inspect `DATA/<stack>/logs` or any `logs-` directories produced by the start script.

4) Confirm mounts & permissions
- Ensure `DATA/<name>` and `SECRETS/<name>` exist and are readable by the container.

5) Smoke endpoint
- If service exposes HTTP/RPC, run a quick health check (e.g. `curl http://localhost:PORT/health`).

6) Update docs
- Add runtime requirements to `README.md` or `SCRIPTS/conf-<name>.yaml`.
