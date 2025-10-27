#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export STACKNAME="openllm-vtuber"
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

docker network create openllm-vtuber-services

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
