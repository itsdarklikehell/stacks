#!/bin/bash
WD="$(dirname "$(realpath "$0")")"
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
mkdir -p ../ai-stack/DATA

function CLONE_OLLMVT(){
    ./install_uv.sh
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber
    cd Open-LLM-VTuber || exit

    # uv sync
    # uv run run_server.py

    cp -f "${WD}/CustomDockerfile-openllm-vtuber" CustomDockerfile-openllm-vtuber

    # export INSTALL_WHISPER=false
    # export INSTALL_BARK=false
    # docker build -t open-llm-vtuber .
    # --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
}
function CLONE_JAISON(){
    # sudo apt install -y ffmpeg

    # mkdir -p ~/miniconda3
    # wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    # bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    # rm ~/miniconda3/miniconda.sh
    # source ~/miniconda3/bin/activate
    # conda init --all
    # conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    # conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/limitcantcode/jaison-core jaison-core
    cd jaison-core || exit

    # uv sync
    # uv run run_server.py

    # conda create -n jaison-core python=3.10 pip=24.0 -y
    # conda activate jaison-core
    
    # pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
    # pip install -r requirements.txt
    # pip install --no-deps -r requirements.no_deps.txt
    # python -m spacy download en_core_web_sm
    # python install.py
    # python -m unidic download

    # python ./src/main.py --help

    cp -f "${WD}/CustomDockerfile-jaison-core" CustomDockerfile-jaison-core

    # export INSTALL_WHISPER=false
    # export INSTALL_BARK=false
    # docker build -t jaison-core .
    # --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
}

function CLONE_SWARMUI(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git SwarmUI
    cd SwarmUI || exit 1
    cp -f "${WD}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
    cp -f "${WD}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh

    docker stop swarmui
    docker rm swarmui

    # ./launchtools/custom-launch-docker.sh fixch
    # ./launchtools/custom-launch-docker.sh
}
function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git stable-diffusion-webui-docker
    mkdir -p stable-diffusion-webui-docker/data/models/CLIPEncoder
}
function CLONE_CHROMA(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/ecsricktorzynski/chroma chroma
}

CLONE_OLLMVT
CLONE_JAISON
CLONE_CHROMA
CLONE_SWARMUI
CLONE_STABLE-DIFFUSION-WEBUI-DOCKER