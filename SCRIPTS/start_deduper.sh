#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path
export DO_REMOVE=true         #

export STACK_BASEPATH="/media/hans/4-T/stacks"

export AI_MODELS_PATH="${STACK_BASEPATH}/DATA/ai-models"
export AI_INPUTS_PATH="${STACK_BASEPATH}/DATA/ai-inputs"
export AI_OUTPUTS_PATH="${STACK_BASEPATH}/DATA/ai-outputs"
export AI_WORKFLOWS_PATH="${STACK_BASEPATH}/DATA/ai-workflows"

sudo apt install -y rmlint rmlint-gui vlc >/dev/null 2>&1 &

cd "${STACK_BASEPATH}/SCRIPTS" || exit 1

folders=(
	"${AI_MODELS_PATH}"
	"${AI_INPUTS_PATH}"
	"${AI_OUTPUTS_PATH}"
	"${AI_WORKFLOWS_PATH}"
)

for folder in "${folders[@]}"; do
	echo "Deduplicating ${folder}"

	rmlint -mkgfV -o sh:rmlint.sh -c sh:symlink "${folder}" # >/dev/null 2>&1 &

	./rmlint.sh -dpxq # >/dev/null 2>&1 &
	rm "${STACK_BASEPATH}/SCRIPTS/rmlint.sh" >/dev/null 2>&1 &
	rm "${STACK_BASEPATH}/SCRIPTS/rmlint.json" >/dev/null 2>&1 &

	echo "Deduplicated ${folder}"
done
