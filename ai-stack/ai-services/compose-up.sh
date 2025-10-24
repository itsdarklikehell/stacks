#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	signoz
	whisperx
	anythingllm
	autoheal
	basic-memory
	chroma
	clickhouse
	coqui-tts-cpu
	faster-whisper-gpu
	grafana
	homeassistant
	kokoro-tts
	letta-mcp-server
	letta-server
	librechat
	libretranslate-whispher
	localai
	minio
	mongo-whispher
	n8n
	ollama
	open-webui
	private-gpt
	prometheus
	searxng
	stable-diffusion-models-download
	stable-diffusion-webui
	swarmui
	voice-chat-ai
	watchtower
	whishper
	whisper-webui
	wyoming-piper
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	echo "Added: ${f}/docker-compose.yaml"
	ARGS+="-f ${f}/docker-compose.yaml "
done

function BUILDING() {
	echo ""
	echo "Building is set to: ${BUILDING}"
	echo ""
	if [[ ${BUILDING} == "force_rebuild" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
	elif [[ ${BUILDING} == "true" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi
}
BUILDING
