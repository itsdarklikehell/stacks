#!/bin/bash
# set -e

echo "Folder linker script started."

export STACK_BASEPATH="/media/hans/4-T/stacks"

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"

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
	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${DOCKER_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export DOCKER_BASEPATH

	eval "$(resize)" || true
	STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${STACK_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export STACK_BASEPATH

	eval "$(resize)" || true
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip address?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export IP_ADDRESS

	cd "${STACK_BASEPATH}" || exit
	git pull # SOURCE main
	chmod +x "install-stack.sh"

}

SETUP_ENV

function LINK_FOLDERS() {

	function LINKER() {

		if test -L "${DEST}"; then
			echo "${DEST} is already a symlink."
			echo ""
		elif test -d "${DEST}"; then
			echo "${DEST} is just a plain directory!"

			# echo "Checking if ${SOURCE} exists"
			if [[ ! -d ${SOURCE} ]] && [[ ! -L ${SOURCE} ]]; then
				# echo "Creating ${SOURCE}"
				mkdir -p "${SOURCE}"
			fi

			# echo "Trying to move files!"
			# echo "from ${DEST} to ${SOURCE}"
			rsync -aHAX "${DEST}"/* "${SOURCE}"

			# echo "Removing ${DEST}"
			rm -rf "${DEST}"

			# echo "symlinking ${DEST} to ${SOURCE}"
			ln -sf "${SOURCE}" "${DEST}"
		else
			# echo "${DEST} is not a symlink nor a existing directory"

			# echo "Checking if folder ${SOURCE} exists"
			if [[ ! -d ${SOURCE} ]] && [[ ! -L ${SOURCE} ]]; then
				echo "Creating ${SOURCE}"
				mkdir -p "${SOURCE}"
			fi

			# echo "Checking if folder ${DEST} exists"
			if [[ ! -d ${DEST} ]] && [[ ! -L ${DEST} ]]; then
				mkdir -p "${DEST}"
				rm -rf "${DEST}"
			fi

			# echo "symlinking ${DEST} to ${SOURCE}"
			if [[ -d ${SOURCE} ]]; then
				ln -sf "${SOURCE}" "${DEST}"
			fi
		fi

	}

	function COMFYUI_MODELS() {
		# ### comfyui_models > ComfyUI/models
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/models"
		LINKER

		DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
		LINKER
	}

	function OTHER_MODELS() {
		# ### comfyui_models > InvokeAI_models
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/InvokeAI_models/comfyui_models"
		LINKER

		# # ### comfyui_models > anything-llm_models
		# SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		# DEST="${STACK_BASEPATH}/DATA/ai-stack/anything-llm_models/comfyui_models"
		# LINKER

		# # ### comfyui_models > comfyui_models
		# SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		# DEST="${STACK_BASEPATH}/DATA/ai-stack/comfyui_models/comfyui_models"
		# LINKER

		# # ### comfyui_models > forge_models
		# SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		# DEST="${STACK_BASEPATH}/DATA/ai-stack/forge_models/comfyui_models"
		# LINKER

		# # ### comfyui_models > InvokeAI_models
		# SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		# DEST="${STACK_BASEPATH}/DATA/ai-stack/InvokeAI_models/comfyui_models"
		# LINKER

		# # ### comfyui_models > localai_models
		# SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		# DEST="${STACK_BASEPATH}/DATA/ai-stack/localai_models/comfyui_models"
		# LINKER

		# # ### comfyui_models > ollama_models
		# SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		# DEST="${STACK_BASEPATH}/DATA/ai-stack/ollama_models/comfyui_models"
		# LINKER
	}

	function AI_INPUTS() {
		## ai-outputs > ComfyUI/output
		SOURCE="${STACK_BASEPATH}/DATA/ai-outputs"
		DEST="${COMFYUI_PATH}/output"
		LINKER
		## variety/Downloaded > ai-outputs
		SOURCE="/home/${USER}/.config/variety/Downloaded"
		DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
		LINKER
		## variety/Fetched > ai-outputs
		SOURCE="/home/${USER}/.config/variety/Fetched"
		DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
		LINKER
		## variety/Favorites > ai-outputs
		SOURCE="/home/${USER}/.config/variety/Favorites"
		DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
		LINKER
	}

	function AI_OUTPUTS() {
		## ai-inputs > ComfyUI/input
		SOURCE="${STACK_BASEPATH}/DATA/ai-inputs"
		DEST="${COMFYUI_PATH}/input"
		LINKER
		## variety/Downloaded > ai-inputs
		SOURCE="/home/${USER}/.config/variety/Downloaded"
		DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
		LINKER
		## variety/Fetched > ai-inputs
		SOURCE="/home/${USER}/.config/variety/Fetched"
		DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
		LINKER
		## variety/Favorites > ai-inputs
		SOURCE="/home/${USER}/.config/variety/Favorites"
		DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
		LINKER
	}

	COMFYUI_MODELS
	OTHER_MODELS

	AI_INPUTS
	AI_OUTPUTS
}

LINK_FOLDERS
