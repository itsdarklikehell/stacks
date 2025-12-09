#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export COMFY_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/comfyui"

RUN_COMFYUI() {

	cd "${COMFY_PATH}" || exit 1

	if [[ -f .venv/bin/activate ]]; then
		source .venv/bin/activate
	else
		export UV_LINK_MODE=copy
		uv venv --clear --seed
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install comfy-cli
		uv run comfy-cli install --nvidia --restore
	fi

	if [[ ${BACKGROUND} == "true" ]]; then
		echo "Starting ComfyUI in background mode..."
		uv run comfy-cli launch --background -- --listen "${IP_ADDRESS}" --port "${COMFYUI_PORT}"
	else
		echo "Starting ComfyUI in foreground mode..."
		uv run comfy-cli launch --no-background -- --listen "${IP_ADDRESS}" --port "${COMFYUI_PORT}"
	fi
}

RUN_COMFYUI
