#!/bin/bash
# sudo apt update && sudo apt upgrade -y

WD="$(dirname "$(realpath "$0")")"
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

function DOCKER_COMPOSE_STACK(){
    cd "riko-services" || exit 1
    ./compose-up.sh
}

echo ""
echo "*** START COMPOSING: riko-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: riko-stack ****"
