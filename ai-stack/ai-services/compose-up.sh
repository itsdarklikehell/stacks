#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	# anythingllm
	# autoheal
	# basic-memory
	# chroma
	# clickhouse
	# coqui-tts-cpu
	# faster-whisper-gpu
	# grafana
	# hollama
	# homeassistant
	# kokoro-tts
	# letta-mcp-server
	# letta-server
	# librechat
	# libretranslate-whispher
	# lobe-chat
	localai
	# minio
	# mongo-whispher
	n8n
	ollama
	open-webui
	# private-gpt
	# piper
	# prometheus
	# searxng
	# signoz
	# koboldccp
	# stable-diffusion-models-download
	# stable-diffusion-webui
	# swarmui
	# text-generation-webui-docker
	# voice-chat-ai
	# watchtower
	# whishper
	# whisper-webui
	# whisperx
	# wyoming-piper
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
