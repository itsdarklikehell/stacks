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

echo "Installing Drivers"
INSTALL_DRIVERS
echo "Installing Docker"
INSTALL_DOCKER
echo "Creating Docker Secrets"
CREATE_SECRETS
echo "Creating Docker Networks"
CREATE_NETWORKS

echo "Cloning repos"
CLONE_REPOS


## STACKS:


echo "Installing Essentials Stack"
echo ""
INSTALL_ESSENTIALS_STACK

# echo "Installing AI Stack"
# echo ""
# INSTALL_AI_STACK

# echo "Installing Management Stack"
# echo ""
# INSTALL_MANAGEMENT-STACK_STACK

# echo "Installing media Stack"
# echo ""
# INSTALL_MEDIA_STACK


# dockly # lazydocker

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete. Please reboot your system to ensure all changes take effect."