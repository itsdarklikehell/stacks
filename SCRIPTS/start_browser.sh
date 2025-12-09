#!/bin/bash

export IP_ADDRESS=$(hostname -I | awk '{print $1}') # get machine IP address

echo "Start browser script started."

URLS=(
	"http://0.0.0.0:8383"  # dashy
	"http://0.0.0.0:7578"  # homearr
	"http://0.0.0.0:8283"  # letta-server
	"http://0.0.0.0:8188"  # ComfyUI
	"http://0.0.0.0:1111"  # forge-ai
	"http://0.0.0.0:8123"  # home assistant
	"http://0.0.0.0:8080"  # open-webui
	"http://0.0.0.0:3002"  # anythingllm
	"http://0.0.0.0:3210"  # lobe.ai
	"http://0.0.0.0:11434" # ollama
	"http://0.0.0.0:9090"  # invokeai
	"http://0.0.0.0:8081"  # searxng
	"http://0.0.0.0:8123"  # home assistant
	"http://0.0.0.0:3083"  # localai
	"http://0.0.0.0:8688"  # cushy-studio
	# "http://0.0.0.0:3080"         # librechat
	# "http://0.0.0.0:7801/Install" # SwarmUI
	# "http://0.0.0.0:7861"         # sd-automatic1111
	# "http://0.0.0.0:7862"         # sd-comfyui-webui
	# "http://0.0.0.0:7863"         # sd-fast-stable-diffusion-webui
	# "http://0.0.0.0:7864"         # sd-stable-diffusion-webui
	# "http://0.0.0.0:8501"         # stable-diffusion-webui
)

RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
