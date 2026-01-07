#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	tvs-server
	copyparty
	jellyseer
	ombi
	prowlarr
	lidarr
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

	if [[ ${SERVICE_NAME} == "jellyseer" ]]; then

		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "prowlarr" ]]; then

		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "lidarr" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"music"
		)
	fi

	if [[ ${SERVICE_NAME} == "radarr" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"movies"
		)
	fi

	if [[ ${SERVICE_NAME} == "readarr" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"books"
		)
	fi

	if [[ ${SERVICE_NAME} == "ombi" ]]; then

		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "tvs-server" ]]; then

		if [[ -f "${FOLDER}/tvs-server_content/config.tvs.yml" ]]; then
			cp "${FOLDER}/tvs-server_content/config.tvs.yml" "${FOLDER}/tvs-server_content/config.tvs.yml".bak
		fi

		mkdir -p "${FOLDER}/tvs-server_content"
		wget -c https://github.com/zshall/program-guide/releases/download/v5.7.0-beta/tvs-5.7.0-beta.zip >/dev/null 2>&1
		unzip -o tvs-5.7.0-beta.zip -d "${FOLDER}/tvs-server_content" >/dev/null 2>&1
		rm tvs-5.7.0-beta.zip

		if [[ -f "${FOLDER}/tvs-server_content/config.tvs.yml.bak" ]]; then
			mv -f "${FOLDER}/tvs-server_content/config.tvs.yml.bak" "${FOLDER}/tvs-server_content/config.tvs.yml"
		fi

		FOLDERS=(
			"content"
		)
	fi

	if [[ ${SERVICE_NAME} == "copyparty" ]]; then

		mkdir -p "${FOLDER}/copyparty_configs"

		if [[ ! -f ${FOLDER}/copyparty_configs/config.conf ]]; then
			cp "${FOLDER}/docs/examples/docker/basic-docker-compose/copyparty.conf" "${FOLDER}/copyparty_configs/config.conf"
		fi

		if [[ -f ${FOLDER}/copyparty_configs/config.conf ]]; then
			cp "${FOLDER}/copyparty_configs/config.conf" "${FOLDER}/copyparty_configs/config.conf".bak
		fi

		if [[ -f ${FOLDER}/copyparty_configs/config.conf.bak ]]; then
			cp "${FOLDER}/copyparty_configs/config.conf.bak" "${FOLDER}/copyparty_configs/config.conf"
		fi

		FOLDERS=(
			"db"
			"uploads"
			"configs"
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
