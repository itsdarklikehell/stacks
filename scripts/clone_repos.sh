#!/bin/bash

mkdir -p "${WD}/DATA" 
cd "${WD}/DATA" || exit 1

function CLONE_OLLMVT(){
    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git "${WD}/DATA/Open-LLM-VTuber"
    cd "${WD}/DATA/Open-LLM-VTuber" || exit
    uv sync
}
function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){
    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git "stable-diffusion-webui-docker"
    cp -f "../scripts/CustomDockerfile-comfyui" "${WD}/DATA/stable-diffusion-webui-docker/services/comfy/Dockerfile"

}
function CLONE_SWARMUI(){
    cd "${WD}/ai-services/DATA" || exit 1
    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI "SwarmUI"
    cp -f "${WD}/scripts/CustomDockerfile-swarmui" "${WD}/DATA/stable-diffusion-webui-docker/services/comfy/Dockerfile"
    
    # cp -f "${WD}/DATA/stable-diffusion-webui-docker/launchtools/launch-standard-docker.sh" custom-launch-docker.sh
    # ./launch-standard-docker.sh fixch
    # ./custom-launch-docker.sh &
}

# CLONE_OLLMVT
# CLONE_STABLE-DIFFUSION-WEBUI-DOCKER
# CLONE_SWARMUI
# CLONE_REPOS 