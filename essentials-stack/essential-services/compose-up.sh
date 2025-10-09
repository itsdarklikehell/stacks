#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  base.docker-compose.yaml
  autoheal/docker-compose.yaml 
  # autopulse/docker-compose.yaml 
  docker-proxy/docker-compose.yaml 
  dockge/docker-compose.yaml 
  grafana/docker-compose.yaml 
  it-tools/docker-compose.yaml 
  nginx-proxy-manager/docker-compose.yaml 
  portainer/docker-compose.yaml 
  portracker/docker-compose.yaml 
  uptime-kuma/docker-compose.yaml 
  watchtower/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
    ARGS+="-f ${f} "
done

echo "Running: docker compose ${ARGS} up -d"

function BUILDING(){
    echo ""
    echo "Building is set to: $BUILDING"
    echo ""
    if [[ "$BUILDING" = "recreate" ]]; then
        docker compose ${ARGS} up -d --build --force-recreate --remove-orphans
    elif [[ "$BUILDING" = "true" ]]; then
        docker compose ${ARGS} up -d
    elif [[ "$BUILDING" = "false" ]]; then
        echo "Skipping docker compose up"
    fi
}
BUILDING