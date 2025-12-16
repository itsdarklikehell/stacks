#!/bin/bash
echo "Install Docker script started."

export DOCKER_BASEPATH="/media/rizzo/RAIDSTATION/docker"

function REMOVE_DOCKER() {
	sudo apt purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
	sudo apt autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin
	sudo rm -rf /var/lib/docker /etc/docker
	sudo rm /etc/apparmor.d/docker
	sudo groupdel docker
	sudo rm -rf /var/run/docker.sock
	sudo rm -rf /var/lib/containerd
	sudo rm -r ~/.docker
}
# Install Docker and related tools on Ubuntu
function INSTALL_DOCKER() {
	# check if docker is installed and if not install it
	if command -v docker &>/dev/null; then
		echo "Docker is already installed"
	else
		echo "Installing Docker..."
		sudo apt update
		sudo apt install -y \
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

		# Post-installation steps:
		# sudo groupadd docker
		# newgrp docker

		if test -L "/var/lib/docker"; then
			echo "/var/lib/docker is a symlink to a directory"
			# ls -la "/var/lib/docker"
		elif test -d "/var/lib/docker"; then
			echo "/var/lib/docker is just a plain directory"
			sudo mv /var/lib/docker "${DOCKER_BASEPATH}"
			sudo ln -s "${DOCKER_BASEPATH}" /var/lib/docker
			sudo ls -la /var/lib/docker
		fi

		sudo usermod -aG docker "${USER}"
		sudo systemctl enable --now docker
		docker run hello-world
		echo "Docker installation completed."

	fi
}
REMOVE_DOCKER
# Call the function to install Docker
INSTALL_DOCKER
