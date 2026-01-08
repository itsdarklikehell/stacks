#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	autoheal
	apprise-api
	# autopulse
	dozzle
	dashy
	# scanopy
	# clair
	# homarr
	immich-server
	it-tools
	jellyfin
	nginx-proxy-manager
	nextcloud
	motioneye
	hishtory-server
	portainer
	portracker
	pulse
	beszel
	heimdall
	# watchtower
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

	if [[ ${SERVICE_NAME} == "homarr" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "hishtory-server" ]]; then
		FOLDERS=(
			"data"
		)
		if [[ ! -f "${FOLDER}/${SERVICE_NAME}_data/history.db" ]]; then
			sudo touch "${FOLDER}/${SERVICE_NAME}_data/history.db"
		fi
	fi

	if [[ ${SERVICE_NAME} == "apprise-api" ]]; then
		FOLDERS=(
			"config"
			"attachments"
		)
	fi

	if [[ ${SERVICE_NAME} == "habridge" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "pulse" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "heimdall" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "scanopy" ]]; then
		FOLDERS=(
			"server-data"
			"daemon-config"
			"postgres-data"
		)
	fi

	if [[ ${SERVICE_NAME} == "jellyfin" ]]; then

		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

		FOLDERS=(
			"audiobooks"
			"books"
			"config"
			"movies"
			"music"
			"photos"
			"podcasts"
			"recordings"
			"concerts"
			"tvseries"
		)
	fi

	if [[ ${SERVICE_NAME} == "beszel" ]]; then
		FOLDERS=(
			"data"
			"socket"
			"agent-data"
		)
	fi

	if [[ ${SERVICE_NAME} == "dozzle" ]]; then

		REMOTE_HOSTNAME=$(hostname)
		export REMOTE_HOSTNAME

		FOLDERS=(
			"data"
			"certs"
		)
	fi

	if [[ ${SERVICE_NAME} == "motioneye" ]]; then

		FOLDERS=(
			"shared"
			"etc"
		)
	fi

	if [[ ${SERVICE_NAME} == "nextcloud" ]]; then

		FOLDERS=(
			"data"
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "immich-server" ]]; then

		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

		FOLDERS=(
			"uploads"
			"model-cache"
			"database"
		)
	fi

	if [[ ${SERVICE_NAME} == "portainer" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "nginx-proxy-manager" ]]; then
		FOLDERS=(
			"data"
			"letsencrypt"
		)
	fi

	if [[ ${SERVICE_NAME} == "portracker" ]]; then
		FOLDERS=(
			"data"
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
		if [[ ${USER} == "hans" ]]; then
			docker compose -f base.hans.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
		else
			docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
		fi
	elif [[ ${BUILDING} == "true" ]] || [[ ${BUILDING} == "normal" ]]; then
		if [[ ${USER} == "hans" ]]; then
			docker compose -f base.hans.docker-compose.yaml ${ARGS} up -d
		else
			docker compose -f base.docker-compose.yaml ${ARGS} up -d
		fi
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi

}

BUILDING
