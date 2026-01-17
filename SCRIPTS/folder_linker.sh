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
		export COMFYUI_PATH="/${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
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

	eval "$(resize)" || true
	STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${STACK_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	eval "$(resize)" || true
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip address?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	export DOCKER_BASEPATH
	export STACK_BASEPATH
	export IP_ADDRESS
	# export COMFYUI_MODEL_PATH="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"

	cd "${STACK_BASEPATH}" || exit 1

	echo ""
	START_CUSHYSTUDIO >/dev/null 2>&1 &
	echo "" || exit

	git pull # origin main
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

	function COMFYUI_WORKFLOWS() {

		# ### ai-workflows > ComfyUI/workflows
		SOURCE="${STACK_BASEPATH}/DATA/ai-workflows"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/workflows"
		LINKER
		# ### ai-workflows > ai-models/comfyui_models/workflows
		DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/workflows"
		LINKER
		# ### ai-workflows > ComfyUI/user/default/workflows
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/user/default/workflows"
		LINKER

	}

	function COMFYUI_NODES() {

		# ### ai-custom_nodes > ComfyUI/custom_nodes
		SOURCE="${STACK_BASEPATH}/DATA/ai-custom_nodes"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/custom_nodes"
		LINKER

	}

	function COMFYUI_STYLES() {

		# ### ai-custom_nodes > ComfyUI/custom_nodes
		SOURCE="${STACK_BASEPATH}/DATA/ai-styles"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/styles"
		LINKER

		# ### ai-styles/*.csv > ComfyUI/*.csv
		for FILE in "${STACK_BASEPATH}"/DATA/ai-styles/*.csv; do

			SOURCE="${FILE}"
			DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/${FILE}"
			LINKER

		done

	}

	function COMFYUI_MODELS() {

		# ### comfyui_models > ComfyUI/models
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/models"
		LINKER

		# ### comfyui_models > anything-llm_models/comfyui_models
		DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
		LINKER
		# ### comfyui_models > localai_models/comfyui_models
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
		LINKER
		# ### comfyui_models > ollama_models/comfyui_models
		DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
		LINKER

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
	COMFYUI_NODES
	COMFYUI_STYLES
	COMFYUI_WORKFLOWS

	AI_INPUTS
	AI_OUTPUTS
}

LINK_FOLDERS
