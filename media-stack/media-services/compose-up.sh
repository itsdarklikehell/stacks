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
	# emulatorjs
	# flexget
	# flycast
	# gaseous-server
	# gzdoom
	# jellyfin
	# kali-linux
	# mattermost
	# modmanager
	# nextcloud
	# plex
	# qbittorrent
	# quakejs
	# retroarch
	# retroarchz
	# romm
	# romm-mariadb
	# rpcs3
	# steamos
	# transmission
	# tvs99
	# watchtower
	# webcord
	# webrcade
	# wireguard
	viewtube
	# xemu
)

function CREATE_FOLDERS() {
	if [[ ${f} == "wolf" ]]; then
		mkdir -p "${FOLDER}/${f}_etc"
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
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --force-recreate --remove-orphans
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi
}
BUILDING
