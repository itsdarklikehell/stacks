#!/bin/bash
# sudo apt update && sudo apt upgrade -y

WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="../letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

function INSTALL_UV(){
    ../scripts/install_uv.sh
}
function CLONE_REPOS(){
    ../scripts/clone_repos.sh
}
function CREATE_COMFYUI_DOCKERFILE(){
    ../scripts/create_comfyui_dockerfile.sh
}
function CREATE_SWARMUI_DOCKERFILE(){
    ../scripts/create_swarmui_dockerfile.sh
}
function INSTALL_OPEN_LLM_VTUBER(){
    ../scripts/install_openllm_vtuber.sh
}
function INSTALL_SWARMUI(){
    ../scripts/install_swarmui.sh
}

function DOCKER_COMPOSE_STACK(){
    cd "${WD}/ai-services" || exit 1
    ./compose-up.sh
}

echo "Cloning repositories..."
CLONE_REPOS

echo "*** START COMPOSING: ai-stack ****"
DOCKER_COMPOSE_STACK
echo "*** FINISHED COMPOSING: ai-stack ****"
