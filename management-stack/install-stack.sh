#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd ${WD} || exit

docker network create management-services

function DOCKER_COMPOSE_STACK(){
    cd "management-services" || exit 1
    ./compose-up.sh
}

echo ""
echo "*** START COMPOSING: management-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: management-stack ****"
