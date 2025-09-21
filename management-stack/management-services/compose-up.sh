#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

  # docker-compose.clickhouse-server.yaml
COMPOSE_FILES=(
  docker-compose.autoheal.yaml
  docker-compose.base.yaml
  docker-compose.collabora.yaml
  docker-compose.dashy.yaml
  docker-compose.docker-proxy.yaml
  docker-compose.dockge.yaml
  docker-compose.n8n.yaml
  docker-compose.netdata.yaml
  docker-compose.nextcloud.yaml
  docker-compose.nextclouddb.yaml
  docker-compose.grafana.yaml
  docker-compose.nginx-proxy-manager.yaml
  docker-compose.portainer.yaml
  docker-compose.portracker.yaml
  docker-compose.redis.yaml
  docker.compose.ubuntu-desktop-lxde-vnc.yaml
  docker-compose.uptime-kuma.yaml
  docker-compose.watchtower.yaml
  docker-compose.wg-easy.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

# docker compose $ARGS up -d
docker compose $ARGS up -d --build --force-recreate --remove-orphans