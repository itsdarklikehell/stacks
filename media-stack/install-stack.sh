#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

docker network create media-services

function DOCKER_COMPOSE_STACK(){
    cd "media-services" || exit 1
    ./compose-up.sh
}

echo ""
echo "*** START COMPOSING: media-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: media-stack ****"
