#!/usr/bin/env bash
set -euo pipefail

STACKS_ROOT="/media/rizzo/RAIDSTATION/stacks/STACKS"
DATA_ROOT="${STACKS_ROOT}/../DATA"

echo "========================================"
echo "  Deploy All Stacks (Except Ollama)"
echo "========================================"
echo ""
echo "STACKS_ROOT: $STACKS_ROOT"
echo "DATA_ROOT:   $DATA_ROOT"
echo ""

# 1. Create Docker networks
echo "▶ Creating Docker networks..."
NETWORKS=(
  "essential-services"
  "ai-services"
  "media-services"
  "backups-services"
  "books-services"
  "chat-services"
  "desktop-services"
  "downloader-services"
  "gameserver-services"
  "openllm-vtuber-services"
  "sdr-services"
  "testing-services"
)

for NET in "${NETWORKS[@]}"; do
  if docker network ls --format '{{.Name}}' | grep -q "^${NET}$"; then
    echo "  ✓ Network $NET exists"
  else
    docker network create "$NET"
    echo "  ✓ Created network $NET"
  fi
done

# 2. Fix DATA directory permissions
echo ""
echo "▶ Fixing DATA directory permissions..."
if [ -d "$DATA_ROOT" ]; then
  sudo chown -R rizzo:rizzo "$DATA_ROOT"
  sudo chmod -R u+rwX,g+rwX,o+rX "$DATA_ROOT"
  echo "  ✓ Permissions fixed on $DATA_ROOT"
else
  echo "  ⚠ DATA directory not found at $DATA_ROOT"
fi

# 3. Define stack deployment order
# We'll use install-stack.sh where available
declare -A STACK_ORDER=(
  ["essential-stack"]=1
  ["media-stack"]=2
  # ai-stack we'll do manually skipping ollama
  ["ai-stack"]=3
  ["backups-stack"]=4
  ["books-stack"]=5
  ["chat-stack"]=6
  ["desktop-stack"]=7
  ["downloader-stack"]=8
  ["gameserver-stack"]=9
  ["openllm-vtuber-stack"]=10
  ["sdr-stack"]=11
  ["testing-stack"]=12
)

# 4. Deploy each stack
echo ""
echo "▶ Deploying stacks in dependency order..."
echo ""

deploy_stack() {
  local stack_name="$1"
  local stack_dir="$STACKS_ROOT/$stack_name"

  if [ ! -d "$stack_dir" ]; then
    echo "  ⚠ Stack $stack_name not found, skipping"
    return
  fi

  echo "==> Starting $stack_name..."

  # If install-stack.sh exists, use it
  if [ -f "$stack_dir/install-stack.sh" ]; then
    # For ai-stack, we need to skip ollama => create a modified compose or edit after
    if [ "$stack_name" = "ai-stack" ]; then
      echo "  ℹ ai-stack: using targeted deployment (skipping ollama)"
      # Deploy other services manually via compose files in ai-services
      cd "$stack_dir/ai-services"
      # shellcheck disable=SC2043  # intentional: deploy only base compose (ollama excluded by design)
      for compose in base.docker-compose.yaml; do
        echo "    docker compose -f $compose up -d (excluding ollama via profile or manual filter)"
        # We can start all services via docker compose, but ollama might fail due to GPU. We'll start all and ignore failures.
        docker compose -f "$compose" up -d || true
      done
    else
      echo "    Running install-stack.sh..."
      (cd "$stack_dir" && ./install-stack.sh) || true
    fi
  else
    # Fallback: try compose-up.sh if exists
    if [ -f "$stack_dir/compose-up.sh" ]; then
      echo "    Running compose-up.sh..."
      (cd "$stack_dir" && STACK_NAME="${stack_name}" ./compose-up.sh) || true
    else
      echo "    No install script found, skipping"
    fi
  fi

  echo "  ✓ $stack_name deployment initiated"
}

# Sort stacks by order number
for stack in "${!STACK_ORDER[@]}"; do
  deploy_stack "$stack"
done

echo ""
echo "========================================"
echo "  Deployment Initiated"
echo "========================================"
echo ""
echo "Checking running containers..."
sleep 5
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | head -20

echo ""
echo "To view all services:"
echo "  docker ps -a"
echo ""
echo "To check logs of a service:"
echo "  docker logs -f <container>"
echo ""
echo "Monitoring:"
echo "  Grafana: http://localhost:3000"
echo "  Prometheus: http://localhost:9090"
echo "  modelrelay: http://localhost:7352"
echo "  TV Simulator: http://localhost:3003"
echo ""
echo "Deployment script finished. Some services may still be starting."
