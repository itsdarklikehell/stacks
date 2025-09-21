#!/bin/bash
WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
mkdir -p ../ai-stack/DATA

function CLONE_OLLMVT(){

    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber  &>/dev/null
    cd Open-LLM-VTuber || exit
    
    uv sync
    uv run run_server.py

    docker build -t open-llm-vtuber .
}

function CLONE_SWARMUI(){

    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git SwarmUI  &>/dev/null
    cp -f "${WD}/CustomDockerfile-swarmui" SwarmUI/launchtools/CustomDockerfile.docker
    cp -f "${WD}/custom-launch-docker.sh" SwarmUI/launchtools/custom-launch-docker.sh

    docker stop swarmui
    docker rm swarmui

    ./SwarmUI/launchtools/custom-launch-docker.sh fixch
    # ./SwarmUI/launchtools/custom-launch-docker.sh
}

function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){

    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git stable-diffusion-webui-docker  &>/dev/null
    mkdir -p stable-diffusion-webui-docker/data/models/CLIPEncoder
}
CLONE_OLLMVT
# CLONE_SWARMUI
# CLONE_STABLE-DIFFUSION-WEBUI-DOCKER