#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  base.docker-compose.yaml
  autoheal/docker-compose.yaml 
  calibre-web/docker-compose.yaml 
  emby/docker-compose.yaml 
  flexget/docker-compose.yaml 
  gaseous-server/docker-compose.yaml 
  gsdb/docker-compose.yaml 
  gzdoom/docker-compose.yaml 
  jellyfin/docker-compose.yaml 
  mattermost/docker-compose.yaml 
  plex/docker-compose.yaml 
  quakejs/docker-compose.yaml 
  retroarch/docker-compose.yaml 
  retroarchz/docker-compose.yaml 
  romm/docker-compose.yaml 
  romm-db/docker-compose.yaml 
  tvs99/docker-compose.yaml 
  watchtower/docker-compose.yaml 
  webrcade/docker-compose.yaml 
  wolf/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
    ARGS+="-f ${f} "
done

echo "Running: docker compose ${ARGS} up -d"

docker compose ${ARGS} up -d
# docker compose ${ARGS} up -d --build --force-recreate --remove-orphans