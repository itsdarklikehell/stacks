#!/bin/bash
# Launch all AI stack services using modular compose files
set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
  docker-compose.base.yaml
  docker-compose.autoheal.yaml
  docker-compose.anythingllm.yaml
  docker-compose.chroma.yaml
  docker-compose.clickhouse-server.yaml
  docker-compose.basic-memory.yaml
  docker-compose.faster-whisper-gpu.yaml
  docker-compose.homeassistant.yaml
  docker-compose.letta-db.yaml
  docker-compose.letta-mcp.yaml
  docker-compose.letta-server.yaml
  docker-compose.libretranslate.yaml
  docker-compose.librechat.yaml
  docker-compose.mongo.yaml
  docker-compose.ollama.yaml
  docker-compose.open-webui.yaml
  docker-compose.searxng.yaml
  # docker-compose.open-llm-vtuber.yaml
  # docker-compose.stable-diffusion-models-download.yaml
  # docker-compose.stable-diffusion-webui.yaml
  # docker-compose.swarmui.yaml
  docker-compose.watchtower.yaml
  docker-compose.whisper.yaml
  docker-compose.wyoming-piper.yaml
)

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
  ARGS+="-f $f "
done

echo "Running: docker compose $ARGS up -d"

docker login
docker compose $ARGS up -d
# docker compose $ARGS up -d --build --force-recreate --remove-orphans