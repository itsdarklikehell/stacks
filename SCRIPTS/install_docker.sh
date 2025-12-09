#!/bin/bash
echo "Install Docker script started."

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

		sudo usermod -aG docker "${USER}"

		sudo systemctl enable --now docker

		echo "Docker installation completed."

		sudo mv /var/lib/docker /media/hans/opslag/docker
		sudo ln -s /media/hans/opslag/docker /var/lib/docker
		sudo ls -la /var/lib/docker
	fi
	# check if lazydocker is installed and if not install it
	if command -v lazydocker &>/dev/null; then
		echo "Lazydocker is already installed"
	else
		curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/SCRIPTS/install_update_linux.sh | bash || true
		echo "Lazyocker installation completed."
	fi
	# check if dockly is installed and if not install it
	if command -v dockly &>/dev/null; then
		echo "dockly is already installed"
	else
		npm install -g dockly
		npx npm-check-updates -u
		echo "dockly installation completed."
	fi

}
# Call the function to install Docker
INSTALL_DOCKER
