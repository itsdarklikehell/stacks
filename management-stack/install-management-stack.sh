#!/bin/bash

WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd ${WD} || exit

# sudo apt update && sudo apt upgrade -y

function DOCKER_COMPOSE_STACK(){
    cd management-services || exit 1
    ./compose-up.sh
}

echo "*** START COMPOSING: management-stack ****"
DOCKER_COMPOSE_STACK
echo "*** FINISHED COMPOSING: management-stack ****"

# function COMPOSE_UBUNTU-VNC-DESKTOP(){
#     if [ -d "docker-ubuntu-vnc-desktop" ]; then
#         echo "Repository docker-ubuntu-vnc-desktop already exists, pulling latest changes..."
#         git -C "docker-ubuntu-vnc-desktop" pull
#     else
#         echo "Cloning repository docker-ubuntu-vnc-desktop..."
#         git clone --recursive --quiet "https://github.com/fcwu/docker-ubuntu-vnc-desktop" "docker-ubuntu-vnc-desktop"
#         cd "docker-ubuntu-vnc-desktop" || exit 1
#         docker build --tag "docker-ubuntu-vnc-desktop" .
#         docker run --detach "docker-ubuntu-vnc-desktop"
#     fi
#     cd docker-ubuntu-vnc-desktop || exit

#     sudo modprobe snd-aloop index=2
#     docker run -d -p 6080:80 -p 5900:5900 --device /dev/snd -e ALSADEV=hw:2,0 -e USER=doro -e PASSWORD=Crims0nDynam0! -e VNC_PASSWORD=Crims0nDynam0! -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc
# }
# echo "*** START COMPOSING: docker-ubuntu-vnc-desktop ****"
# # COMPOSE_UBUNTU-VNC-DESKTOP
# echo "*** FINISHED COMPOSING: docker-ubuntu-vnc-desktop ****"

