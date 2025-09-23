#!/bin/bash
# sudo apt update && sudo apt upgrade -y

WD="$(dirname "$(realpath "$0")")"
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

function DOCKER_COMPOSE_STACK(){
    cd "ai-services" || exit 1
    ./compose-up.sh
}

echo "*** START COMPOSING: ai-stack ****"
DOCKER_COMPOSE_STACK
echo "*** FINISHED COMPOSING: ai-stack ****"
