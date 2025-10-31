#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	autoheal
	beets
	calibre-web
	deluge
	dolphin
	duckstation
	emby
	flexget
	flycast
	gaseous-server
	gzdoom
	jellyfin
	kali-linux
	mattermost
	modmanager
	plex
	qbittorrent
	quakejs
	retroarch
	retroarchz
	# romm
	rpcs3
	steamos
	transmission
	tvs99
	viewtube
	# watchtower
	webcord
	webrcade
	# wireguard
	xemu
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
	if [[ ${SERVICE_NAME} == "modmanager" ]]; then
		FOLDERS=(
			"cache"
		)
	fi

	if [[ ${SERVICE_NAME} == "webcord" ]]; then
		FOLDERS=(
			"config"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "steamos" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "transmission" ]]; then
		FOLDERS=(
			"config"
			"downloads"
			"watch"
		)
	fi

	if [[ ${SERVICE_NAME} == "airsonic-advanced" ]]; then
		FOLDERS=(
			"config"
			"music"
			"podcasts"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "qbittorrent" ]]; then
		FOLDERS=(
			"config"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "quakejs" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "plex" ]]; then
		FOLDERS=(
			"config"
			"transcode"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "beets" ]]; then
		FOLDERS=(
			"downloads"
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "calibre-web" ]]; then
		FOLDERS=(
			"library"
		)
	fi

	if [[ ${SERVICE_NAME} == "deluge" ]]; then
		FOLDERS=(
			"downloads"
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "dolphin" ]]; then
		FOLDERS=(
			"config"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "duckstation" ]]; then
		FOLDERS=(
			"config"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "emby" ]]; then
		FOLDERS=(
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "flexget" ]]; then
		FOLDERS=(
			"downloads"
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "flycast" ]]; then
		FOLDERS=(
			"config"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "gaseous-server" ]]; then
		FOLDERS=(
			"mariadb"
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "gzdoom" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "kali-linux" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "romm" ]]; then
		FOLDERS=(
			"data"
			"resources"
			"config"
			"library"
			"assets"
			"mariadb"
			"redis_data"
		)
	fi

	if [[ ${SERVICE_NAME} == "rpcs3" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "xemu" ]]; then
		FOLDERS=(
			"config"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "viewtube" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "webrcade" ]]; then
		FOLDERS=(
			"content"
		)
	fi

	if [[ ${SERVICE_NAME} == "retroarch" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "tvs99" ]]; then
		FOLDERS=(
			"data"
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "retroarchz" ]]; then
		FOLDERS=(
			"roms"
		)
	fi

	if [[ ${SERVICE_NAME} == "plex" ]]; then
		FOLDERS=(
			"media"
			"config"
			"transcode"
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
