#!/bin/bash
# Install open-llm-vtuber
function INSTALL_OPEN_LLM_VTUBER(){
    cd "${WD}/open-llm-vtuber" || exit 1
    uv sync
    # uv run run_server.py
    uv run upgrade.py
}

function INSTALL_OPEN_LLM_VTUBER_DOCKER(){
    cd "${WD}/open-llm-vtuber" || exit 1
    if [ ! -f "CustomDockerfile.docker" ]; then
        cp dockerfile CustomDockerfile.docker
    fi
    docker build -t open-llm-vtuber "${WD}/open-llm-vtuber"
    docker run -it --net=host -v "$(pwd)/conf.yaml:/app/conf.yaml" -p 12393:12393 open-llm-vtuber
}

function PULL_L2D_MODELS() {
    echo "[INFO]: Pulling L2D Models..."
    cd "${WD}/open-llm-vtuber/live2d-models" || exit 1
    declare -A repos=(
        ["live2d_models_collection"]="https://github.com/xiaoski/live2d_models_collection.git"
    )
        # ["Live2D_demo"]="https://github.com/MakeRedundant/Live2D_demo.git"
        # ["toshiki-live2d"]="https://github.com/andatoshiki/toshiki-live2d.git"
        # ["AwesomeLive2D"]="https://github.com/ezshine/AwesomeLive2D.git"
        # ["TouhouCannonBall-Live2d-Models"]="https://github.com/n0099/TouhouCannonBall-Live2d-Models.git"
        # ["vscode-live2d-models"]="https://github.com/iCharlesZ/vscode-live2d-models.git"
        # ["Live2d-model"]="https://github.com/Eikanya/Live2d-model.git"
        # ["konofan-live2d"]="https://github.com/HaiKonofanDesu/konofan-live2d.git"
        # ["live2d-model-assets"]="https://github.com/zenghongtu/live2d-model-assets.git"
    for repo in "${!repos[@]}"; do
        if [ -d "${repo}" ]; then
            echo "Repository ${repo} already exists, pulling latest changes..."
            git -C "${repo}" pull
        else
            echo "Cloning repository ${repo}..."
            git clone --recursive --quiet "${repos[$repo]}" "${repo}"
        fi
    done
    echo "[INFO]: Done pulling L2D Models..."
}
function PULL_VOC_MODELS() {
    echo "[INFO]: Pulling VOC models..."
    if [ ! -d "${WD}/open-llm-vtuber/models" ]; then
        mkdir "${WD}/open-llm-vtuber/models"
    fi

    VERS="medium" # "medium" "low" "high"
    cd "${WD}/open-llm-vtuber/models" || exit 1
    # Your wget commands here
WGET_URLS=(
    "https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-2024-07-17.tar.bz2"
    "https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-glados-${VERS}.tar.bz2"
    "https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-glados.tar.bz2"
    ) # Add all your URLs here as a separate line or semicolon separated for convenience
    # "https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-melo-tts-zh_en-${VERS}.tar.bz2"
    # "https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-melo-tts-zh_en.tar.bz2"
    echo "[INFO]: Pulling and extracting VOC models using wget commands."
    for url in "${WGET_URLS[@]}"; do 
        wget -c "$url" &>/dev/null  # Use wget command here
    done
    echo "Extracting VOC model files..."
    for i in *.tar.bz2; do
        echo "Extracting $i..."
        tar xvf "$i" &>/dev/null && rm "$i" &>/dev/null
    done
    echo "[INFO]: Downloading and extracting VOC models completed."
}
function PULL_EXTRA_CHARACTER_PROMPTS() {
    echo "[INFO]: Pulling Extra Character Prompts..."
    cd "${WD}/open-llm-vtuber/characters" || exit 1

    declare -A repos=(
        ["Black-Friday-Character-AI-Prompts"]="https://github.com/friuns/Black-Friday-Character-AI-Prompts.git"
        ["awesome-chatgpt-prompts"]="https://github.com/f/awesome-chatgpt-prompts.git"
        ["ai-prompts"]="https://github.com/instructa/ai-prompts.git"
        ["prompt-library"]="https://github.com/thibaultyou/prompt-library"
        ["Ai-Prompts"]="https://github.com/zebbern/Ai-Prompts"
    )
    for repo in "${!repos[@]}"; do
        if [ -d "${repo}" ]; then
            echo "Repository ${repo} already exists, pulling latest changes..."
            git -C "${repo}" pull
        else
            echo "Cloning repository ${repo}..."
            git clone --recursive --quiet "${repos[$repo]}" "${repo}"
        fi
    done

    echo "[INFO]: Done Pulling Extra Character Prompts..."
}

PULL_L2D_MODELS
PULL_VOC_MODELS
PULL_EXTRA_CHARACTER_PROMPTS

INSTALL_OPEN_LLM_VTUBER
