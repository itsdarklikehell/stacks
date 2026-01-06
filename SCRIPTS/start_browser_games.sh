#!/bin/bash
# set -e

echo "Start browser games script started."

IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
export IP_ADDRESS

export IP_ADDRESS=0.0.0.0

URLS=(
	"https://${IP_ADDRESS}:7001" # azahar
	"http://${IP_ADDRESS}:7002"  # citron
	"http://${IP_ADDRESS}:7008"  # dolphin
	"http://${IP_ADDRESS}:7010"  # dosbox
	"http://${IP_ADDRESS}:7012"  # duckstation
	"http://${IP_ADDRESS}:7014"  # flycast
	"http://${IP_ADDRESS}:7020"  # luanti
	"http://${IP_ADDRESS}:7022"  # mame
	"http://${IP_ADDRESS}:7024"  # melonds
	"http://${IP_ADDRESS}:7026"  # modmanager
	"http://${IP_ADDRESS}:7028"  # modrinth
	"http://${IP_ADDRESS}:7030"  # pcsx2
	"http://${IP_ADDRESS}:7032"  # retroarch
	"http://${IP_ADDRESS}:7034"  # rpcs3
	"http://${IP_ADDRESS}:7036"  # scummvm
	"http://${IP_ADDRESS}:7044"  # xemu
)

function RUN_BROWSER() {

	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

}

RUN_BROWSER
