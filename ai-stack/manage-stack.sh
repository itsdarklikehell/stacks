#!/bin/bash
# manage-stack.sh for llm-vtuber-twitch streaming and chat bot
set -e

STACK_DIR="$(dirname \"$0\")"
cd "$STACK_DIR"

case "$1" in
  start)
    echo "Starting llm-vtuber-twitch stack..."
    docker compose -f compose.llm-vtuber-twitch.yaml up -d
    ;;
  stop)
    echo "Stopping llm-vtuber-twitch stack..."
    docker compose -f compose.llm-vtuber-twitch.yaml down
    ;;
  restart)
    echo "Restarting llm-vtuber-twitch stack..."
    docker compose -f compose.llm-vtuber-twitch.yaml down
    docker compose -f compose.llm-vtuber-twitch.yaml up -d
    ;;
  status)
    docker compose -f compose.llm-vtuber-twitch.yaml ps
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac
