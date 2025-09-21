#!/bin/bash
# install-stack.sh for vtuber-tvs99-manager
set -e

STACK_DIR="$(dirname "$0")"
cd "$STACK_DIR"

# Build and start the stack
if [ ! -f .env ]; then
  echo "Creating default .env file..."
  cat <<EOF > .env
DASHBOARD_USER=admin
DASHBOARD_PASS=changeme
DASHBOARD_SECRET=changeme
TVS99_CONFIG=../tvs99/config.tvs.yml
EOF
  echo "Edit .env to set secure credentials!"
fi

echo "Building and starting vtuber-tvs99-manager stack..."
docker compose -f compose.yaml up -d --build

echo "Stack is running."
echo "Web UI: http://localhost:8088"
echo "API:    http://localhost:8000"
