#!/bin/bash
# set -e

echo "Start browser script started."

IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
export IP_ADDRESS
if [[ "${USER}" == "hans" ]]; then
	export IP_ADDRESS
elif [[ "${USER}" == "rizzo" ]]; then
	export IP_ADDRESS
	# export IP_ADDRESS=192.168.178.63
else
	export IP_ADDRESS
fi

function RUN_BROWSER() {

	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

}

# # #### AI URLS
URLS=(
	"http://${IP_ADDRESS}:3001"  # anythingllm
	"http://${IP_ADDRESS}:6013"  # habridge
	"http://${IP_ADDRESS}:8123"  # home assistant
	"http://${IP_ADDRESS}:9090"  # InvokeAI
	"http://${IP_ADDRESS}:8283"  # letta
	"http://${IP_ADDRESS}:8084"  # localai
	"http://${IP_ADDRESS}:5678"  # n8n
	"http://${IP_ADDRESS}:11434" # ollama
	"http://${IP_ADDRESS}:8080"  # open-webui
	"http://${IP_ADDRESS}:8081"  # searxng
)
RUN_BROWSER

# # #### BACKUPS URLS
URLS=(
	"http://${IP_ADDRESS}:8200" # duplicati
	"http://${IP_ADDRESS}:4075" # resilio-sync
	"http://${IP_ADDRESS}:4275" # rsnapshot
	"http://${IP_ADDRESS}:8384" # syncthing
)
RUN_BROWSER

# # #### BOOKS URLS
URLS=(
	"https://${IP_ADDRESS}:8181" # calibre
	"http://${IP_ADDRESS}:8483"  # calibre-web
	"http://${IP_ADDRESS}:8400"  # cops
	"http://${IP_ADDRESS}:4400"  # freshrss
	"http://${IP_ADDRESS}:5000"  # kavita
	"http://${IP_ADDRESS}:5299"  # lazylibrarian
	"http://${IP_ADDRESS}:8091"  # mylar3
	"http://${IP_ADDRESS}:2202"  # ubooquity
)
RUN_BROWSER

# # #### CHAT URLS
URLS=(
	"http://${IP_ADDRESS}:4221" # altus
	"http://${IP_ADDRESS}:5636" # ferdium
	"http://${IP_ADDRESS}:5611" # mastodon
	"http://${IP_ADDRESS}:4400" # signal
	"http://${IP_ADDRESS}:3188" # webcord
	"http://${IP_ADDRESS}:4248" # weixin
)
RUN_BROWSER

# # #### DOWNLOADER URLS
URLS=(
	"http://${IP_ADDRESS}:8112" # deluge
	"http://${IP_ADDRESS}:5050" # flexget
	"http://${IP_ADDRESS}:6789" # nzbget
	"http://${IP_ADDRESS}:3230" # pyload
	"http://${IP_ADDRESS}:5156" # qbittorrent
	"http://${IP_ADDRESS}:4525" # sabnzb
	"http://${IP_ADDRESS}:9091" # transmission
)
RUN_BROWSER

# # #### ESSENTIAL URLS
URLS=(
	"http://${IP_ADDRESS}:8001"  # apprise-api
	"https://${IP_ADDRESS}:5050" # autoheal
	"http://${IP_ADDRESS}:8094"  # beszel
	"http://${IP_ADDRESS}:4919"  # cadvisor
	"http://${IP_ADDRESS}:3081"  # changedetection
	"http://${IP_ADDRESS}:8383"  # dashy
	"http://${IP_ADDRESS}:5310"  # dock-dploy
	"http://${IP_ADDRESS}:5311"  # dockhand
	"http://${IP_ADDRESS}:5310"  # dock-dploy
	"http://${IP_ADDRESS}:5576"  # doublecommander
	"http://${IP_ADDRESS}:8082"  # dozzle-ui
	"http://${IP_ADDRESS}:85"    # heimdall
	"http://${IP_ADDRESS}:2283"  # immich-server
	"http://${IP_ADDRESS}:8088"  # it-tools
	"http://${IP_ADDRESS}:8096"  # jellyfin
	"http://${IP_ADDRESS}:8765"  # motioneye
	"https://${IP_ADDRESS}:4433" # nextcloud
	"http://${IP_ADDRESS}:81"    # nginx-proxy-manager
	"http://${IP_ADDRESS}:9000"  # portainer
	"http://${IP_ADDRESS}:4999"  # portracker
	"http://${IP_ADDRESS}:4999"  # portracker-docker-proxy
	"http://${IP_ADDRESS}:7655"  # pulse
)
RUN_BROWSER

# # #### GAMESERVER URLS
URLS=(
	"http://${IP_ADDRESS}:4903" # linus-gms-cs2
	"http://${IP_ADDRESS}:3949" # pterodactyl-panel
)
RUN_BROWSER

# # #### SDR URLS
URLS=(
	"http://${IP_ADDRESS}:8073" # openwebrxplus
	"http://${IP_ADDRESS}:3322" # pterodactyl-panel
)
RUN_BROWSER
