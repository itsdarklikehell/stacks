#!/bin/bash
echo "Start ComfyUI script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUIMINI_PORT=3000

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
export COMFYMINI_PATH="/${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini"

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
		echo "User selected Ok and entered " "${STACK_BASEPATH}"
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

function RUN_COMFYUIMINI() {

	cd "${COMFYMINI_PATH}" || exit 1
	# ./scripts/install.sh
	./scripts/start.sh &

	echo "Starting ComfyUI Mini..."
}

RUN_COMFYUIMINI
