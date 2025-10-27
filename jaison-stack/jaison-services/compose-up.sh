#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	autoheal
	jaison-core
	watchtower
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	echo "Added: ${f}/docker-compose.yaml"
	ARGS+="-f ${f}/docker-compose.yaml "
done
for f in "${COMPOSE_FILES[@]}"; do
	FOLDER="../../DATA/${STACKNAME}-stack/${f}"
	echo "Making folder: ${FOLDER}"
	mkdir -p "${FOLDER}"
	CREATE_FOLDERS
done

function BUILDING() {
	echo ""
	echo "Building is set to: ${BUILDING}"
	echo ""
	if [[ ${BUILDING} == "force_rebuild" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
	elif [[ ${BUILDING} == "true" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --force-recreate --remove-orphans
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi
}
BUILDING
