#!/bin/bash
set -e
echo "Install Docker script started."

function REMOVE_DOCKER() {
	sudo systemctl stop docker
	sudo systemctl disable docker

	sudo systemctl stop docker.socket
	sudo systemctl disable docker.socket

	sudo apt purge -y docker-engine docker* docker.io docker-ce docker-ce-cli docker-compose-plugin docker-buildx-plugin docker-ce-rootless-extras docker-model-plugin containerd*

	sudo apt autoremove -y --purge docker-engine docker* docker.io docker-ce docker-ce-cli docker-compose-plugin docker-buildx-plugin docker-ce-rootless-extras docker-model-plugin containerd*

	sudo rm -rf /var/lib/docker /etc/docker
	sudo rm /etc/apparmor.d/docker
	sudo groupdel docker
	sudo rm -rf /var/run/docker.sock
	sudo rm -rf /var/lib/containerd
	sudo rm -r ~/.docker
	sleep 1
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

		curl -fsSL https://get.docker.com -o get-docker.sh
		sh get-docker.sh
		sudo apt modernize-sources -y

		sudo systemctl enable --now docker

		# Post-installation steps:
		# sudo groupadd docker
		# sudo newgrp docker
		sudo usermod -aG docker "${USER}"

		if test -L "/var/lib/docker"; then
			echo "/var/lib/docker is a symlink to a directory"
			sudo ls -la "/var/lib/docker"
		elif test -d "/var/lib/docker"; then
			echo "/var/lib/docker is just a plain directory"
			sudo mv -f /var/lib/docker "${DOCKER_BASEPATH}"
			# mkdir "${DOCKER_BASEPATH}"
			sudo ln -sf "${DOCKER_BASEPATH}" "/var/lib/docker"
			sudo ls -la "/var/lib/docker"
		fi

		echo "Docker installation completed."

	fi
	sudo nvidia-ctk runtime configure --runtime=docker
	sudo systemctl restart docker
	docker rm nvidia-smi
	docker run --name=nvidia-smi --runtime=nvidia --gpus all ubuntu nvidia-smi
}

# REMOVE_DOCKER

# Call the function to install Docker
INSTALL_DOCKER
