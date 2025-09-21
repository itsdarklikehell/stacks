#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  docker-compose.base.yaml
  docker-compose.autobrr.yaml
  docker-compose.autopulse.yaml
  docker-compose.bazarr.yaml
  docker-compose.buildarr.yaml
  docker-compose.byparr.yaml
  docker-compose.calendarr.yaml
  docker-compose.calibre-web.yaml
  docker-compose.checkrr.yaml
  docker-compose.dasharr.yaml
  docker-compose.emby.yaml
  docker-compose.flaresolverr.yaml
  docker-compose.flemmarr.yaml
  docker-compose.flexget.yaml
  docker-compose.gaseous-server.yaml
  docker-compose.gsdb.yaml
  docker-compose.jellyfin.yaml
  docker-compose.jellyseerr.yaml
  docker-compose.kapowarr.yaml
  docker-compose.lidarr.yaml
  docker-compose.mattermost.yaml
  docker-compose.mylar3.yaml
  docker-compose.organizr.yaml
  docker-compose.overseerr.yaml
  docker-compose.plex.yaml
  docker-compose.prowlarr.yaml
  docker-compose.radarr.yaml
  docker-compose.requestrr.yaml
  docker-compose.retroarch.yaml
  docker-compose.retroarchz.yaml
  docker-compose.romm-db.yaml
  docker-compose.romm.yaml
  docker-compose.rreading-glasses.yaml
  docker-compose.sickgear.yaml
  docker-compose.sonarr.yaml
  docker-compose.tvs99.yaml
  docker-compose.webrcade.yaml
  docker-compose.whisparr.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

# docker compose $ARGS up -d
docker compose $ARGS up -d --build --force-recreate --remove-orphans