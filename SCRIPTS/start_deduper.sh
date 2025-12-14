#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path
export DO_REMOVE=true         #

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

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
	rmlint -g -o sh:rmlint.sh -c sh:symlink "${folder}" # -T "list" (default: defaults)>/dev/null 2>&1 &

	./rmlint.sh -dp # >/dev/null 2>&1 &

	echo "Deduplicated ${folder}"
done

wavfile=https://www.winhistory.de/more/winstart/down/owin31.wav
wget -c "${wavfile}" -O "tadaa.wav" >/dev/null 2>&1 &
cvlc tadaa.wav >/dev/null 2>&1 &
