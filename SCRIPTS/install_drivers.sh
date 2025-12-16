#!/bin/bash
echo "Install drivers script started."

# Install NVIDIA drivers on Ubuntu
function INSTALL_DRIVERS() {

	DOCKER_RUNTIME="$(cat /etc/docker/daemon.json | jq -r '.runtimes | .nvidia | .path' || true)"
	CUDA_VERSION="$(cat /usr/local/cuda/version.json | jq -r '.cuda | .version' || true)"
	DRIVER_VERSION="$(cat /usr/local/cuda/version.json | jq -r '.nvidia_driver | .version' || true)"

	if [[ ! -f "/usr/local/cuda/version.json" ]]; then
		# check if curl is installed, if not install it
		if ! command -v curl &>/dev/null; then
			echo "curl could not be found, installing it..."
			sudo apt update && sudo apt install -y curl
		fi
		# check if nvidia-container-toolkit-keyring.gpg file exists in /usr/share/keyrings/, if not create it
		if [[ ! -f "/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg" ]]; then
			echo "Creating nvidia-container-toolkit-keyring.gpg file..."
			curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg || true
		fi
		# check if nvidia-container-toolkit.list file exists in /etc/apt/sources.list.d/, if not create it
		if [[ ! -f "/etc/apt/sources.list.d/nvidia-container-toolkit.sources" ]]; then
			echo "Creating nvidia-container-toolkit.list file..."
			curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list || true
			sudo apt modernize-sources -y
		fi
		# check if nvidia-cuda toolkit is installed, if not install it
		if ! dpkg -l | grep -q cuda-drivers; then
			echo "Installing cuda-drivers"
			sudo apt update && sudo apt install -y cuda-drivers
		fi
		# check if nvidia-container-toolkit is installed, if not install it
		if ! dpkg -l | grep -q nvidia-container-toolkit; then
			echo "Installing nvidia-container-toolkit"
			sudo apt update && sudo apt install -y nvidia-container-toolkit
		fi
		# check if nvidia-cuda-toolkit is installed, if not install it
		if ! dpkg -l | grep -q nvidia-cuda-toolkit; then
			sudo apt update && sudo apt install -y nvidia-cuda-toolkit
		fi
	fi

	if [[ "${DOCKER_RUNTIME}" != "nvidia-container-runtime" ]]; then
		sudo nvidia-ctk runtime configure --runtime=docker
		sudo systemctl restart docker
		docker rm nvidia-smi
		docker run --name=nvidia-smi --runtime=nvidia --gpus all ubuntu nvidia-smi
	fi

	echo "NVIDIA driver ${DRIVER_VERSION} installation completed."
	echo "NVIDIA CUDA ${CUDA_VERSION} installation completed."
	echo "${DOCKER_RUNTIME} installation completed."

	export CUDA_HOME="/usr/local/cuda"
	export PATH="${PATH}:${CUDA_HOME}/bin"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64"

}

INSTALL_DRIVERS
