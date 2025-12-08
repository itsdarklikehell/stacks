#!/bin/bash
echo "Start browser script started."

URLS=(
	"http://localhost:8283"                                                     # letta-server
	"https://app.letta.com/settings/organization/projects?view-mode=selfHosted" # letta projects
	"http://localhost:7801/Install"                                             # SwarmUI
	"http://localhost:8188"                                                     # ComfyUI
	"http://localhost:8123"                                                     # home assistant
	"http://localhost:8080"                                                     # open-webui
	"http://localhost:3002"                                                     # anythingllm
	"http://localhost:3210"                                                     # lobe.ai
	"http://localhost:11434"                                                    # ollama
	"http://localhost:9090"                                                     # invokeai
	"http://localhost:8081"                                                     # searxng
	# "http://localhost:3400"                                                     #
	# "http://localhost:5678"                                                     #
	# "http://localhost:12393"                                                    #
	# "http://localhost:8288"                                                     #
	# "http://localhost:1111"                                                     #
	# "http://localhost:7860"                                                     #
	# "http://localhost:7861"                                                     #
	# "http://localhost:8384"                                                     #
	# "http://localhost:8888"                                                     #
	# "http://localhost:3080"                                                     #
	# "http://localhost:8083"                                                     #
)

RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
