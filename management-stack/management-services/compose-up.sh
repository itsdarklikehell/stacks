#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

  # docker-compose.clickhouse-server.yaml
COMPOSE_FILES=(
  base.docker-compose.yaml
  collabora.docker-compose.yaml
  dashy.docker-compose.yaml
  docker-proxy.docker-compose.yaml
  grafana.docker-compose.yaml
  it-tools.docker-compose copy.yaml
  n8n.docker-compose.yaml
  netdata.docker-compose.yaml
  nextcloud.docker-compose.yaml
  nextclouddb.docker-compose.yaml
  organizr.docker-compose.yaml
  redis.docker-compose.yaml
  ubuntu-desktop-lxde-vnc.docker-compose.yaml
  wg-easy.docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

docker login
# docker compose $ARGS up -d
docker compose $ARGS up -d --build --force-recreate --remove-orphans