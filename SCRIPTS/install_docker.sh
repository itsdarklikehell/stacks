#!/bin/bash
# set -e

echo "Install Docker script started."

DOCKER_RUNTIME="$(cat /etc/docker/daemon.json | jq -r '.runtimes | .nvidia | .path' || true)"
CUDA_VERSION="$(cat /usr/local/cuda/version.json | jq -r '.cuda | .version' || true)"
DRIVER_VERSION="$(cat /usr/local/cuda/version.json | jq -r '.nvidia_driver | .version' || true)"

function REMOVE_DOCKER() {

	sudo systemctl stop docker
	sudo systemctl disable docker

	sudo systemctl stop docker.socket
	sudo systemctl disable docker.socket

	sudo apt purge -y docker-engine docker* docker.io docker-ce docker-ce-cli docker-compose-plugin docker-buildx-plugin docker-ce-rootless-extras docker-model-plugin containerd*

	sudo apt autoremove -y --purge docker-engine docker* docker.io docker-ce docker-ce-cli docker-compose-plugin docker-buildx-plugin docker-ce-rootless-extras docker-model-plugin containerd*

	sudo rm -rf /var/lib/docker /etc/docker "${DOCKER_BASEPATH}"
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

		function SETUP_ENV() {

			IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
			export IP_ADDRESS

			if [[ ${USER} == "hans" ]]; then
				export STACK_BASEPATH="/media/hans/4-T/stacks"
				export DOCKER_BASEPATH="/media/hans/4-T/docker"
				export COMFYUI_PATH="/${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
			elif [[ ${USER} == "rizzo" ]]; then
				export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
				export DOCKER_BASEPATH="/media/rizzo/RAIDSTATION/docker"
				export COMFYUI_PATH="/${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
			else
				export STACK_BASEPATH="/media/hans/4-T/stacks"
				export DOCKER_BASEPATH="/media/hans/4-T/docker"
				export COMFYUI_PATH="/${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
			fi

			eval "$(resize)" || true
			DOCKER_BASEPATH=$(whiptail --inputbox "What is your docker folder?" "${LINES}" "${COLUMNS}" "${DOCKER_BASEPATH}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
			exitstatus=$?

			if [[ ${exitstatus} == 0 ]]; then
				echo "User selected Ok and entered " "${DOCKER_BASEPATH}"
			else
				echo "User selected Cancel."
				exit 1
			fi

			export DOCKER_BASEPATH

			eval "$(resize)" || true
			STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
			exitstatus=$?

			if [[ ${exitstatus} == 0 ]]; then
				echo "User selected Ok and entered " "${STACK_BASEPATH}"
			else
				echo "User selected Cancel."
				exit 1
			fi

			export STACK_BASEPATH

			eval "$(resize)" || true
			IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip adress?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
			exitstatus=$?

			if [[ ${exitstatus} == 0 ]]; then
				echo "User selected Ok and entered " "${IP_ADDRESS}"
			else
				echo "User selected Cancel."
				exit 1
			fi

			export IP_ADDRESS

			cd "${STACK_BASEPATH}" || exit 1

			echo ""
			START_CUSHYSTUDIO >/dev/null 2>&1 &
			echo "" || exit

			git pull # origin main
			chmod +x "install-stack.sh"

		}

		SETUP_ENV

		sudo apt update
		sudo apt install -y \
			ca-certificates \
			curl \
			gnupg \
			lsb-release

		curl -fsSL https://get.docker.com -o get-docker.sh
		sh get-docker.sh && rm get-docker.sh
		sudo apt modernize-sources -y

		sudo systemctl stop docker.socket
		sudo systemctl stop docker

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
		else
			# echo "/var/lib/docker is just a plain directory"
			# sudo mv -f /var/lib/docker "${DOCKER_BASEPATH}"
			# mkdir "${DOCKER_BASEPATH}"
			sudo ln -sf "${DOCKER_BASEPATH}" "/var/lib/docker"
			sudo ls -la "/var/lib/docker"
		fi

		echo "Docker installation completed."

	fi

	sudo systemctl enable --now docker
	sudo systemctl enable --now docker.socket

	if [[ ${DOCKER_RUNTIME} != "nvidia-container-runtime" ]]; then

		sudo nvidia-ctk runtime configure --runtime=docker
		sudo systemctl restart docker
		sleep 1
		docker rm nvidia-smi
		docker run --name=nvidia-smi --runtime=nvidia --gpus all ubuntu nvidia-smi

	fi

}

# REMOVE_DOCKER

# Call the function to install Docker
INSTALL_DOCKER
