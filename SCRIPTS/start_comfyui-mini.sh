#!/bin/bash
echo "Start ComfyUI script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUIMINI_PORT=3000

export STACK_BASEPATH="/media/hans/4-T/stacks"
export COMFYMINI_PATH="/${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini"

function RUN_COMFYUIMINI() {

	cd "${COMFYMINI_PATH}" || exit 1
	# ./scripts/install.sh
	./scripts/start.sh &

	echo "Starting ComfyUI Mini..."
}

RUN_COMFYUIMINI
