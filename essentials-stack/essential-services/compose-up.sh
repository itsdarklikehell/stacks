#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  autoheal
  # autopulse
  docker-proxy
  dockge
  homarr
  grafana
  it-tools
  nginx-proxy-manager
  portainer
  portracker
  uptime-kuma
  wolf
  watchtower
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
    echo "Added: ${f}/docker-compose.yaml"
    ARGS+="-f ${f}/docker-compose.yaml "
done

function BUILDING(){
    echo ""
    echo "Building is set to: ${BUILDING}"
    echo ""
    if [[ "${BUILDING}" = "recreate" ]]; then
        docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
    elif [[ "${BUILDING}" = "true" ]]; then
        docker compose -f base.docker-compose.yaml ${ARGS} up -d
    elif [[ "${BUILDING}" = "false" ]]; then
        echo "Skipping docker compose up"
    fi
}
BUILDING