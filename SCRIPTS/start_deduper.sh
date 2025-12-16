#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path
export DO_REMOVE=true         #

export AI_MODELS_PATH="${STACK_BASEPATH}/DATA/ai-models"
export AI_INPUTS_PATH="${STACK_BASEPATH}/DATA/ai-inputs"
export AI_OUTPUTS_PATH="${STACK_BASEPATH}/DATA/ai-outputs"
export AI_WORKFLOWS_PATH="${STACK_BASEPATH}/DATA/ai-workflows"

sudo apt install -y rmlint rmlint-gui vlc >/dev/null 2>&1 &

function SETUP_ENV() {

	export IP_ADDRESS=$(hostname -I | awk '{print $1}') # get machine IP address
	export DOCKER_BASEPATH="/media/rizzo/RAIDSTATION/docker"
	export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
	export COMFYUI_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/ComfyUI"

	eval "$(resize)"
	DOCKER_BASEPATH=$(whiptail --inputbox "What is your docker folder?" "${LINES}" "${COLUMNS}" "${DOCKER_BASEPATH}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ "${exitstatus}" = 0 ]]; then
		echo "User selected Ok and entered " "${DOCKER_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export DOCKER_BASEPATH

	eval "$(resize)" || true
	STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ "${exitstatus}" = 0 ]]; then
		echo "User selected Ok and entered: S{STACK_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export STACK_BASEPATH

	eval "$(resize)"
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip adress?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ "${exitstatus}" = 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export IP_ADDRESS

}
SETUP_ENV

cd "${STACK_BASEPATH}/SCRIPTS" || exit 1

folders=(
	"${AI_MODELS_PATH}"
	"${AI_WORKFLOWS_PATH}"
)
# "${AI_INPUTS_PATH}"
# "${AI_OUTPUTS_PATH}"

for folder in "${folders[@]}"; do
	echo "Deduplicating ${folder}"

	rmlint -gfV --is-reflink -o sh:rmlint.sh -c sh:symlink "${folder}" # >/dev/null 2>&1 &

	./rmlint.sh -dpxq # >/dev/null 2>&1 &
	rm "${STACK_BASEPATH}/SCRIPTS/rmlint.sh" >/dev/null 2>&1 &
	rm "${STACK_BASEPATH}/SCRIPTS/rmlint.json" >/dev/null 2>&1 &

	echo "Deduplicated ${folder}"
done
