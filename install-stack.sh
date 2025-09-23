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

function INSTALL_management-stack_STACK(){
    management-stack/install-management-stack.sh
}
function INSTALL_MEDIA_STACK(){
    media-stack/install-media-stack.sh
}
function INSTALL_AI_STACK(){
    ai-stack/install-ai-stack.sh
}

echo "Installing Drivers"
INSTALL_DRIVERS &>/dev/null
echo "Installing Docker"
INSTALL_DOCKER &>/dev/null
echo "Creating Docker Secrets"
CREATE_SECRETS &>/dev/null
echo "Creating Docker Networks"
CREATE_NETWORKS &>/dev/null

## STACKS:
echo "Installing AI Stack"
INSTALL_AI_STACK

# echo "Installing Docker Management Stack"
# INSTALL_management-stack_STACK

# echo "Installing media Stack"
# INSTALL_MEDIA_STACK


# dockly # lazydocker

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete. Please reboot your system to ensure all changes take effect."