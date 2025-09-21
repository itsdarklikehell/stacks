#!/bin/bash
# Install Docker and related tools on Ubuntu
function INSTALL_DOCKER(){
    # check if docker is installed and if not install it
    if command -v docker &> /dev/null
    then
        echo "Docker is already installed"
    else
        echo "Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release

        # # Add Docker’s official GPG key:
        # sudo mkdir -p /etc/apt/keyrings
        # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        # # Set up the stable repository:
        # echo \
        #   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        #   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        sudo usermod -aG docker "${USER}"
        
        # Post-installation steps:
        # sudo groupadd docker
        # newgrp docker

        echo "Docker installation completed."
    fi
    # check if lazydocker is installed and if not install it
    if command -v lazydocker &> /dev/null
    then
        echo "Lazydocker is already installed"
    else
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
        echo "Lazyocker installation completed."
    fi
    # check if dockly is installed and if not install it
    if command -v dockly &> /dev/null
    then
        echo "dockly is already installed"
    else
        npm install -g dockly
        echo "dockly installation completed."
    fi

}
# Call the function to install Docker
INSTALL_DOCKER 