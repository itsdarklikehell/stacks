#!/usr/bin/env bash
set -euo pipefail

# Startup script for all stacks in proper dependency order.
# Runs each stack with a short delay to allow services to initialize.

COMPOSE_BASE="/media/rizzo/RAIDSTATION/stacks/STACKS"

stacks=(
  "essential-stack/essential-services/base.docker-compose.yaml"
  "ai-stack/ai-services/base.docker-compose.yaml"
  "monitoring-stack/docker-compose.yml"
  # Add other stacks as needed
)

echo "Starting stacks in order..."
echo ""

for STACK in "${stacks[@]}"; do
  COMPOSE_FILE="${COMPOSE_BASE}/${STACK}"
  if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "⚠ Skipping $STACK (file not found)"
    continue
  fi

  echo "▶ Starting $STACK"
  docker compose -f "$COMPOSE_FILE" up -d
  echo "✓ Started $STACK"
  echo "   Waiting 10s for services to stabilize..."
  sleep 10
  echo ""
done

echo "All stacks started!"
echo ""
echo "Check status with:"
echo "  docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
echo ""
echo "View logs with:"
echo "  docker logs -f <container>"
echo ""
echo "Monitoring:"
echo "  - Grafana: http://localhost:3000"
echo "  - Prometheus: http://localhost:9090"
echo "  - modelrelay metrics: http://localhost:7352/metrics"
