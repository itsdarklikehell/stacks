#!/bin/bash
# sudo apt update && sudo apt upgrade -y

WD="$(dirname "$(realpath "$0")")"
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

docker network create mcp-services

function DOCKER_COMPOSE_STACK(){
    cd "mcp-services" || exit 1
    ./compose-up.sh
}

echo ""
echo "*** START COMPOSING: mcp-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: mcp-stack ****"
