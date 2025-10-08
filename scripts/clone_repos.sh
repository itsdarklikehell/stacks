#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

mkdir -p ../ai-stack/DATA
mkdir -p ../jaison-stack/DATA
mkdir -p ../openllm-vtuber-stack/DATA
mkdir -p ../media-stack/DATA
mkdir -p ../essentials-stack/DATA
mkdir -p ../management-stack/DATA
mkdir -p ../riko-stack/DATA

function CLONE_OLLMVT(){
    ./install_uv.sh
    cd "${WD}" || exit
    cd ../openllm-vtuber-stack/DATA || exit 1

    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber
    cd Open-LLM-VTuber || exit

    # uv sync
    # uv run run_server.py
    if [[ ! -f "conf.yaml" ]]; then
        cp config_templates/conf.default.yaml conf.yaml
    fi
    cp -f "${WD}/CustomDockerfile-openllm-vtuber-uv" CustomDockerfile-openllm-vtuber-uv
    cp -f "${WD}/CustomDockerfile-openllm-vtuber-conda" CustomDockerfile-openllm-vtuber-conda
    cp -f "${WD}/CustomDockerfile-openllm-vtuber-venv" CustomDockerfile-openllm-vtuber-venv

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
    cd ../jaison-stack/DATA || exit 1

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
    # python ./src/main.py --config=example
    
    cp -f "${WD}/CustomDockerfile-jaison-core-uv" CustomDockerfile-jaison-core-uv
    cp -f "${WD}/CustomDockerfile-jaison-core-conda" CustomDockerfile-jaison-core-conda
    cp -f "${WD}/CustomDockerfile-jaison-core-venv" CustomDockerfile-jaison-core-venv

    # export INSTALL_WHISPER=false
    # export INSTALL_BARK=false
    # docker build -t jaison-core .
    # --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
}
function CLONE_AIRI(){

    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/moeru-ai/airi.git airi
    cd airi || exit
    corepack enable

    # For Rust dependencies
    # Not required if you are not going to develop on either crates or apps/tamagotchi
    sudo apt install -y cargo
    cargo fetch

    npm i -g @antfu/ni
    ni

    cd services/telegram-bot || exit
    docker compose up -d
    cp .env .env.local
    nr -F @proj-airi/telegram-bot db:generate
    nr -F @proj-airi/telegram-bot db:push
    nr -F @proj-airi/telegram-bot dev
    cd ../discord-bot || exit
    cp .env .env.local
    nr -F @proj-airi/discord-bot dev
    cd ../minecraft || exit
    cp .env .env.local
    nr -F @proj-airi/minecraft dev
    cd .. || exit

    # nr dev:tamagotchi
    # nr dev
    # nr dev:docs

    cp -f "${WD}/CustomDockerfile-airi" CustomDockerfile-airi
}
function CLONE_RIKOPROJECT(){

    cd "${WD}" || exit
    cd ../riko-stack/DATA || exit 1

    git clone --recursive https://github.com/rayenfeng/riko_project riko-project
    cd riko-project || exit
    
    cp -f "${WD}/CustomDockerfile-riko-project-uv" CustomDockerfile-riko-project-uv
    cp -f "${WD}/CustomDockerfile-riko-project-conda" CustomDockerfile-riko-project-conda
    cp -f "${WD}/CustomDockerfile-riko-project-venv" CustomDockerfile-riko-project-venv

    curl -LsSf https://astral.sh/uv/install.sh | sh || true
    # uv venv .venv --clear

    sed -i "s/python_mecab_ko; sys_platform != 'win32'//" requirements.txt
    
    # shellcheck source=.venv/bin/activate
    # source .venv/bin/activate
    # pip install --upgrade pip uv nltk
    # uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
    # uv pip install -r extra-req.txt --no-deps
    # uv pip install -r requirements.txt

    # chmod +x install_reqs.sh
    # ./install_reqs.sh
    # python3 ./server/main_chat.py
}
function CLONE_SWARMUI(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git SwarmUI
    cd SwarmUI || exit 1
    cp -f "${WD}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
    cp -f "${WD}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh

    # docker stop swarmui >/dev/null 2>&1
    # docker rm swarmui >/dev/null 2>&1
    # ./launchtools/custom-launch-docker.sh
}
function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git stable-diffusion-webui-docker
    cd stable-diffusion-webui-docker || exit 1
    mkdir -p data/Models/CLIPEncoder
    cd services/comfy/ || exit 1
    cp -f "${WD}/CustomDockerfile-comfyui" Dockerfile
}
function CLONE_CHROMA(){
    cd "${WD}" || exit
    cd ../ai-stack/DATA || exit 1

    git clone --recursive https://github.com/ecsricktorzynski/chroma chroma
}

CLONE_OLLMVT
CLONE_JAISON
# CLONE_AIRI
CLONE_RIKOPROJECT
CLONE_CHROMA
CLONE_SWARMUI
CLONE_STABLE-DIFFUSION-WEBUI-DOCKER
