#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	# airsonic-advanced
	# ardour
	# audacity
	# bazarr
	# beets
	# copyparty
	# darktable
	# digikam
	# doplarr
	# emby
	# emby-wrapped
	# gimp
	# handbrake
	# htpcmanager
	# jellyseer
	# kdenlive
	# kometa
	# krita
	# lidarr
	# lollypop
	# lychee
	# mediaelch
	# medusa
	# minisatip
	# mstream
	# ombi
	# blockbusterr
	# openshot
	# oscam
	# overseerr
	# cinephage
	# piwigo
	# plex
	# prowlarr
	# radarr
	# rawtherapee
	# shotcut
	# sickgear
	# sonarr
	# spotube
	# synclounge
	# tautulli
	# tvheadend
	tvs-server
	# sunvox-webtop
	# vlc
	# webgrabplus
	# your_spotify
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

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "cinephage" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"data"
			"logs"
			"media"
		)

	fi

	if [[ ${SERVICE_NAME} == "birdnet-pi" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"ssl"
		)

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${FOLDER}/Dockerfile"

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}/Dockerfile" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${FOLDER}/Dockerfile"
		fi

	fi

	if [[ ${SERVICE_NAME} == "blockbusterr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "rawtherapee" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "emby-wrapped" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "gimp" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "krita" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "digikam" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "kdenlive" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "openshot" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "shotcut" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "lychee" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"pictures"
		)

	fi

	if [[ ${SERVICE_NAME} == "piwigo" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"pictures"
		)

	fi

	if [[ ${SERVICE_NAME} == "lollypop" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "darktable" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "your_spotify" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "spotube" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "webgrabplus" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "tautulli" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "tvheadend" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"recordings"
		)

	fi

	if [[ ${SERVICE_NAME} == "oscam" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "synclounge" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "minisatip" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "airsonic-advanced" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"playlists"
			"podcasts"
			"music"
		)

	fi

	if [[ ${SERVICE_NAME} == "mstream" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"music"
			"tvseries"
			"movies"
			"audiobooks"
			"concerts"
			"podcasts"
			"recordings"
		)

	fi

	if [[ ${SERVICE_NAME} == "htpcmanager" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "beets" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"downloads"
			"music"
		)

	fi

	if [[ ${SERVICE_NAME} == "emby" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"movies"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "plex" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"movies"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "kometa" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "overseerr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "vlc" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "medusa" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"downloads"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "sickgear" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"downloads"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "mediaelch" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "handbrake" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "audacity" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "jellyseer" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "doplarr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "prowlarr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "lidarr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"downloads"
			"music"
		)

	fi

	if [[ ${SERVICE_NAME} == "bazarr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"tvseries"
			"movies"
		)

	fi

	if [[ ${SERVICE_NAME} == "radarr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"downloads"
			"movies"
		)

	fi

	if [[ ${SERVICE_NAME} == "sonarr" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"downloads"
			"tvseries"
		)

	fi

	if [[ ${SERVICE_NAME} == "ombi" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "sunvox-webtop" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

		cp -rf "${STACK_BASEPATH}/SCRIPTS/autostart-${SERVICE_NAME}.sh" "${FOLDER}/autostart.sh"

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}/autostart.sh" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/autostart-${SERVICE_NAME}.sh" "${FOLDER}/autostart.sh"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${FOLDER}/Dockerfile"

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}/Dockerfile" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${FOLDER}/Dockerfile"
		fi

	fi

	if [[ ${SERVICE_NAME} == "tvs-server" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"content"
		)

		mkdir -p "${FOLDER}/${SERVICE_NAME}_content"

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}_content/config.tvs.yml" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/config.tvs.yml" "${FOLDER}/${SERVICE_NAME}_content/config.tvs.yml"
		fi

		if [[ -f "${FOLDER}/${SERVICE_NAME}_content/config.tvs.yml" ]]; then
			cp -rf "${FOLDER}/${SERVICE_NAME}_content/config.tvs.yml" "${FOLDER}/${SERVICE_NAME}_content/config.tvs.yml".bak
		fi

		# wget -c https://github.com/zshall/program-guide/releases/download/v5.7.0-beta/tvs-5.7.0-beta.zip >/dev/null 2>&1
		# unzip -o tvs-5.7.0-beta.zip -d "${FOLDER}/${SERVICE_NAME}_content" >/dev/null 2>&1
		# rm tvs-5.7.0-beta.zip

	fi

	if [[ ${SERVICE_NAME} == "copyparty" ]]; then

		mkdir -p "${FOLDER}/${SERVICE_NAME}_configs"

		if [[ ! -f ${FOLDER}/${SERVICE_NAME}_configs/config.conf ]]; then
			cp -rf "${FOLDER}/docs/examples/docker/basic-docker-compose/${SERVICE_NAME}.conf" "${FOLDER}/${SERVICE_NAME}_configs/config.conf"
		fi

		if [[ -f ${FOLDER}/${SERVICE_NAME}_configs/config.conf ]]; then
			cp -rf "${FOLDER}/${SERVICE_NAME}_configs/config.conf" "${FOLDER}/${SERVICE_NAME}_configs/config.conf".bak
		fi

		if [[ -f ${FOLDER}/${SERVICE_NAME}_configs/config.conf.bak ]]; then
			cp -rf "${FOLDER}/${SERVICE_NAME}_configs/config.conf.bak" "${FOLDER}/${SERVICE_NAME}_configs/config.conf"
		fi

		declare -a FOLDERS=()
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
