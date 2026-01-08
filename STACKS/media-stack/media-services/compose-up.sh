#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	airsonic-advanced
	ardour
	audacity
	bazarr
	copyparty
	doplarr
	handbrake
	jellyseer
	plex
	kometa
	lidarr
	mediaelch
	medusa
	ombi
	overseerr
	prowlarr
	radarr
	sickgear
	sonarr
	tvs-server
	vlc
	minisatip
	emby
	htpcmanager
	plex
	mstream
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

	if [[ ${SERVICE_NAME} == "ardour" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "minisatip" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "airsonic-advanced" ]]; then

		FOLDERS=(
			"config"
			"playlists"
			"podcasts"
			"music"
		)

	fi

	if [[ ${SERVICE_NAME} == "mstream" ]]; then

		FOLDERS=(
			"config"
			"music"
		)

	fi

	if [[ ${SERVICE_NAME} == "htpcmanager" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "emby" ]]; then

		FOLDERS=(
			"config"
			"movies"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "plex" ]]; then

		FOLDERS=(
			"config"
			"movies"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "kometa" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "overseerr" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "vlc" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "medusa" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "sickgear" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "mediaelch" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "handbrake" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "audacity" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "jellyseer" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "doplarr" ]]; then

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

	if [[ ${SERVICE_NAME} == "bazarr" ]]; then

		FOLDERS=(
			"config"
			"tvseries"
			"movies"
		)

	fi

	if [[ ${SERVICE_NAME} == "radarr" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"movies"
		)

	fi

	if [[ ${SERVICE_NAME} == "sonarr" ]]; then

		FOLDERS=(
			"config"
			"downloads"
			"tvseries"
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
