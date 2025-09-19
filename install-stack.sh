#!/bin/bash

export WD="$(dirname "$(realpath $0)")"
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd ${WD} || exit

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

function CREATE_SERVICES(){
    scripts/create_services.sh
}
function STOP_SERVICES(){
    scripts/stop_services.sh
}
function START_SERVICES(){
    scripts/start_services.sh
}
function STATUS_SERVICES(){
    scripts/status_services.sh
}
function ENABLE_SERVICES(){
    scripts/enable_services.sh
}

function INSTALL_management-stack_STACK(){
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
echo "Creating Docker Networks"
CREATE_NETWORKS


## STACKS:

echo "Installing Docker Management Stack"
INSTALL_management-stack_STACK

echo "Installing media Stack"
INSTALL_MEDIA_STACK

echo "Installing AI Stack"
INSTALL_AI_STACK

# sudo chown -R "${USER}":"${USER}" "${WD}"
echo "Installation complete. Please reboot your system to ensure all changes take effect."