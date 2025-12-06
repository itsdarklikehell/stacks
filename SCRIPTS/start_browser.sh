#!/bin/bash
echo "Start browser script started."

URLS=(
	"https://app.letta.com/development-servers/a1d63ef5-1f7e-46ff-a9e1-1ce925110335/agents"
	"http://localhost:3002"
	"http://localhost:3400"
	"http://localhost:8123"
	"http://localhost:3210"
	"http://localhost:5678"
	"http://localhost:8081"
	"http://localhost:11434"
	"http://localhost:12393"
	"https://app.letta.com/settings/organization/projects?view-mode=selfHosted"
	"http://localhost:8188"
	"http://localhost:8288"
	"http://localhost:9090"
	"http://localhost:1111"
	"http://localhost:7860"
	"http://localhost:7861"
	"http://localhost:8384"
	"http://localhost:8888"
	# "http://localhost:8283"
	# "http://localhost:3080"
	# "http://localhost:8083"
	# "http://localhost:8080"
	# "http://localhost:7801/Install"
)

RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
