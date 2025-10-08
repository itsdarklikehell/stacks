#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  base.docker-compose.yaml
  # anythingllm/docker-compose.yaml
  autoheal/docker-compose.yaml
  basic-memory/docker-compose.yaml
  # chroma/docker-compose.yaml
  clickhouse/docker-compose.yaml
  faster-whisper-gpu/docker-compose.yaml
  homeassistant/docker-compose.yaml
  # letta-db/docker-compose.yaml
  # letta-mcp/docker-compose.yaml
  # letta-server/docker-compose.yaml
  # librechat/docker-compose.yaml
  # librechat-meilisearch/docker-compose.yaml 
  # librechat-mongodb/docker-compose.yaml 
  # librechat-rag_api/docker-compose.yaml 
  # librechat-vectordb/docker-compose.yaml
  libretranslate/docker-compose.yaml
  mongo/docker-compose.yaml
  ollama/docker-compose.yaml
  open-webui/docker-compose.yaml
  searxng/docker-compose.yaml
  stable-diffusion-models-download/docker-compose.yaml
  stable-diffusion-webui/docker-compose.yaml
  swarmui/docker-compose.yaml
  watchtower/docker-compose.yaml
  whishper/docker-compose.yaml
  wyoming-piper/docker-compose.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

# docker compose $ARGS up -d
docker compose $ARGS up -d --build --force-recreate --remove-orphans