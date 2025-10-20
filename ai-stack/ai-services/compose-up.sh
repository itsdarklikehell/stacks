#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  anythingllm
  autoheal
  basic-memory
  chroma
  clickhouse
  faster-whisper-gpu
  homeassistant
  letta-server
  letta-mcp-server
  localai
#   kokoro-tts
#   coqui-tts-cpu
  voice-chat-ai
  ollama
  open-webui
  searxng
  stable-diffusion-models-download
  stable-diffusion-webui
  swarmui
  n8n
  mongo-whispher
#   libretranslate-whispher
#   whishper
  wyoming-piper
  watchtower
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
    echo "Added: ${f}/docker-compose.yaml"
    ARGS+="-f ${f}/docker-compose.yaml "
done

function BUILDING(){
    echo ""
    echo "Building is set to: ${BUILDING}"
    echo ""
    if [[ "${BUILDING}" = "force_rebuild" ]]; then
        docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
    elif [[ "${BUILDING}" = "true" ]]; then
        docker compose -f base.docker-compose.yaml ${ARGS} up -d
    elif [[ "${BUILDING}" = "false" ]]; then
        echo "Skipping docker compose up"
    fi
}
BUILDING