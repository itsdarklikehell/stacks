#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export CUSHYSTUDIO_PORT=8688

RUN_CUSHYSTUDIO() {

	cd "${BASEPATH}/DATA/ai-stack/CushyStudio" || exit 1

	./_mac-linux-start.sh
}

RUN_COMFYUI
