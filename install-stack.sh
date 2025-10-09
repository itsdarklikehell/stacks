#!/bin/bash

WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

export PRUNE=none # none, normal, all
export BUILDING=norebuild # norebuild, rebuild

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
git pull


# sudo apt update && sudo apt upgrade -y
function PRUNING(){
    if [[ "$PRUNE" = all ]]; then
        echo ""
        echo "Pruning all unused docker data..."
        echo ""
        docker system prune -af
    elif [[ "$PRUNE" = normal ]]; then
        echo ""
        echo "Pruning normal unused docker data..."
        echo ""
        docker system prune -f
    fi
}
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

echo ""
echo "Installing Drivers"
echo ""
INSTALL_DRIVERS >/dev/null 2>&1
echo ""
echo "Installing Docker"
echo ""
INSTALL_DOCKER >/dev/null 2>&1
echo ""
echo "Creating Docker Secrets"
echo ""
CREATE_SECRETS >/dev/null 2>&1
echo ""
echo "Creating Docker Networks"
echo ""
CREATE_NETWORKS >/dev/null 2>&1
echo ""
echo "Cloning repos"
echo ""
CLONE_REPOS #>/dev/null 2>&1
echo ""

## STACKS:

export PRUNE=none # none, normal, all
export BUILDING=rebuild # norebuild, rebuild

PRUNING

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

echo ""
INSTALL_AIWAIFU_STACK
echo ""

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


# dockly # lazydocker

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete.."  