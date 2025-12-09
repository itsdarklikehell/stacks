#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export COMFYMINI_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/ComfyUIMini"

RUN_COMFYUIMINI() {

	cd "${COMFYMINI_PATH}" || exit 1
	# ./scripts/install.sh
	./scripts/start.sh &

	echo "Starting ComfyUI Mini..."
}

RUN_COMFYUIMINI
