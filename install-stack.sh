#!/bin/bash

WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

export CLEANUP="false" # false, true

export PRUNE="all" # false, true/normal, all
export BUILDING="recreate" # false, true, recreate

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
git pull origin main

function PRUNING(){
    echo ""
    echo "Pruning is set to: $PRUNE"
    echo ""
    if [[ "$PRUNE" = "all" ]]; then
        docker system prune -af
    elif [[ "$PRUNE" = "true" ]] || [[ "$PRUNE" = "normal" ]]; then
        docker system prune -f
    elif [[ "$PRUNE" = "false" ]]; then
        echo "Skipping docker system prune"
    fi
    sleep 3
}
function CLEANUP_DATA(){
    FOLDERS=(
        '/media/rizzo/RAIDSTATION/stacks/airi-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/ai-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/aiwaifu-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/arr-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/essentials-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/jaison-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/management-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/media-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/openllm-vtuber-stack/DATA'
        '/media/rizzo/RAIDSTATION/stacks/riko-stack/DATA'
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
function INSTALL_MCP_STACK(){
    mcp-stack/install-stack.sh
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
CLONE_REPOS #
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

echo ""
INSTALL_MCP_STACK
go install github.com/mark3labs/mcp-filesystem-server@latest
sudo apt install -y lynx
npm install @mtane0412/twitch-mcp-server
# Create a new application in the Twitch Developer Console
# Set the following environment variables:
export TWITCH_CLIENT_ID="your_client_id"
export TWITCH_CLIENT_SECRET="your_client_secret"

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

echo ""
INSTALL_PROJECT_RIKO_STACK
echo ""

models=(
    'qwen2.5:latest'
    'qwen3:latest'
    'gemma3:latest'
    'mgistral:latest'
    'embeddinggemma:latest'
    'nomic-embed-text:latest'
    'mxbai-embed-large'
    'codellama:latest'
    'deepseek-coder'
    'mistral:7b-instruct'
    'llama3.2:latest'
    'llama3.2-coder:latest'
    'qwen2.5-coder:32b'
    'granite:latest'
    'gpt-oss:20b'
    'gpt-oss:120b'
    'deepseek-r1'
)
for model in "${models[@]}"; do
    echo "Pulling model: ${model}"
    # docker exec -it ollama sh -c "ollama pull ${model}"
    ollama pull "${model}"
done

# dockly # lazydocker

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete.."