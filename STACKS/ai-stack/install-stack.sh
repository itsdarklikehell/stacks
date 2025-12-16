#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true

export WD
export UV_LINK_MODE=copy

cd "${WD}" || exit

docker network create "${STACK_NAME}-services"

function DOCKER_COMPOSE_STACK() {
	cd "${STACK_NAME}-services" || exit 1
	./compose-up.sh
}

echo ""
echo "*** START COMPOSING: ${STACK_NAME}-stack ****"
echo ""
DOCKER_COMPOSE_STACK
echo ""
echo "*** FINISHED COMPOSING: ${STACK_NAME}-stack ****"
echo ""
