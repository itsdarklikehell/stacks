#!/bin/bash
# set -e

echo "Start browser script started."

IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
export IP_ADDRESS

export IP_ADDRESS=0.0.0.0

URLS=(
	"http://${IP_ADDRESS}:3001"  # anythingllm
	"http://${IP_ADDRESS}:1111"  # forge
	"http://${IP_ADDRESS}:8123"  # home assistant
	"http://${IP_ADDRESS}:9090"  # InvokeAI
	"http://${IP_ADDRESS}:8283"  # letta-server
	"http://${IP_ADDRESS}:8083"  # localai
	"http://${IP_ADDRESS}:11434" # ollama
	"http://${IP_ADDRESS}:8080"  # open-webui
	"http://${IP_ADDRESS}:8081"  # searxng
	"http://${IP_ADDRESS}:8082"  # dozzle
	"http://${IP_ADDRESS}:8383"  # dashy
	"http://${IP_ADDRESS}:8088"  # it-tools
	"http://${IP_ADDRESS}:8094"  # beszel
	"http://${IP_ADDRESS}:81"    # nginx-proxy-manager
	"http://${IP_ADDRESS}:9000"  # portainer
	"http://${IP_ADDRESS}:8096"  # jellyfin
	"http://${IP_ADDRESS}:2283"  # immich
	"https://${IP_ADDRESS}:8181" # calibre
	"http://${IP_ADDRESS}:4999"  # portracker
	"http://${IP_ADDRESS}:8188"  # ComfyUI
	"http://${IP_ADDRESS}:8765"  # MotionEye
	"http://${IP_ADDRESS}:8483"  # calibre-web
	"http://${IP_ADDRESS}:5000"  # kavita
	"http://${IP_ADDRESS}:5299"  # lazylibrarian
	"http://${IP_ADDRESS}:2202"  # ubooquity
	"https://${IP_ADDRESS}:4433" # nextcloud
	"http://${IP_ADDRESS}:85"    # heimdall
	"https://${IP_ADDRESS}:444"  # heimdall
)

function RUN_BROWSER() {

	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

}

RUN_BROWSER
