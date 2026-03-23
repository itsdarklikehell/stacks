# Stacks — Docker-Based Service Orchestration

A modular Docker Compose system for deploying AI, media, management, and essential services on a home server / RAID station.

## Structure

```
STACKS/
├── ai-stack/           # AI services (Ollama, AnythingLLM, ComfyUI, etc.)
├── essential-stack/    # Essential utilities (PostgreSQL, Redis, etc.)
├── monitoring-stack/   # Prometheus + Grafana + node-exporter + cAdvisor
├── media-stack/        # Media services (Plex, Jellyfin, etc.)
├── backups-stack/      # Backup solutions (Duplicati, Syncthing, etc.)
├── chat-stack/         # Chat platforms (Matrix, Telegram, etc.)
└── ...                 # Additional stacks
```

## Improvements Applied

- ✅ **Health checks** added to all AI services for automatic restart
- ✅ **PostgreSQL backup script** (`SCRIPTS/backup-postgres-all.sh`)
- ✅ **Monitoring stack** (Prometheus, Grafana, node-exporter, cAdvisor)
- ✅ **Unified logging** (json-file with rotation)
- ✅ **Auto-heal labels** for Watchtower/Ouroboros

## Quick Start

Install Docker and Docker Compose, then run the install script:

```bash
cd /media/rizzo/RAIDSTATION/stacks
./SCRIPTS/install-stack.sh
```

Or bring up individual stacks manually:

```bash
# AI Stack
docker compose -f STACKS/ai-stack/ai-services/base.docker-compose.yaml up -d

# Monitoring
docker compose -f STACKS/monitoring-stack/docker-compose.yml up -d
```

## Health Checks

All core services now include healthchecks so Docker can automatically restart unhealthy containers.

Check status:
```bash
docker ps --filter "health=unhealthy"
```

## Monitoring

- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- Pre-configured datasource and modelrelay dashboards
- Alert rules for: service down, high error rate, circuit breaker open, low cache hit, high latency, upstream failures

## Backups

PostgreSQL volumes are backed up daily:

```bash
# All PostgreSQL volumes (discovered automatically)
/media/rizzo/RAIDSTATION/stacks/SCRIPTS/backup-postgres-all.sh

# Specific volume (original simple script)
/media/rizzo/RAIDSTATION/stacks/SCRIPTS/backup-postgres.sh
```

Backups stored in: `/media/rizzo/RAIDSTATION/BACKUPS/postgres/`

## Service Discovery

Services communicate via Docker networks:
- `host` network for direct localhost access
- `ai-services`, `essential-services`, etc. for internal traffic

## Security Notes

- API keys and secrets stored in `SECRETS/` directory (Docker secrets or `.env` files)
- Consider enabling TLS for external services via reverse proxy (Traefik/Nginx)
- Regularly scan images with Trivy: `trivy image <image>`
- Pin image digests in production for reproducibility

## Troubleshooting

- Check container logs: `docker logs <container>`
- Restart a service: `docker restart <container>`
- Rebuild a service: `docker compose -f <compose> up -d --build`
- Healthcheck failures: `docker inspect <container> | grep -A5 Health`

## Adding New Services

1. Create a new stack directory (e.g., `new-stack/`)
2. Add service compose files under `new-stack/services/`
3. Integrate with main compose using `-f` includes or a root docker-compose.yml
4. Add to `install-stack.sh` if needed

## Resources

- Each service runs with resource limits where appropriate
- GPU passthrough configured for AI services requiring CUDA
- Volumes mounted for persistent data under `DATA/` and `SECRETS/`
