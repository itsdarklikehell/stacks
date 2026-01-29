#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	# azahar
	# citron
	# code-server
	# dogwalk
	# dolphin
	# dosbox-staging
	# duckstation
	# emulatorjs
	# flaresolverr
	# flycast
	# # gamevault
	# gameyfin
	# gaseous-server
	# # gzdoom
	# healthchecks
	# luanti
	# mame
	# melonds
	# modmanager
	# modrinth
	# # mpd
	# # mympd
	# openttd
	# owncast
	# obs-studio
	# pcsx2
	# retroarch
	# retrom
	# sunshine
	# # romm
	# rpcs3
	# scummvm
	# synctube
	project-zomboid
	# vscodium
	# vscodium-web
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

	if [[ ${SERVICE_NAME} == "azahar" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "sunshine" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "openttd" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"save"
		)

	fi

	if [[ ${SERVICE_NAME} == "obs-studio" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"recordings"
		)

	fi

	if [[ ${SERVICE_NAME} == "emulatorjs" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "retrom" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"roms"
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "gamevault" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"files"
			"media"
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "romm" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"resources"
			"redis_data"
			"library"
			"assets"
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "gameyfin" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"database"
			"data"
			"plugindata"
			"logs"
			"games"
		)

	fi

	if [[ ${SERVICE_NAME} == "gaseous-server" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "synctube" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"user"
		)

	fi

	if [[ ${SERVICE_NAME} == "wolf" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"etc"
		)

	fi

	if [[ ${SERVICE_NAME} == "owncast" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"data"
		)

	fi

	if [[ ${SERVICE_NAME} == "citron" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "code-server" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "dogwalk" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "dolphin" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "dosbox-staging" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "duckstation" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "flycast" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "gzdoom" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"wads"
		)

	fi

	if [[ ${SERVICE_NAME} == "healthchecks" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "luanti" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "mame" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "melonds" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "modmanager" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"modcache"
		)

	fi

	if [[ ${SERVICE_NAME} == "modrinth" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "pcsx2" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "retroarch" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "rpcs3" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "steamos" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "scummvm" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "vscodium" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "vscodium-web" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "xemu" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "mpd" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"run"
			"configdir"
			"music"
			"playlists"
			"workdir"
			"cachedir"
		)

		if [[ ! -f "${FOLDER}/mpd_confidir/mpd.conf" ]]; then
			wget -c https://raw.githubusercontent.com/andrewrk/mpd/refs/heads/master/doc/mpdconf.example -O "${FOLDER}/mpd_configdir/mpd.conf"
		fi

	fi

	if [[ ${SERVICE_NAME} == "mympd" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"run"
			"configdir"
			"music"
			"playlists"
			"workdir"
			"cachedir"
		)

		if [[ ! -f "${FOLDER}/mympd_configdir/mpd.conf" ]]; then
			wget -c https://raw.githubusercontent.com/andrewrk/mpd/refs/heads/master/doc/mpdconf.example -O "${FOLDER}/mympd_configdir/mpd.conf"
		fi

	fi

	if [[ ${SERVICE_NAME} == "project-zomboid" ]]; then

		declare -a FOLDERS=()
		FOLDERS=(
			"data"
		)

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${STACK_BASEPATH}/DATA/${SERVICE_NAME}/Dockerfile"

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
