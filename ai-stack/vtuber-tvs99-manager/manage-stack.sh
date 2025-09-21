#!/bin/bash
# manage-stack.sh for vtuber-tvs99-manager
set -e

STACK_DIR="$(dirname "$0")"
cd "$STACK_DIR"

case "$1" in
  start)
    echo "Starting stack..."
    docker compose -f compose.yaml up -d
    ;;
  stop)
    echo "Stopping stack..."
    docker compose -f compose.yaml down
    ;;
  restart)
    echo "Restarting stack..."
    docker compose -f compose.yaml down
    docker compose -f compose.yaml up -d
    ;;
  status)
    docker compose -f compose.yaml ps
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac
