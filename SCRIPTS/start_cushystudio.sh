#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export CUSHYSTUDIO_PORT=8688

export CUSHYSTUDIO_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/CushyStudio"

function RUN_CUSHYSTUDIO() {

	cd "${CUSHYSTUDIO_PATH}" || exit 1

	./_mac-linux-start.sh
}

RUN_CUSHYSTUDIO
