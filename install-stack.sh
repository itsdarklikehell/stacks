#!/bin/bash

WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
git pull

# sudo apt update && sudo apt upgrade -y

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
function INSTALL_MANAGEMENT-STACK_STACK(){
    management-stack/install-stack.sh
}
function INSTALL_MEDIA_STACK(){
    media-stack/install-stack.sh
}
function INSTALL_AI_STACK(){
    ai-stack/install-stack.sh
}
echo ""
echo "Installing Drivers"
echo ""
INSTALL_DRIVERS
echo ""
echo "Installing Docker"
echo ""
INSTALL_DOCKER
echo ""
echo "Creating Docker Secrets"
echo ""
CREATE_SECRETS
echo ""
echo "Creating Docker Networks"
echo ""
CREATE_NETWORKS
echo ""
echo "Cloning repos"
echo ""
CLONE_REPOS
echo ""

## STACKS:

echo ""
INSTALL_ESSENTIALS_STACK
echo ""

echo ""
INSTALL_AI_STACK
echo ""

echo ""
INSTALL_MANAGEMENT-STACK_STACK
echo ""

echo ""
INSTALL_MEDIA_STACK
echo ""

# dockly # lazydocker

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete. Please reboot your system to ensure all changes take effect."