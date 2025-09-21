#!/bin/bash

export WD="$(dirname "$(realpath $0)")"
export LETTA_SANDBOX_MOUNT_PATH=./letta
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

# sudo apt update && sudo apt upgrade -y


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
function INSTALL_ADDITIONAL_MCP_SERVERS(){
    ../scripts/install_mcp_servers.sh
}

function DOCKER_COMPOSE_STACK(){
    cd ai-services || exit 1
    ./compose-up.sh
}

../scripts/create_env_file.sh


echo "Cloning repositories..."
CLONE_REPOS

echo "Creating ComfyUI Dockerfile..."
CREATE_COMFYUI_DOCKERFILE

echo "Creating SwarmUI Dockerfile..."
CREATE_SWARMUI_DOCKERFILE

# echo "Installing SwarmUI..."
# INSTALL_SWARMUI

# echo "Installing Open-LLM-Vtuber..."
# INSTALL_OPEN_LLM_VTUBER

# echo "Installing additional MCP servers..."
# INSTALL_ADDITIONAL_MCP_SERVERS

echo "*** START COMPOSING: ai-stack ****"
DOCKER_COMPOSE_STACK
echo "*** FINISHED COMPOSING: ai-stack ****"
