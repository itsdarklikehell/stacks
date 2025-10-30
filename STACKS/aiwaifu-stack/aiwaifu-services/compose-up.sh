#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	autoheal
	aiwaifu
	watchtower
)

function CREATE_FOLDERS() {
	if [[ ${f} == "aiwafu" ]]; then
		mkdir -p "${FOLDER}/${f}_storage"
	fi
}

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	ARGS+="-f ${f}/docker-compose.yaml "
	FOLDER="../../../DATA/${STACK_NAME}-stack/${f}"
	if [[ ! -d ${FOLDER} ]]; then
		echo "Creating folder: ${FOLDER}"
		mkdir -p "${FOLDER}"
	else
		echo "Folder already exists: ${FOLDER}, skipping creation"
	fi
	CREATE_FOLDERS
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
