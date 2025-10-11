#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  base.docker-compose.yaml
  anythingllm/docker-compose.yaml
  autoheal/docker-compose.yaml
  basic-memory/docker-compose.yaml
  # chroma/docker-compose.yaml
  clickhouse/docker-compose.yaml
  faster-whisper-gpu/docker-compose.yaml
  homeassistant/docker-compose.yaml
  # librechat/docker-compose.yaml
  # librechat-meilisearch/docker-compose.yaml 
  # librechat-mongodb/docker-compose.yaml 
  # librechat-rag_api/docker-compose.yaml 
  # librechat-vectordb/docker-compose.yaml
  letta-server/docker-compose.yaml
  localai/docker-compose.yaml
  libretranslate/docker-compose.yaml
  kokoro-tts/docker-compose.yaml
  coqui-tts-cpu/docker-compose.yaml
  voice-chat-ai/docker-compose.yaml
  mongo/docker-compose.yaml
    #  ollama/docker-compose.yaml # runs locally now
  open-webui/docker-compose.yaml
  searxng/docker-compose.yaml
  stable-diffusion-models-download/docker-compose.yaml
  stable-diffusion-webui/docker-compose.yaml
  swarmui/docker-compose.yaml
  n8n/docker-compose.yaml
  whishper/docker-compose.yaml
  wyoming-piper/docker-compose.yaml
  watchtower/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
    ARGS+="-f ${f} "
done

echo "Running: docker compose ${ARGS} up -d"

function BUILDING(){
    echo ""
    echo "Building is set to: $BUILDING"
    echo ""
    if [[ "$BUILDING" = "recreate" ]]; then
        docker compose ${ARGS} up -d --build --force-recreate --remove-orphans
    elif [[ "$BUILDING" = "true" ]]; then
        docker compose ${ARGS} up -d
    elif [[ "$BUILDING" = "false" ]]; then
        echo "Skipping docker compose up"
    fi
    # docker run --name letta -d -v ../DATA/letta/.persist/pgdata:/var/lib/postgresql/data -p 8283:8283 -e OPENAI_API_KEY="your_openai_api_key" -e ANTHROPIC_API_KEY="your_anthropic_api_key" -e OLLAMA_BASE_URL="http://host.docker.internal:11434"  letta/letta:latest
}
BUILDING