#!/bin/bash

export IP_ADDRESS=$(hostname -I | awk '{print $1}') # get machine IP address

echo "Start browser script started."

URLS=(
	"http://192.168.1.2:8383"  # dashy
	"http://192.168.1.2:7578"  # homearr
	"http://192.168.1.2:8283"  # letta-server
	"http://192.168.1.2:8188"  # ComfyUI
	"http://192.168.1.2:1111"  # forge-ai
	"http://192.168.1.2:8123"  # home assistant
	"http://192.168.1.2:8080"  # open-webui
	"http://192.168.1.2:3002"  # anythingllm
	"http://192.168.1.2:3210"  # lobe.ai
	"http://192.168.1.2:11434" # ollama
	"http://192.168.1.2:9090"  # invokeai
	"http://192.168.1.2:8081"  # searxng
	"http://192.168.1.2:8123"  # home assistant
	"http://192.168.1.2:3083"  # localai
	"http://192.168.1.2:8688"  # cushy-studio
	# "http://192.168.1.2:3080"         # librechat
	# "http://192.168.1.2:7801/Install" # SwarmUI
	# "http://192.168.1.2:7861"         # sd-automatic1111
	# "http://192.168.1.2:7862"         # sd-comfyui-webui
	# "http://192.168.1.2:7863"         # sd-fast-stable-diffusion-webui
	# "http://192.168.1.2:7864"         # sd-stable-diffusion-webui
	# "http://192.168.1.2:8501"         # stable-diffusion-webui
)

RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
