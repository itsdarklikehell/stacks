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

	# modmanager
	# plex
	# qbittorrent
	# quakejs
	# retroarch
	# retroarchz
	# romm
	# rpcs3
	# steamos
	# transmission
	# tvs99
	# viewtube
	# watchtower
	# webcord
	# webrcade
	# wireguard
	# xemu
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
	if [[ ${SERVICE_NAME} == "beets" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_media"
	fi

	if [[ ${SERVICE_NAME} == "calibre-web" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_library"
	fi

	if [[ ${SERVICE_NAME} == "deluge" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi

	if [[ ${SERVICE_NAME} == "dolphin" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
	fi

	if [[ ${SERVICE_NAME} == "duckstation" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
	fi

	if [[ ${SERVICE_NAME} == "emby" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_media"
	fi

	if [[ ${SERVICE_NAME} == "flexget" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi

	if [[ ${SERVICE_NAME} == "flycast" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi

	if [[ ${SERVICE_NAME} == "gaseous-server" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_data"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_mariadb"
	fi

	if [[ ${SERVICE_NAME} == "gzdoom" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi

	if [[ ${SERVICE_NAME} == "kali-linux" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi

	if [[ ${SERVICE_NAME} == "viewtube" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_data"
	fi
	if [[ ${SERVICE_NAME} == "kali-linux" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi
	if [[ ${SERVICE_NAME} == "rpcs3" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi
	if [[ ${SERVICE_NAME} == "xemu" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
	fi
	if [[ ${SERVICE_NAME} == "dolphin" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_downloads"
	fi
	if [[ ${SERVICE_NAME} == "romm" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_data"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_resources"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_library"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_assets"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_mariadb"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_redis_data"
	fi
	if [[ ${SERVICE_NAME} == "webrcade" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_content"
	fi
	if [[ ${SERVICE_NAME} == "quakejs" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi
	if [[ ${SERVICE_NAME} == "retroarch" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi
	if [[ ${SERVICE_NAME} == "tvs99" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_data"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
	fi

	if [[ ${SERVICE_NAME} == "retroarchz" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_roms"
	fi
	if [[ ${SERVICE_NAME} == "plex" ]]; then
		mkdir -p "${FOLDER}/${SERVICE_NAME}_media"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_config"
		mkdir -p "${FOLDER}/${SERVICE_NAME}_transcode"
	fi
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
