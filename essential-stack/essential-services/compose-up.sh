#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	# nextcloud
	autoheal
	autopulse
	code-server
	dashy
	docker-proxy
	dockge
	homarr
	it-tools
	nginx-proxy-manager
	portainer
	portracker
	uptime-kuma
	vscodium
	watchtower
	wolf
)

function CREATE_FOLDERS() {
	if [[ ${f} == "wolfs" ]]; then
		mkdir -p "${FOLDER}/${f}_etc"
	fi
	if [[ ${f} == "uptime-kuma" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "portracker" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "portainer" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "nginx-proxy-manager" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_letsencrypt"
	fi
	if [[ ${f} == "homarr" ]]; then
		mkdir -p "${FOLDER}/${f}_appdata"
	fi
	if [[ ${f} == "dockge" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "dashy" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_lconfig"
	fi
	if [[ ${f} == "nextcloud" ]]; then
		mkdir -p "${FOLDER}/${f}_nextcloud_aio_mastercontainer"
	fi
}

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	ARGS+="-f ${f}/docker-compose.yaml "
	FOLDER="../../DATA/${STACKNAME}-stack/${f}"
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
