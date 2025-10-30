#!/bin/bash
echo "Start browser script started."

URLS=(
	"http://localhost:11434"
	"http://0.0.0.0:7801/Install"
)

RUN_BROWSER() {
	for URL in "${URLS[@]}"; do
		xdg-open "${URL}" >/dev/null 2>&1 &
	done
}

RUN_BROWSER
