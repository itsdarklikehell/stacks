#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy

RUN_COMFYUI() {

	cd /media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/comfyui || exit 1

	if [[ -f .venv/bin/activate ]]; then
		source .venv/bin/activate
	else
		uv venv --clear --seed
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install comfy-cli
		uv run comfy-cli install --nvidia --restore

	fi

	uv run comfy-cli launch --background -- --listen 0.0.0.0 --port 8188
}

RUN_COMFYUI
