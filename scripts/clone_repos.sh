#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

mkdir -p "${PERM_DATA}/ai-stack"
mkdir -p "${PERM_DATA}/jaison-stack"
mkdir -p "${PERM_DATA}/openllm-vtuber-stack"
mkdir -p "${PERM_DATA}/media-stack"
mkdir -p "${PERM_DATA}/essentials-stack"
mkdir -p "${PERM_DATA}/management-stack"
mkdir -p "${PERM_DATA}/riko-stack"
mkdir -p "${PERM_DATA}/aiwaifu-stack"
mkdir -p "${PERM_DATA}/airi-stack"
./install_uv.sh
./install_toolhive.sh

function CLONE_OLLMVT(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/openllm-vtuber-stack" || exit 1

    echo "Cloning Open-LLM-VTuber"
    echo ""
    git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber
    # git clone --recursive https://github.com/itsdarklikehell/Open-LLM-VTuber.git Open-LLM-VTuber
    cd Open-LLM-VTuber || exit
    
    export INSTALL_WHISPER=true
    export INSTALL_BARK=true
    
    uv venv --clear
    source .venv/bin/activate
    uv sync --all-extras
    uv pip install -e .
    uv pip install -r requirements.txt
    uv pip install -r requirements-bilibili.txt
    
    uv pip install py3-tts sherpa-onnx fish-audio-sdk unidic-lite unidic mecab-python3

    uv add git+https://github.com/myshell-ai/MeloTTS.git
    uv pip install git+https://github.com/myshell-ai/MeloTTS.git

    uv add git+https://github.com/suno-ai/bark.git
    uv pip install git+https://github.com/suno-ai/bark.git
    
    uv run python3 unidic download

#     python3 - <<PYCODE
# import nltk
# nltk.download('averaged_perceptron_tagger_eng')
# PYCODE

    # uv run run_server.py
    if [[ ! -f "conf.yaml" ]]; then
        cp config_templates/conf.default.yaml conf.yaml
    fi
    cp -f "${WD}/CustomDockerfile-openllm-vtuber-uv" CustomDockerfile-openllm-vtuber-uv
    cp -f "${WD}/CustomDockerfile-openllm-vtuber-conda" CustomDockerfile-openllm-vtuber-conda
    cp -f "${WD}/CustomDockerfile-openllm-vtuber-venv" CustomDockerfile-openllm-vtuber-venv

    # docker build -t open-llm-vtuber .
    # --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true

    cd "${PERM_DATA}/openllm-vtuber-stack/Open-LLM-VTuber/live2d-models" || exit 1
    echo "Cloning Live2D Models"
    echo ""
    # git clone --recursive https://github.com/Eikanya/Live2d-model
    # git clone --recursive https://github.com/Mnaisuka/Live2d-model Live2d-models
    # git clone --recursive https://github.com/andatoshiki/toshiki-live2d
    # git clone --recursive https://github.com/xiaoski/live2d_models_collection
    # git clone --recursive https://github.com/ezshine/AwesomeLive2D
    # git clone --recursive https://github.com/n0099/TouhouCannonBall-Live2d-Models

    cd "${PERM_DATA}/openllm-vtuber-stack/Open-LLM-VTuber/models" || exit 1
    echo "Cloning VITS Models"
    echo ""
    # if [[ ! -d "sherpa-onnx-sense-voice-zh-en-ja-ko-yue-2024-07-17" ]]; then
    #     git clone https://huggingface.co/csukuangfj/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-2024-07-17
    # fi
    if [[ ! -d "vits-melo-tts-zh_en" ]]; then
        wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-melo-tts-zh_en.tar.bz2
        tar xvf vits-melo-tts-zh_en.tar.bz2
        rm vits-melo-tts-zh_en.tar.bz2
    fi
    if [[ ! -d "vits-piper-en_US-glados" ]]; then
        # wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-glados.tar.bz2
        # tar xvf vits-piper-en_US-glados.tar.bz2
        # rm vits-piper-en_US-glados.tar.bz2
        git clone --recursive https://huggingface.co/csukuangfj/vits-piper-en_US-glados
    fi
        if [[ ! -d "vits-piper-en_US-libritts_r-medium" ]]; then
        wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-libritts_r-medium.tar.bz2
        tar xvf vits-piper-en_US-libritts_r-medium.tar.bz2
        rm vits-piper-en_US-libritts_r-medium.tar.bz22
    fi    
    if [[ ! -d "vits-ljs" ]]; then
        wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-ljs.tar.bz2
        tar xvf vits-ljs.tar.bz2
        rm vits-ljs.tar.bz2
    fi
    if [[ ! -d "vits-vctk" ]]; then
        wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-vctk.tar.bz2
        tar xvf vits-vctk.tar.bz2
        rm vits-vctk.tar.bz2
    fi
    if [[ ! -d "vits-piper-en_US-lessac-medium" ]]; then
        wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-lessac-medium.tar.bz2
        tar xvf vits-piper-en_US-lessac-medium.tar.bz2
        rm vits-piper-en_US-lessac-medium.tar.bz2
    fi
    if [[ ! -d "vits-piper-en_GB-cori-high " ]]; then
            git clone https://huggingface.co/csukuangfj/vits-piper-en_GB-cori-high
    fi
    if [[ ! -d "vits-piper-nl_NL-miro-high " ]]; then
            git clone https://huggingface.co/csukuangfj/vits-piper-nl_NL-miro-high
    fi
    cd "${PERM_DATA}/openllm-vtuber-stack/Open-LLM-VTuber" || exit 1
    # git clone --recursive https://github.com/FunAudioLLM/CosyVoice.git
    # # If you failed to clone the submodule due to network failures, please run the following command until success
    # cd CosyVoice || exit 1
    # git submodule update --init --recursive
    # # conda create -n cosyvoice -y python=3.10
    # # conda activate cosyvoice
    # uv venv
    # uv sync
    # uv pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com
    # mkdir -p pretrained_models
    # git clone https://www.modelscope.cn/iic/CosyVoice2-0.5B.git pretrained_models/CosyVoice2-0.5B
    # git clone https://www.modelscope.cn/iic/CosyVoice-300M.git pretrained_models/CosyVoice-300M
    # git clone https://www.modelscope.cn/iic/CosyVoice-300M-SFT.git pretrained_models/CosyVoice-300M-SFT
    # git clone https://www.modelscope.cn/iic/CosyVoice-300M-Instruct.git pretrained_models/CosyVoice-300M-Instruct
    # git clone https://www.modelscope.cn/iic/CosyVoice-ttsfrd.git pretrained_models/CosyVoice-ttsfrd
    # cd pretrained_models/CosyVoice-ttsfrd/ || exit 1
    # unzip resource.zip -d .
    # uv pip install ttsfrd_dependency-0.1-py3-none-any.whl
    # uv pip install ttsfrd-0.4.2-cp310-cp310-linux_x86_64.whl

    # # If you encounter sox compatibility issues
    # # ubuntu
    # sudo apt install sox libsox-dev
}
function CLONE_LETTA(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/ai-stack" || exit 1

    echo "Cloning Letta"
    echo ""
    git clone --recursive https://github.com/letta-ai/letta.git letta
    cd letta || exit
    uv venv --clear
    source .venv/bin/activate
    uv sync --all-extras
    uv pip install -e .
    uv pip install -r requirements.txt
    # uv run letta server
}
function CLONE_MELOTTS(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/openllm-vtuber-stack" || exit 1

    echo "Cloning MeloTTS"
    echo ""
    git clone --recursive https://github.com/myshell-ai/MeloTTS.git MeloTTS
    cd MeloTTS || exit
    uv venv --clear
    source .venv/bin/activate
    uv sync --all-extras
    uv pip install -e .
    uv pip install -r requirements.txt
    uv run unidic download
    # docker build -t melotts .
    # docker run --gpus all -itd -p 8888:8888 melotts

    # melo-webui
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
    cd "${PERM_DATA}/jaison-stack" || exit 1

    echo "Cloning jaison-core"
    echo ""
    git clone --recursive https://github.com/limitcantcode/jaison-core.git jaison-core
    cd jaison-core || exit

    uv venv --clear
    source .venv/bin/activate
    uv sync --all-extras
    uv pip install -e .
    uv pip install -r requirements.txt
    # uv run run_server.py 

    # conda create -n jaison-core python=3.10 pip=24.0 -y
    # conda activate jaison-core

    # uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
    # uv pip install -r requirements.txt
    # uv pip install --no-deps -r requirements.no_deps.txt
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
    cd "${PERM_DATA}/airi-stack" || exit 1

    npm i -g @antfu/ni
    npm i -g shiki
    npm i -g pkgroll

    function INSTALL_XSAI(){
        cd "${WD}" || exit
        cd "${PERM_DATA}/airi-stack" || exit 1

        echo "Cloning xsai"
        echo ""
        git clone --recursive https://github.com/moeru-ai/xsai.git xsai
        cd xsai || exit

        ni
        nr build
    }
    function INSTALL_XSAI_TRANSFORMERS(){
        cd "${WD}" || exit
        cd "${PERM_DATA}/airi-stack" || exit 1

        echo "Cloning xsai-transformers"
        echo ""
        git clone --recursive https://github.com/moeru-ai/xsai-transformers.git xsai-transformers
        cd xsai-transformers || exit

        ni
        nr build
    }
    function INSTALL_AIRI_CHAT(){
        cd "${WD}" || exit
        cd "${PERM_DATA}/airi-stack" || exit 1

        echo "Cloning airi_chat"
        echo ""
        git clone --recursive https://github.com/moeru-ai/chat.git airi-chat
        cd airi-chat || exit

        ni
        nr build
    }
    function INSTALL_AIRI(){

        cd "${WD}" || exit
        cd "${PERM_DATA}/airi-stack" || exit 1

        echo "Cloning airi"
        echo ""
        git clone --recursive https://github.com/moeru-ai/airi.git airi
        cd airi || exit

        ni
        nr build

        # For Rust dependencies
        # Not required if you are not going to develop on either crates or apps/tamagotchi
        sudo apt install -y cargo
        cargo fetch

        export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
        corepack enable

        # telegram bot setup
        cd services/telegram-bot || exit
        cp .env .env.local
        # docker compose -p airi-telegram-bot-db up -d

        ni
        nr build
        # nr -F @proj-airi/telegram-bot db:generate
        # nr -F @proj-airi/telegram-bot db:push
        # nr -F @proj-airi/telegram-bot dev

        # discord bot setup
        cd ../discord-bot || exit
        cp .env .env.local

        ni
        nr build
        # nr -F @proj-airi/discord-bot dev

        # minecraft bot setup
        cd ../minecraft || exit
        cp .env .env.local

        ni
        nr build
        # nr -F @proj-airi/minecraft dev

        cd .. || exit

        # Run as desktop pet:
        # pnpm dev:tamagotchi
        # nr dev:tamagotchi

        # Run as web app:
        # nr dev
        # pnpm dev --host

        # nr dev:docs
        # pnpm dev:docs

        cd "${WD}" || exit
        cd "${PERM_DATA}/airi-stack/airi" || exit 1

        cp -f "${WD}/CustomDockerfile-airi-uv" CustomDockerfile-airi-uv
        cp -f "${WD}/CustomDockerfile-airi-conda" CustomDockerfile-airi-conda
        cp -f "${WD}/CustomDockerfile-airi-venv" CustomDockerfile-airi-venv
    }
    # echo "Cloning airi"
    # echo ""
    # INSTALL_AIRI
    # echo "Cloning xsai"
    # echo ""
    # INSTALL_XSAI
    # echo "Cloning xsai-transformers"
    # echo ""
    # INSTALL_XSAI_TRANSFORMERS
    # echo "Cloning airi_chat"
    # echo ""
    # INSTALL_AIRI_CHAT

    cd "${WD}" || exit
    sudo chown -R "1000:1000" "${PERM_DATA}/airi-stack"
}
function CLONE_RIKOPROJECT(){

    cd "${WD}" || exit
    cd "${PERM_DATA}/riko-stack" || exit 1

    echo "Cloning riko-project"
    echo ""
    git clone --recursive https://github.com/rayenfeng/riko_project.git riko-project
    cd riko-project || exit
    
    cp -f "${WD}/CustomDockerfile-riko-project-uv" CustomDockerfile-riko-project-uv
    cp -f "${WD}/CustomDockerfile-riko-project-conda" CustomDockerfile-riko-project-conda
    cp -f "${WD}/CustomDockerfile-riko-project-venv" CustomDockerfile-riko-project-venv
    cp -f "${WD}/install_reqs-riko.sh" install_reqs.sh

    # sed -i "s/python_mecab_ko; sys_platform != 'win32'//" requirements.txt
    # sed -i "s/transformers>=4.43/transformers>=4.53.0/" requirements.txt

    uv venv --clear
    source .venv/bin/activate
    uv pip install -r requirements.txt
    uv pip install -r extra-req.txt --no-deps
    uv pip install distro jiter
    
    # pip install --upgrade pip uv nltk
    # uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

    # chmod +x install_reqs.sh
    # ./install_reqs.sh

    # uv run python3 ./server/main_chat.py
    # uv run ./server/main_chat.py
}
function CLONE_SWARMUI(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/ai-stack" || exit 1

    echo "Cloning SwarmUI"
    echo ""
    git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git SwarmUI
    cd SwarmUI || exit 1
    cp -f "${WD}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
    cp -f "${WD}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh

    # docker stop swarmui
    # docker rm swarmui
    # ./launchtools/custom-launch-docker.sh
}
function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/ai-stack" || exit 1

    echo "Cloning stable-diffusion-webui-docker"
    echo ""
    git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git stable-diffusion-webui-docker
    cd stable-diffusion-webui-docker || exit 1
    mkdir -p data/Models/CLIPEncoder
    cd services/comfy/ || exit 1
    cp -f "${WD}/CustomDockerfile-comfyui" Dockerfile
}
function CLONE_CHROMA(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/ai-stack" || exit 1

    echo "Cloning chroma"
    echo ""
    git clone --recursive https://github.com/ecsricktorzynski/chroma.git chroma
    cd chroma || exit 1
    uv venv --clear
    source .venv/bin/activate
    uv sync --all-extras
    uv pip install -e .
    uv pip install -r requirements.txt
}
function CLONE_AIWAIFU(){
    cd "${WD}" || exit
    cd "${PERM_DATA}/aiwaifu-stack" || exit 1

    echo "Cloning AIwaifu"
    echo ""
    git clone --recursive https://github.com/HRNPH/AIwaifu.git aiwaifu
    cd aiwaifu || exit 1

    cp -f "${WD}/CustomDockerfile-aiwaifu-uv" CustomDockerfile-aiwaifu-uv
    cp -f "${WD}/CustomDockerfile-aiwaifu-conda" CustomDockerfile-aiwaifu-conda
    cp -f "${WD}/CustomDockerfile-aiwaifu-venv" CustomDockerfile-aiwaifu-venv

    # install poetry
    # pipx install poetry --force
    # poetry env use 3.8
    # poetry lock
    # poetry install
    # poetry env activate
    # uv venv .venv --clear
    # uv pip install -r requirements.txt

    # cd AIVoifu/voice_conversion/Sovits/monotonic_align || exit 1
    # python setup.py build_ext --inplace && cd ../../../../

    # this run on localhost 8267 by default
    # python ./api_inference_server.py

    # this will connect to all the server (Locally)
    # it is possible to host the api model on the external server, just beware of security issue
    # I'm planning to make a docker container for hosting on cloud provider for inference, but not soon
    # python ./main.py
}
CLONE_OLLMVT
CLONE_LETTA
CLONE_CHROMA
CLONE_SWARMUI
CLONE_STABLE-DIFFUSION-WEBUI-DOCKER
CLONE_JAISON
CLONE_RIKOPROJECT
CLONE_AIWAIFU
CLONE_AIRI
