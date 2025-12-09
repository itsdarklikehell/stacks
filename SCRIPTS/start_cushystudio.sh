#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export CUSHYSTUDIO_PORT=8688

RUN_CUSHYSTUDIO() {

	cd /media/hans/opslag/stacks/DATA/ai-stack/CushyStudio || exit 1

	./_mac-linux-start.sh
}

RUN_COMFYUI
