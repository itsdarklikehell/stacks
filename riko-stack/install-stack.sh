#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export STACKNAME="riko"
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
echo "Stacks directory is set to ${STACKS_DIR}"
echo "Data directory is set to ${PERM_DATA}"

cd "${WD}" || exit

docker network create riko-services

function DOCKER_COMPOSE_STACK() {
	cd "${STACKNAME}-services" || exit 1
	./compose-up.sh
}

echo ""
echo "*** START COMPOSING: ${STACKNAME}-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: ${STACKNAME}-stack ****"
echo ""
