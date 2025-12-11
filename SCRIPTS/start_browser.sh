#!/bin/bash

export IP_ADDRESS=$(hostname -I | awk '{print $1}') # get machine IP address

echo "Start browser script started."

URLS=(
	"http://localhost:8383"  # dashy
	"http://localhost:7578"  # homearr
	"http://localhost:8283"  # letta-server
	"http://localhost:8188"  # ComfyUI
	"http://localhost:1111"  # forge-ai
	"http://localhost:8123"  # home assistant
	"http://localhost:8080"  # open-webui
	"http://localhost:3002"  # anythingllm
	"http://localhost:3210"  # lobe.ai
	"http://localhost:11434" # ollama
	"http://localhost:9090"  # invokeai
	"http://localhost:8081"  # searxng
	"http://localhost:8123"  # home assistant
	"http://localhost:3083"  # localai
	"http://localhost:8688"  # cushy-studio
	# "http://localhost:3080"         # librechat
	# "http://localhost:7801/Install" # SwarmUI
	# "http://localhost:7861"         # sd-automatic1111
	# "http://localhost:7862"         # sd-ComfyUI-webui
	# "http://localhost:7863"         # sd-fast-stable-diffusion-webui
	# "http://localhost:7864"         # sd-stable-diffusion-webui
	# "http://localhost:8501"         # stable-diffusion-webui
)

function RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
