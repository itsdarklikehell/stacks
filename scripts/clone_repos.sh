#!/bin/bash
WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
mkdir -p ../ai-stack/DATA

function CLONE_OLLMVT(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber  &>/dev/null
    cd Open-LLM-VTuber || exit
    
    # uv sync
    # uv run run_server.py

    cp -f "${WD}/CustomDockerfile-openllm-vtuber" dockerfile
    
    # export INSTALL_WHISPER=false
    # export INSTALL_BARK=false
    # docker build -t open-llm-vtuber . 
    # --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
}

function CLONE_SWARMUI(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git SwarmUI  &>/dev/null
    cd SwarmUI || exit 1
    cp -f "${WD}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
    cp -f "${WD}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh

    ./launchtools/custom-launch-docker.sh fixch
    # ./launchtools/custom-launch-docker.sh
}
function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git stable-diffusion-webui-docker  &>/dev/null
    mkdir -p stable-diffusion-webui-docker/data/models/CLIPEncoder
}
function CLONE_CHROMA(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/ecsricktorzynski/chroma chroma  &>/dev/null
}

CLONE_OLLMVT
CLONE_CHROMA
CLONE_SWARMUI
CLONE_STABLE-DIFFUSION-WEBUI-DOCKER