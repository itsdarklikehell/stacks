#!/bin/bash
# set -e

echo "Start browser script started."

IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
export IP_ADDRESS
if [[ ${USER} == "hans" ]]; then
	export IP_ADDRESS
elif [[ ${USER} == "rizzo" ]]; then
	export IP_ADDRESS
	# export IP_ADDRESS=192.168.178.63
else
	export IP_ADDRESS
fi

AI_URLS=(
	"http://${IP_ADDRESS}:3001"       # anythingllm
	"http://${IP_ADDRESS}:6013"       # habridge
	"http://${IP_ADDRESS}:8123"       # home assistant
	"http://${IP_ADDRESS}:9090"       # InvokeAI
	"http://${IP_ADDRESS}:8283"       # letta
	"http://${IP_ADDRESS}:8084"       # localai
	"http://${IP_ADDRESS}:5678"       # n8n
	"http://${IP_ADDRESS}:11434"      # ollama
	"http://${IP_ADDRESS}:8080"       # open-webui
	"http://${IP_ADDRESS}:8081"       # searxng
)

BACKUP_URLS=(
	"http://${IP_ADDRESS}:8200"       # duplicati
	"http://${IP_ADDRESS}:4275"       # resili-sync
	"http://${IP_ADDRESS}:4275"       # rsnapshot
	"http://${IP_ADDRESS}:8384"       # syncthing
)

BOOKS_URLS=(
	"http://${IP_ADDRESS}:8181"       # calibre
	"http://${IP_ADDRESS}:8483"       # calibre-web
	"http://${IP_ADDRESS}:8400"       # cop
	"http://${IP_ADDRESS}:4400"       # freshrss
	"http://${IP_ADDRESS}:5000"       # kavita
	"http://${IP_ADDRESS}:5299"       # lazylibrarian
	"http://${IP_ADDRESS}:8091"       # mylar3
	"http://${IP_ADDRESS}:5885"       # rsspub
	"http://${IP_ADDRESS}:2202"       # ubooquity
)

CHAT_URLS=(
	"http://${IP_ADDRESS}:4221"       # altus
	"https://${IP_ADDRESS}:5636"       # ferdium
	"http://${IP_ADDRESS}:5611"       # mastodon
	"http://${IP_ADDRESS}:4400"       # signal
	"http://${IP_ADDRESS}:3372"       # telegram
	"http://${IP_ADDRESS}:3188"       # webcord
	"http://${IP_ADDRESS}:4248"       # weixin
)

function RUN_BROWSER() {

	for URL in "${AI_URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

	for URL in "${BACKUP_URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

	for URL in "${BOOKS_URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

	for URL in "${CHAT_URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

}

RUN_BROWSER
