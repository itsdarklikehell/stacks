#!/bin/bash

set -e
cd "$(dirname "$0")"

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

COMPOSE_FILES=(
	autobrr
	bazarr
	buildarr
	byparr
	calendarr
	checkrr
	dasharr
	flaresolverr
	flemmarr
	jellyseerr
	kapowarr
	lidarr
	logarr
	# mylar3
	organizr
	overseerr
	prowlarr
	radarr
	requestrr
	rreading-glasses
	sonarr
	sickgear
	whisparr
)

function CREATE_FOLDERS() {
	for FOLDERNAME in "${FOLDERS[@]}"; do
		if [[ ! -d "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}" ]]; then
			echo "Creating folder: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
			mkdir -p "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
		else
			echo "Folder already exists: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}, skipping creation"
		fi
	done
}

function SETUP_FOLDERS() {
	if [[ ${SERVICE_NAME} == "autobrr" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "bazarr" ]]; then
		FOLDERS=(
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "buildarr" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "calendarr" ]]; then
		FOLDERS=(
			"custom_footers"
			"logs"
		)
	fi

	if [[ ${SERVICE_NAME} == "checkrr" ]]; then
		FOLDERS=(
			"config"
			"data"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "dasharr" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "flemmarr" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "jellyseerr" ]]; then
		FOLDERS=(
			"config"
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "kapowarr" ]]; then
		FOLDERS=(
			"db"
			"downloads"
			"comics_folder"
		)
	fi

	if [[ ${SERVICE_NAME} == "lidarr" ]]; then
		FOLDERS=(
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "logarr" ]]; then
		FOLDERS=(
			"config"
			"logs"
		)
	fi

	if [[ ${SERVICE_NAME} == "mylar3" ]]; then
		FOLDERS=(
			"config"
			"comics"
			"downloads"
		)
	fi

	if [[ ${SERVICE_NAME} == "overseerr_data" ]]; then
		FOLDERS=(
			"config"
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "prowlarr" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "radarr" ]]; then
		FOLDERS=(
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "requestrr" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "sickgear" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "sonarr" ]]; then
		FOLDERS=(
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "whisparr" ]]; then
		FOLDERS=(
			"config"
			"media"
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
