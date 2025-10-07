#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  base.docker-compose.yaml
  # autopulse/docker-compose.yaml
  # calibre-web/docker-compose.yaml
  # emby/docker-compose.yaml
  # flexget/docker-compose.yaml
  # gaseous-server/docker-compose.yaml
  # gsdb/docker-compose.yaml
  # jellyfin/docker-compose.yaml
  # mattermost/docker-compose.yaml
  # plex/docker-compose.yaml
  # retroarch/docker-compose.yaml
  # retroarchz/docker-compose.yaml
  # romm-db/docker-compose.yaml
  # romm/docker-compose.yaml
  # webrcade/docker-compose.yaml
  # wolf/docker-compose.yaml
  autobrr/docker-compose.yaml
  bazarr/docker-compose.yaml
  buildarr/docker-compose.yaml
  byparr/docker-compose.yaml
  calendarr/docker-compose.yaml
  checkrr/docker-compose.yaml
  dasharr/docker-compose.yaml
  flaresolverr/docker-compose.yaml
  flemmarr/docker-compose.yaml
  gzdoom/docker-compose.yaml
  jellyseerr/docker-compose.yaml
  kapowarr/docker-compose.yaml
  lidarr/docker-compose.yaml
  mylar3/docker-compose.yaml
  overseerr/docker-compose.yaml
  prowlarr/docker-compose.yaml
  quakejs/docker-compose.yaml
  radarr/docker-compose.yaml
  requestrr/docker-compose.yaml
  rreading-glasses/docker-compose.yaml
  sonarr/docker-compose.yaml
  tvs99/docker-compose.yaml
  whisparr/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

docker compose $ARGS up -d
# docker compose $ARGS up -d --build --force-recreate --remove-orphans