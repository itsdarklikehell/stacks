#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
    base.docker-compose.yaml
    autoheal/docker-compose.yaml
    autobrr/docker-compose.yaml
    bazarr/docker-compose.yaml
    buildarr/docker-compose.yaml
    byparr/docker-compose.yaml
    calendarr/docker-compose.yaml
    checkrr/docker-compose.yaml
    dasharr/docker-compose.yaml
    flaresolverr/docker-compose.yaml
    flemmarr/docker-compose.yaml
    jellyseerr/docker-compose.yaml
    kapowarr/docker-compose.yaml
    lidarr/docker-compose.yaml
    logarr/docker-compose.yaml
    # mylar3/docker-compose.yaml
    organizr/docker-compose.yaml
    overseerr/docker-compose.yaml
    prowlarr/docker-compose.yaml
    radarr/docker-compose.yaml
    requestrr/docker-compose.yaml
    rreading-glasses/docker-compose.yaml
    sonarr/docker-compose.yaml
    sickgear/docker-compose.yaml
    watchtower/docker-compose.yaml
    whisparr/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
    ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

docker compose $ARGS up -d
# docker compose $ARGS up -d --build --force-recreate --remove-orphans