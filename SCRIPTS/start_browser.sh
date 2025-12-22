#!/bin/bash
set -e

echo "Start browser script started."

IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
export IP_ADDRESS

URLS=(
	"http://${IP_ADDRESS}:3002"  # anythingllm
	"http://${IP_ADDRESS}:1111"  # forge
	"http://${IP_ADDRESS}:8123"  # home assistant
	"http://${IP_ADDRESS}:9090"  # InvokeAI
	"http://${IP_ADDRESS}:8283"  # letta-server
	"http://${IP_ADDRESS}:8083"  # localai
	"http://${IP_ADDRESS}:11434" # ollama
	"http://${IP_ADDRESS}:8080"  # open-webui
	"http://${IP_ADDRESS}:8081"  # searxng
	"http://${IP_ADDRESS}:8383"  # dashy
	"http://${IP_ADDRESS}:8088"  # it-tools
	"http://${IP_ADDRESS}:81"    # nginx-proxy-mamager
	"http://${IP_ADDRESS}:9000"  # portainer
	"http://${IP_ADDRESS}:4999"  # portracker
	"http://${IP_ADDRESS}:8188"  # ComfyUI
	"http://${IP_ADDRESS}:3000"  # ComfyUIMini
	"http://${IP_ADDRESS}:12393" # open-llm-vtuber
	# "https://${IP_ADDRESS}:9001" # portainer-agent
	# "http://${IP_ADDRESS}:3005" 		  # letta-mcp-server
	# "http://${IP_ADDRESS}:8688"  		  # cushy-studio
	# "http://${IP_ADDRESS}:3080"         # librechat
	# "http://${IP_ADDRESS}:7578"         # homearr
	# "http://${IP_ADDRESS}:7801/Install" # SwarmUI
	# "http://${IP_ADDRESS}:7861"         # sd-automatic1111
	# "http://${IP_ADDRESS}:7862"         # sd-ComfyUI-webui
	# "http://${IP_ADDRESS}:7863"         # sd-fast-stable-diffusion-webui
	# "http://${IP_ADDRESS}:7864"         # sd-stable-diffusion-webui
	# "http://${IP_ADDRESS}:8501"         # stable-diffusion-webui
)

function RUN_BROWSER() {

	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done

}

RUN_BROWSER
