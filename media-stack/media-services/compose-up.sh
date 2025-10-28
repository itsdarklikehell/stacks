#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	# autoheal
	# beets
	# calibre-web
	# deluge
	# dolphin
	# duckstation
	# emby
	# flexget
	# flycast
	# gzdoom
	# jellyfin
	# kali-linux
	# mattermost
	# modmanager
	# plex
	# qbittorrent
	quakejs
	retroarch
	# rpcs3
	# steamos
	# transmission
	# watchtower
	# webcord
	# wireguard
	# xemu
	# emulatorjs
	gaseous-server
	retroarchz
	romm
	tvs99
	viewtube
	webrcade
)

function CREATE_FOLDERS() {
	if [[ ${f} == "viewtube" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "gaseous-server" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_mariadb"
	fi
	if [[ ${f} == "romm" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_resources"
		mkdir -p "${FOLDER}/${f}_config"
		mkdir -p "${FOLDER}/${f}_library"
		mkdir -p "${FOLDER}/${f}_assets"
		mkdir -p "${FOLDER}/${f}_mariadb"
	fi
	if [[ ${f} == "webrcade" ]]; then
		mkdir -p "${FOLDER}/${f}_content"
	fi
	if [[ ${f} == "gzdoom" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
	fi
	if [[ ${f} == "quakejs" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
	fi
	if [[ ${f} == "retroarch" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
	fi
	if [[ ${f} == "tvs99" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_config"
	fi
	if [[ ${f} == "retroarchz" ]]; then
		mkdir -p "${FOLDER}/${f}_roms"
	fi
	if [[ ${f} == "plex" ]]; then
		mkdir -p "${FOLDER}/${f}_media"
		mkdir -p "${FOLDER}/${f}_config"
		mkdir -p "${FOLDER}/${f}_transcode"
	fi
}

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	ARGS+="-f ${f}/docker-compose.yaml "
	FOLDER="../../DATA/${STACKNAME}-stack/${f}"
	mkdir -p "${FOLDER}"
	CREATE_FOLDERS
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
