#!/bin/bash

WD="$(dirname "$(realpath "$0")")"
export WD
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd ${WD} || exit

# sudo apt update && sudo apt upgrade -y

function DOCKER_COMPOSE_STACK(){
    # docker compose -f compose_stack.yaml up -d --build
    # docker compose up -d --build --force-recreate --remove-orphans
    cd media-services || exit 1
    ./compose-up.sh
}


echo "*** START COMPOSING: media-stack ****"
DOCKER_COMPOSE_STACK
echo "*** FINISHED COMPOSING: media-stack ****"


function COMPOSE_SUNSHINE(){
    if [ -d "sunshine" ]; then
        echo "Repository sunshine already exists, pulling latest changes..."
        git -C "sunshine" pull
    else
        echo "Cloning repository sunshine..."
        git clone --recurse-submodules --quiet "https://github.com/loki-47-6F-64/sunshine" "sunshine"
        cd sunshine && mkdir build && cd build || exit 1
        cmake -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10 ..
        make -j ${nproc}
        sudo usermod -a -G input "${USER}"
        sudo setcap cap_sys_admin+p sunshine
        sudo make install
    fi
    cd sunshine || exit

    # Mixed (tbd)
    sudo modprobe snd-aloop index=2
    docker run -d -p 6080:80 -p 5900:5900 --device /dev/snd -e ALSADEV=hw:2,0 -e USER=doro -e PASSWORD=Crims0nDynam0! -e VNC_PASSWORD=Crims0nDynam0! -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc

}
echo "*** START COMPOSING: sunshine ****"
COMPOSE_SUNSHINE
echo "*** FINISHED COMPOSING: sunshine ****"