#!/bin/bash

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
	if [[ ${f} == "wolf" ]]; then
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
		mkdir -p "${FOLDER}/${f}_config"
		if [[ ! -f "${FOLDER}/${f}_config/conf.yml" ]]; then
			cd "${FOLDER}/${f}_config" || exit 1
			wget https://gist.githubusercontent.com/Lissy93/000f712a5ce98f212817d20bc16bab10/raw/b08f2473610970c96d9bc273af7272173aa93ab1/Example%25203%2520-%2520Demo%2520Home%2520Lab%2520-%2520conf.yml -O "conf.yml"
		fi
		# touch "${FOLDER}/${f}_data/conf.yml"
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
