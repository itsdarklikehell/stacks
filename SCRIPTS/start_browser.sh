#!/bin/bash

export IP_ADDRESS=$(hostname -I | awk '{print $1}') # get machine IP address

echo "Start browser script started."

URLS=(
	"http://${IP_ADDRESS}:8383"  # dashy
	"http://${IP_ADDRESS}:7578"  # homearr
	"http://${IP_ADDRESS}:8283"  # letta-server
	"http://${IP_ADDRESS}:8188"  # ComfyUI
	"http://${IP_ADDRESS}:1111"  # forge-ai
	"http://${IP_ADDRESS}:8123"  # home assistant
	"http://${IP_ADDRESS}:8080"  # open-webui
	"http://${IP_ADDRESS}:3002"  # anythingllm
	"http://${IP_ADDRESS}:3210"  # lobe.ai
	"http://${IP_ADDRESS}:11434" # ollama
	"http://${IP_ADDRESS}:9090"  # invokeai
	"http://${IP_ADDRESS}:8081"  # searxng
	"http://${IP_ADDRESS}:8123"  # home assistant
	"http://${IP_ADDRESS}:3083"  # localai
	"http://${IP_ADDRESS}:8688"  # cushy-studio
	# "http://${IP_ADDRESS}:3080"         # librechat
	# "http://${IP_ADDRESS}:7801/Install" # SwarmUI
	# "http://${IP_ADDRESS}:7861"         # sd-automatic1111
	# "http://${IP_ADDRESS}:7862"         # sd-comfyui-webui
	# "http://${IP_ADDRESS}:7863"         # sd-fast-stable-diffusion-webui
	# "http://${IP_ADDRESS}:7864"         # sd-stable-diffusion-webui
	# "http://${IP_ADDRESS}:8501"         # stable-diffusion-webui
)

RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
