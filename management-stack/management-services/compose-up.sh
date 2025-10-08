#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

  # docker-compose.clickhouse-server.yaml
COMPOSE_FILES=(
  base.docker-compose.yaml
  autoheal/docker-compose.yaml
  collabora/docker-compose.yaml
  dashy/docker-compose.yaml
  n8n/docker-compose.yaml
  netdata/docker-compose.yaml
  nextcloud/docker-compose.yaml
  nextclouddb/docker-compose.yaml
  redis/docker-compose.yaml
  ubuntu-noble-desktop/docker-compose.yaml
  watchtower/docker-compose.yaml
  wg-easy/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

docker compose $ARGS up -d
# docker compose $ARGS up -d --build --force-recreate --remove-orphans