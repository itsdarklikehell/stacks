#!/bin/bash
echo "Start CushyStudio script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export CUSHYSTUDIO_PORT=8688

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
export CUSHYSTUDIO_PATH="${STACK_BASEPATH}/DATA/ai-stack/CushyStudio"

function RUN_CUSHYSTUDIO() {

	cd "${CUSHYSTUDIO_PATH}" || exit 1

	./_mac-linux-start.sh
}

RUN_CUSHYSTUDIO
