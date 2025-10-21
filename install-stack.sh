#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

export PERM_DATA="${WD}/DATA"

export CLEANUP="false" # false, true

export PRUNE="false" # false, true/normal, all
export BUILDING="force_rebuild" # false, true, force_rebuild

export TWITCH_CLIENT_ID="your_client_id"
export TWITCH_CLIENT_SECRET="your_client_secret"

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
git pull origin main
function PULL_MODELS(){
    models=(
        'adi0adi/ollama_stheno-8b_v3.1_q6k:latest'
        'aiden_lu/peach-9b-8k-roleplay:latest'
        'ALIENTELLIGENCE/roleplaymaster:latest'
        'antonos9/roleplay:latest'
        'BlackDream/blue-orchid-2x7b:latest'
        'codellama:latest'
        'deepseek-coder'
        'deepseek-r1'
        'Desmon2D/Wayfarer-12B:latest'
        'embeddinggemma:latest'
        'gemma3:latest'
        'gpt-oss:120b'
        'gpt-oss:20b'
        'granite:latest'
        'gurubot/pivot-roleplay-v0.2:latest'
        'jimscard/adult-film-screenwriter-nsfw:latest'
        'kingzeus/llama-3.1-8b-darkidol:latest'
        'kubernetes_bad/chargen-v2:latest'
        'leeplenty/ellaria:latest'
        'llama3.2-coder:latest'
        'llama3.2:latest'
        'magistral:latest'
        'mgistral:latest'
        'mistral:7b-instruct'
        'mistral:latest'
        'mxbai-embed-large'
        'nchapman/mn-12b-inferor-v0.0:latest'
        'nchapman/mn-12b-mag-mell-r1:latest'
        'nemotron-mini:latest'
        'nomic-embed-text:latest'
        'Plexi09/SentientAI:latest'
        'qwen2.5-coder:32b'
        'qwen2.5:latest'
        'qwen3:latest'
        'smallthinker:latest'
    )
    for model in "${models[@]}"; do
        echo "Pulling model: ${model}"
        # docker exec -it ollama sh -c "ollama pull ${model}" >/dev/null 2>&1
        ollama pull "${model}" # >/dev/null 2>&1
    done
}
# PULL_MODELS
function PRUNING(){
    echo ""
    echo "Pruning is set to: ${PRUNE}"
    echo ""
    if [[ "${PRUNE}" = "all" ]]; then
        docker system prune -af
    elif [[ "${PRUNE}" = "true" ]] || [[ "${PRUNE}" = "normal" ]]; then
        docker system prune -f
    elif [[ "${PRUNE}" = "false" ]]; then
        echo "Skipping docker system prune"
    fi
    sleep 3
}
function CLEANUP_DATA(){
    FOLDERS=(
        "${PERM_DATA}/airi-stack"
        "${PERM_DATA}/ai-stack"
        "${PERM_DATA}/aiwaifu-stack"
        "${PERM_DATA}/arr-stack"
        "${PERM_DATA}/essentials-stack"
        "${PERM_DATA}/jaison-stack"
        "${PERM_DATA}/management-stack"
        "${PERM_DATA}/media-stack"
        "${PERM_DATA}/openllm-vtuber-stack"
        "${PERM_DATA}/riko-stack"
        "${PERM_DATA}"
    )
    for folder in "${FOLDERS[@]}"; do
        echo ""
        echo "Removing ${folder}"
        sudo rm -rf "${folder}"
    done
}
if [[ "${CLEANUP}" = "true" ]]; then
    export BUILDING="recreate" # false, true, recreate
    CLEANUP_DATA
fi
function INSTALL_DRIVERS(){
    scripts/install_drivers.sh
}
function INSTALL_DOCKER(){
    scripts/install_docker.sh
}
function CREATE_NETWORKS(){
    scripts/create_networks.sh
}
function CREATE_SECRETS(){
    scripts/create_secrets.sh
}
function CLONE_REPOS(){
    scripts/clone_repos.sh
}
function INSTALL_ESSENTIALS_STACK(){
    essentials-stack/install-stack.sh
}
function INSTALL_MANAGEMENT_STACK(){
    management-stack/install-stack.sh
}
function INSTALL_MEDIA_STACK(){
    media-stack/install-stack.sh
}
function INSTALL_AI_STACK(){
    ai-stack/install-stack.sh
}
function INSTALL_JAISON_STACK(){
    jaison-stack/install-stack.sh
}
function INSTALL_VOICE_CHAT_AI_STACK(){
    voice-chat-ai-stack/install-stack.sh
}
function INSTALL_PROJECT_RIKO_STACK(){
    riko-stack/install-stack.sh
}
function INSTALL_OPENLLM_VTUBER_STACK(){
    openllm-vtuber-stack/install-stack.sh
}
function INSTALL_ARR_STACK(){
    arr-stack/install-stack.sh
}
function INSTALL_AIWAIFU_STACK(){
    aiwaifu-stack/install-stack.sh
}
function INSTALL_AIRI_STACK(){
    airi-stack/install-stack.sh
}
# Install essential dependencies
echo ""
echo "Installing Drivers"
echo ""
INSTALL_DRIVERS
echo ""
echo "Installing Docker"
echo ""
INSTALL_DOCKER


echo ""
echo "Cloning repos"
echo ""
CLONE_REPOS
echo ""


## STACKS:

PRUNING
CREATE_NETWORKS
CREATE_SECRETS


echo ""
INSTALL_ESSENTIALS_STACK
echo ""

echo ""
INSTALL_AI_STACK
echo ""

# echo ""
# INSTALL_ARR_STACK
# echo ""

# echo ""
# INSTALL_MANAGEMENT_STACK
# echo ""

# echo ""
# INSTALL_MEDIA_STACK
# echo ""

# echo ""
# INSTALL_AIWAIFU_STACK
# echo ""

# echo ""
# INSTALL_AIRI_STACK
# echo ""

# echo ""
# INSTALL_OPENLLM_VTUBER_STACK
# echo ""

# echo ""
# INSTALL_JAISON_STACK
# echo ""

# echo ""
# INSTALL_PROJECT_RIKO_STACK
# echo ""

# PULL_MODELS

# dockly # lazydocker

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete.."
if [[ -f "${HOME}/bin/start_ai.sh" ]]; then
    gnome-terminal -- "${HOME}/bin/start_ai.sh"
    xdg-open "http://localhost:8080" # open-webui
    xdg-open "http://localhost:12393" # openllm-vtuber
fi