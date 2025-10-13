#!/bin/bash
# sudo apt update && sudo apt upgrade -y

WD="$(dirname "$(realpath "$0")")" || true
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

docker network create arr-services

function DOCKER_COMPOSE_STACK(){
    cd "arr-services" || exit 1
    ./compose-up.sh
}

echo ""
echo "*** START COMPOSING: arr-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: arr-stack ****"
