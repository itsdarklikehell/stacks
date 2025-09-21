#!/bin/bash
WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
# cd "${WD}" || exit

mkdir -p "../ai-stack/DATA" 
function CLONE_OLLMVT(){
    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git ../ai-stack/DATA/Open-LLM-VTuber  &>/dev/null
    cd ../ai-stack/DATA/Open-LLM-VTuber || exit
    uv sync
}

function CLONE_SWARMUI(){
    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git ../ai-stack/DATA/SwarmUI  &>/dev/null
    # cd  ../../././ || exit 1
    # echo $PWD
    cp -f CustomDockerfile-swarmui "../ai-stack/DATA/SwarmUI/launchtools/CustomDockerfile.docker"
    cp -f custom-launch-docker.sh "../ai-stack/DATA/SwarmUI/launchtools/custom-launch-docker.sh"

    docker stop swarmui
    docker rm swarmui

    ../../../ai-stack/DATA/SwarmUI/launchtools/custom-launch-docker.sh fixch
    ../../../ai-stack/DATA/SwarmUI/launchtools/custom-launch-docker.sh
}

function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){
    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git ../ai-stack/DATA/stable-diffusion-webui-docker  &>/dev/null
    mkdir -p ../ai-stack/DATA/stable-diffusion-webui-docker/data/models/CLIPEncoder
}
CLONE_OLLMVT
CLONE_SWARMUI
CLONE_STABLE-DIFFUSION-WEBUI-DOCKER