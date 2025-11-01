#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	# nextcloud
	autoheal
	autopulse
	beszel
	code-server
	dashy
	docker-proxy
	dockge
	homarr
	it-tools
	traefik
	ouroboros
	kubepi
	nginx-proxy-manager
	pairdrop
	portainer
	portracker
	uptime-kuma
	vscodium
	watchtower
	wolf
)

function CREATE_FOLDERS() {
	for FOLDERNAME in "${FOLDERS[@]}"; do
		if [[ ! -d "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}" ]]; then
			echo "Creating folder: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
			mkdir -p "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
		# else
		# 	echo "Folder already exists: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}, skipping creation"
		fi
	done
}

function SETUP_FOLDERS() {
	if [[ ${SERVICE_NAME} == "beszel" ]]; then
		FOLDERS=(
			"data"
			"agent_data"
			"socket"
		)
	fi

	if [[ ${SERVICE_NAME} == "traefik" ]]; then
		FOLDERS=(
			"certs"
			"dynamic"
		)
	fi

	if [[ ${SERVICE_NAME} == "code-server" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "dashy" ]]; then
		FOLDERS=(
			"config"
			"data"
		)
		CREATE_FOLDERS
		if [[ ! -f "${FOLDER}/${SERVICE_NAME}_config/conf.yml" ]]; then
			echo "Downloading example dashy config.yml"
			wget https://gist.githubusercontent.com/Lissy93/000f712a5ce98f212817d20bc16bab10/raw/b08f2473610970c96d9bc273af7272173aa93ab1/Example%25203%2520-%2520Demo%2520Home%2520Lab%2520-%2520conf.yml -O "${FOLDER}/${SERVICE_NAME}_config/conf.yml"
		fi
	fi

	if [[ ${SERVICE_NAME} == "dockge" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "homarr" ]]; then
		FOLDERS=(
			"appdata"
		)
	fi

	if [[ ${SERVICE_NAME} == "nextcloud" ]]; then
		FOLDERS=(
			"config"
			"data"
			"aio_mastercontainer"
		)
	fi

	if [[ ${SERVICE_NAME} == "nginx-proxy-manager" ]]; then
		FOLDERS=(
			"data"
			"letsencrypt"
		)
	fi

	if [[ ${SERVICE_NAME} == "portainer" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "portracker" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "uptime-kuma" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "vscodium" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "wolf" ]]; then
		FOLDERS=(
			"etc"
		)
	fi
	CREATE_FOLDERS
}

ARGS=""
for SERVICE_NAME in "${COMPOSE_FILES[@]}"; do
	ARGS+="-f ${SERVICE_NAME}/docker-compose.yaml "
	FOLDER="../../../DATA/${STACK_NAME}-stack/${SERVICE_NAME}"
	if [[ ! -d ${FOLDER} ]]; then
		echo ""
		echo "Creating folder: ${FOLDER}"
		mkdir -p "${FOLDER}"
	# else
	# 	echo ""
	# 	echo "Folder already exists: ${FOLDER}, skipping creation"
	fi
	SETUP_FOLDERS
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
