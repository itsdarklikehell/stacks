#!/bin/bash
# set -e

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path
export DO_REMOVE=true         #

sudo apt install -y rmlint rmlint-gui vlc # >/dev/null 2>&1 &

function SETUP_ENV() {

	IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
	export IP_ADDRESS

	if [[ ${USER} == "hans" ]]; then
		export STACK_BASEPATH="/media/hans/4-T/stacks"
		export DOCKER_BASEPATH="/media/hans/4-T/docker"
		export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
	elif [[ ${USER} == "rizzo" ]]; then
		export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
		export DOCKER_BASEPATH="/media/rizzo/RAIDSTATION/docker"
		export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
	else
		export STACK_BASEPATH="/media/hans/4-T/stacks"
		export DOCKER_BASEPATH="/media/hans/4-T/docker"
		export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
	fi

	eval "$(resize)" || true
	DOCKER_BASEPATH=$(whiptail --inputbox "What is your docker folder?" "${LINES}" "${COLUMNS}" "${DOCKER_BASEPATH}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	eval "$(resize)" || true
	STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	eval "$(resize)" || true
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip address?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?

	export DOCKER_BASEPATH
	export STACK_BASEPATH
	export IP_ADDRESS

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${DOCKER_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${STACK_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	# export COMFYUI_MODEL_PATH="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"

	cd "${STACK_BASEPATH}" || exit 1

	echo ""
	START_CUSHYSTUDIO >/dev/null 2>&1 &
	echo "" || exit

	git pull # origin main
	chmod +x "install-stack.sh"

}

SETUP_ENV

export AI_MODELS_PATH="${STACK_BASEPATH}/DATA/ai-models"
export AI_INPUTS_PATH="${STACK_BASEPATH}/DATA/ai-inputs"
export AI_OUTPUTS_PATH="${STACK_BASEPATH}/DATA/ai-outputs"
export AI_WORKFLOWS_PATH="${STACK_BASEPATH}/DATA/ai-workflows"

export MAIN_MODELS_PATH="${AI_MODELS_PATH}/comfyui_models"

cd "${STACK_BASEPATH}" || exit 1

folders=(
	"${AI_MODELS_PATH}"
	"${AI_WORKFLOWS_PATH}"
	"${AI_OUTPUTS_PATH}"
	"${AI_INPUTS_PATH}"
)

modelfolders=(
	"${AI_MODELS_PATH}/anything-llm_models"
	"${AI_MODELS_PATH}/forge_models"
	"${AI_MODELS_PATH}/InvokeAI_models"
	"${AI_MODELS_PATH}/localai_models"
	"${AI_MODELS_PATH}/ollama_models"
	"${AI_MODELS_PATH}/comfyui_models"
)

for folder in "${folders[@]}"; do

	echo "Removing Leftovers and deduplicating ${folder}"

	if [[ ! -d ${folder} ]]; then
		echo "Folder ${folder} does not exist. Skipping..."
		continue
	fi

	if [[ ${folder} == "${AI_MODELS_PATH}" ]]; then
		for model_folder in "${modelfolders[@]}"; do
			if [[ ${model_folder} == "${MAIN_MODELS_PATH}" ]]; then
				echo "Processing model folder ${model_folder} ..."
				rmlint -g -T minimal -o sh:"${STACK_BASEPATH}/SCRIPTS/rmlint.sh" -o json:"${STACK_BASEPATH}/SCRIPTS/rmlint.json" -c sh:symlink -k "${MAIN_MODELS_PATH}" # // "${model_folder}"
			fi
			echo "Main Models Path: ${MAIN_MODELS_PATH}"
			echo "Processing model folder ${model_folder} ..."
			rmlint -g -T minimal -o sh:"${STACK_BASEPATH}/SCRIPTS/rmlint.sh" -o json:"${STACK_BASEPATH}/SCRIPTS/rmlint.json" -c sh:symlink -k "${MAIN_MODELS_PATH}" // "${model_folder}"
		done
		"${STACK_BASEPATH}/SCRIPTS/rmlint.sh" -dxprcq
	else
		echo "Processing folder ${folder} ..."
		rmlint -g -T minimal -o sh:"${STACK_BASEPATH}/SCRIPTS/rmlint.sh" -o json:"${STACK_BASEPATH}/SCRIPTS/rmlint.json" -c sh:symlink -k "${folder}"
		"${STACK_BASEPATH}/SCRIPTS/rmlint.sh" -dxprcq
	fi

	rm "${STACK_BASEPATH}/SCRIPTS/rmlint.sh"   # >/dev/null 2>&1 &
	rm "${STACK_BASEPATH}/SCRIPTS/rmlint.json" # >/dev/null 2>&1 &

	echo "Removed Leftovers and deduplicated  ${folder}"

done
