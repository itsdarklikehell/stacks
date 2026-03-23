#!/bin/bash
# set -e

export HOMEBREW_NO_ENV_HINTS=1

echo "Install vllm script started."

function INSTALL_VLLM() {

	cd ~/ || exit 1
	git clone --recursive https://github.com/vllm-project/vllm ~/vllm
	cd ~/vllm || exit 1

	export UV_LINK_MODE=copy
	uv venv --clear --seed
	uv sync --all-extras
	uv pip install --upgrade pip
	uv pip install -r requirements.txt

	# Replace X.Y.Z (0.5.9) with the version by your vllm install
	# uv pip install torch==X.Y.Z torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130
	# x86_64
	# uv pip install "https://github.com/sgl-project/whl/releases/download/vX.Y.Z/sgl_kernel-X.Y.Z+cu130-cp310-abi3-manylinux2014_x86_64.whl"
	# aarch64
	# uv pip install "https://github.com/sgl-project/whl/releases/download/vX.Y.Z/sgl_kernel-X.Y.Z+cu130-cp310-abi3-manylinux2014_aarch64.whl"
	
	uv pip install vllm

}

source ~/.bashrc
INSTALL_VLLM
