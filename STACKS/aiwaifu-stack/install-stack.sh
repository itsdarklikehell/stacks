#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true

export WD
export UV_LINK_MODE=copy

echo "Building is set to: ${BUILDING}"
echo "Working directory is set to ${WD}"
echo "Configs directory is set to ${CONFIGS_DIR}"
echo "Data directory is set to ${PERM_DATA}"
echo "Secrets directory is set to ${SECRETS_DIR}"

cd "${WD}" || exit

docker network create aiwaifu-services

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
