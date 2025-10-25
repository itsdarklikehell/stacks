#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	autoheal
	nginx-proxy-manager
	portainer
	watchtower
	# autopulse
	# docker-proxy
	# dockge
	# grafana
	homarr
	dashy
	# it-tools
	# portracker
	# uptime-kuma
	# wolf
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	echo "Added: ${f}/docker-compose.yaml"
	ARGS+="-f ${f}/docker-compose.yaml "
done

function BUILDING() {
	echo ""
	echo "Building is set to: ${BUILDING}"
	echo ""
	if [[ ${BUILDING} == "force_rebuild" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
	elif [[ ${BUILDING} == "true" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi
}
BUILDING
