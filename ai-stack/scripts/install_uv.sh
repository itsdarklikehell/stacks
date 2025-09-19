#!/bin/bash
# Install UV on Ubuntu
function INSTALL_UV(){
    # check if UV is installed and if not install it
    if command -v uv &> /dev/null
    then
        echo "UV is already installed"
    else
        echo "Installing UV..."
        # sudo apt update
        # sudo apt update && sudo apt install -y python3-pip
        # pip install uv
        # check if curl is installed, if not install it
        if ! command -v curl &> /dev/null
        then
            echo "curl could not be found, installing it..."
            sudo apt update && sudo apt install -y curl
        fi
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source ~/.bashrc
        echo "UV installation completed."
    fi
}
INSTALL_UV 