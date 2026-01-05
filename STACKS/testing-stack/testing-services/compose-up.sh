#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	azahar
	citron
	code-server
	dogwalk
	dolphin
	dosbox-staging
	duckstation
	flycast
	# gzdoom
	healthchecks
	luanti
	mame
	melonds
	modmanager
	modrinth
	pcsx2
	retroarch
	rpcs3
	scummvm
	# steamos
	vscodium
	vscodium-web
	xemu
	mpd
	mympd
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

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "citron" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "code-server" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "dogwalk" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "dolphin" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "dosbox-staging" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "duckstation" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "flycast" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "gzdoom" ]]; then

		FOLDERS=(
			"config"
			"wads"
		)

	fi

	if [[ ${SERVICE_NAME} == "healthchecks" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "luanti" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "mame" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "melonds" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "modmanager" ]]; then

		FOLDERS=(
			"modcache"
		)

	fi

	if [[ ${SERVICE_NAME} == "modrinth" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "pcsx2" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "retroarch" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "rpcs3" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "steamos" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "scummvm" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "vscodium" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "vscodium-web" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "xemu" ]]; then

		FOLDERS=(
			"config"
		)

	fi

	if [[ ${SERVICE_NAME} == "mpd" ]]; then

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
