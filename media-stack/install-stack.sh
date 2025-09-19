#!/bin/bash

export WD="$(dirname "$(realpath $0)")"
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd ${WD} || exit

# sudo apt update && sudo apt upgrade -y

function DOCKER_COMPOSE_STACK(){
    # docker compose -f compose_stack.yaml up -d --build
    docker compose up -d --build --force-recreate --remove-orphans
}


echo "*** START COMPOSING: media-stack ****"
DOCKER_COMPOSE_STACK
echo "*** FINISHED COMPOSING: media-stack ****"

