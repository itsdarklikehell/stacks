#!/bin/bash
# set -e

echo "Start browser games script started."

IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
export IP_ADDRESS

export IP_ADDRESS=0.0.0.0

URLS=(
	"https://${IP_ADDRESS}:7001" # azahar
	"https://${IP_ADDRESS}:7003" # citron
	"https://${IP_ADDRESS}:7009" # dolphin
	"https://${IP_ADDRESS}:7011" # dosbox
	"https://${IP_ADDRESS}:7013" # duckstation
	"https://${IP_ADDRESS}:7015" # flycast
	"http://${IP_ADDRESS}:7022"  # luanti
	"https://${IP_ADDRESS}:7023" # mame
	"https://${IP_ADDRESS}:7025" # melonds
	"https://${IP_ADDRESS}:7029" # modrinth
	"https://${IP_ADDRESS}:7031" # pcsx2
	"https://${IP_ADDRESS}:7033" # retroarch
	"https://${IP_ADDRESS}:7035" # rpcs3
	"https://${IP_ADDRESS}:7037" # scummvm
	"https://${IP_ADDRESS}:7045" # xemu
)

function RUN_BROWSER() {

	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

}

RUN_BROWSER
