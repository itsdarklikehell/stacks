#!/bin/bash
# set -e

echo "Start ComfyUI script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

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
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip adress?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export IP_ADDRESS

	cd "${STACK_BASEPATH}" || exit
	git pull # origin main
	chmod +x "install-stack.sh"

}
SETUP_ENV

if [[ ! -d ${COMFYUI_PATH} ]]; then
	echo "Cloning ComfyUI"
	echo ""
	git clone --recursive https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_PATH}"
	cd "${COMFYUI_PATH}" || exit 1
else
	echo "Checking ComfyUI for updates"
	cd "${COMFYUI_PATH}" || exit 1
	git pull
fi

"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"
curl -fsSL https://get.pnpm.io/install.sh | sh - || true

function CREATE_FOLDERS() {

	mkdir -p "${STACK_BASEPATH}/DATA/ai-backends"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/anything-llm_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/forge_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/InvokeAI_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/localai_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/swarmui_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/anything-llm_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/forge_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/InvokeAI_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/localai_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/ollama_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/swarmui_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"
	mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
	mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-custom_nodes"

}

function LINK_FOLDERS() {

	function LINKER() {

		if test -L "${LINK}"; then
			echo "${LINK} is allready a symlink."
			echo ""
		elif test -d "${LINK}"; then
			echo "${LINK} is just a plain directory!"

			# echo "Checking if ${ORIGIN} exists"
			if [[ ! -d ${ORIGIN} ]] && [[ ! -L ${ORIGIN} ]]; then
				# echo "Creating ${ORIGIN}"
				mkdir -p "${ORIGIN}"
			fi

			# echo "Trying to move files!"
			# echo "from ${LINK} to ${ORIGIN}"

			rsync -aHAX "${LINK}"/* "${ORIGIN}"
			# mv -f "${LINK}"/* "${ORIGIN}"
			# cp -au "${LINK}" "${ORIGIN}"

			# echo "Removing ${LINK}"
			rm -rf "${LINK}"

			# echo "Symlinking ${LINK} to ${ORIGIN}"
			ln -sf "${ORIGIN}" "${LINK}"
		else
			# echo "${LINK} is not a symlink nor a existing directory"

			# echo "Checking if folder ${ORIGIN} exists"
			if [[ ! -d ${ORIGIN} ]] && [[ ! -L ${ORIGIN} ]]; then
				echo "Creating ${ORIGIN}"
				mkdir -p "${ORIGIN}"
			fi

			# echo "Checking if folder ${LINK} exists"
			if [[ ! -d ${LINK} ]] && [[ ! -L ${LINK} ]]; then
				mkdir -p "${LINK}"
				rm -rf "${LINK}"
			fi

			# echo "Symlinking ${LINK} to ${ORIGIN}"
			if [[ -d ${ORIGIN} ]]; then
				ln -sf "${ORIGIN}" "${LINK}"
			fi
		fi

	}

	## InvokeAI models
	LINK="${COMFYUI_PATH}/models/InvokeAI_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"
	LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/InvokeAI_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/InvokeAI_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/localai_models/InvokeAI_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/ollama_models/InvokeAI_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/forge_models/InvokeAI_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/InvokeAI_models"
	# LINKER

	# # LINK="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/InvokeAI_models"
	# LINKER

	## Anything-LLM models
	LINK="${COMFYUI_PATH}/models/anything-llm_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"
	LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/anything-llm_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/anything-llm_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/localai_models/anything-llm_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/ollama_models/anything-llm_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/forge_models/anything-llm_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/anything-llm_models"
	# LINKER
	# LINK="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/anything-llm_models"
	# LINKER

	## LocalAI models
	LINK="${COMFYUI_PATH}/models/localai_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/localai_models"
	LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/localai_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/localai_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/localai_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/ollama_models/localai_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/forge_models/localai_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/localai_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/localai_models/localai_models"
	# LINKER

	## Ollama models
	LINK="${COMFYUI_PATH}/models/ollama_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/ollama_models"
	LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/ollama_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/ollama_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/ollama_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/localai_models/ollama_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/ollama_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/forge_models/ollama_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/ollama_models/ollama_models"
	# LINKER

	## Forge models
	LINK="${COMFYUI_PATH}/models/forge_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/forge_models"
	LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/forge_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/forge_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/forge_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/localai_models/forge_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/ollama_models/forge_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/forge_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/forge_models/forge_models"
	# LINKER

	## ComfyUI models
	LINK="${COMFYUI_PATH}/models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/comfyui_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
	# LINKER

	# LINK="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/comfyui_models"
	# LINKER

	## ComfyUI models > custom_nodes
	LINK="${COMFYUI_PATH}/custom_nodes/models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	LINKER

	## ComfyUI custom_nodes
	LINK="${COMFYUI_PATH}/custom_nodes"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-custom_nodes"
	LINKER

	## ComfyUI workflows default/workflows
	LINK="${COMFYUI_PATH}/user/default/workflows"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-workflows"
	LINKER
	## ComfyUI workflows models/workflows
	LINK="${COMFYUI_PATH}/models/workflows/workflows"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-workflows"
	LINKER
	## ComfyUI workflows custom_nodes/workflows
	LINK="${COMFYUI_PATH}/custom_nodes/workflows/workflows"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-workflows"
	LINKER

	## ComfyUI output
	LINK="${COMFYUI_PATH}/output"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-outputs"
	LINKER

	## ComfyUI input
	LINK="${COMFYUI_PATH}/input"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-inputs"
	LINKER

	## Variety input
	LINK="${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
	ORIGIN="/home/${USER}/.config/variety/Downloaded"
	LINKER

	LINK="${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
	ORIGIN="/home/${USER}/.config/variety/Fetched"
	LINKER

	LINK="${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
	ORIGIN="/home/${USER}/.config/variety/Favorites"
	LINKER

	## Variety output
	LINK="${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
	ORIGIN="/home/${USER}/.config/variety/Downloaded"
	LINKER

	LINK="${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
	ORIGIN="/home/${USER}/.config/variety/Fetched"
	LINKER

	LINK="${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
	ORIGIN="/home/${USER}/.config/variety/Favorites"
	LINKER

}

function CLONE_WORKFLOWS() {

	# export WORKFLOWDIR="${STACK_BASEPATH}/DATA/ai-workflows"
	export WORKFLOWDIR="${COMFYUI_PATH}/user/default/workflows"

	if [[ ! -d ${WORKFLOWDIR} ]]; then
		mkdir -p "${WORKFLOWDIR}"
	fi

	cd "${WORKFLOWDIR}" || exit 1

	sources=(
		comfyanonymous/ComfyUI_examples
		cubiq/ComfyUI_Workflows
		aimpowerment/comfyui-workflows
		wyrde/wyrde-comfyui-workflows
		comfyui-wiki/workflows
		loscrossos/comfy_workflows
		jhj0517/ComfyUI-workflows
		ZHO-ZHO-ZHO/ComfyUI-Workflows-ZHO
		yolain/ComfyUI-Yolain-Workflows
		dseditor/ComfyuiWorkflows
		Comfy-Org/workflows
		Comfy-Org/workflow_templates
		xiwan/comfyUI-workflows
		BoosterCore/ChaosFlow
		yuyou-dev/workflow
		dci05049/Comfyui-workflows
		ecjojo/ecjojo-comfyui-workflows
		ttio2tech/ComfyUI_workflows_collection
		pwillia7/Basic_ComfyUI_Workflows
		nerdyrodent/AVeryComfyNerd
	)
	for SOURCE in "${sources[@]}"; do
		if [[ ! -d "${WORKFLOWDIR}/${SOURCE}" ]]; then
			git clone --recursive https://github.com/"${SOURCE}".git "${WORKFLOWDIR}/${SOURCE}"
		else
			echo "Checking ${SOURCE} for updates"
			cd "${WORKFLOWDIR}/${SOURCE}" || exit 1
			git pull
		fi
	done

}

function INSTALL_CUSTOM_NODES() {

	export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
	export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/extra_custom_nodes.txt"
	export DISABLED_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/disabled_custom_nodes.txt"
	export REMOVED_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/removed_custom_nodes.txt"

	function ESSENTIAL() {

		if [[ ${INSTALL_DEFAULT_NODES} == "true" ]]; then
			echo "Installing ComfyUI custom nodes..."
			if [[ -f ${ESSENTIAL_CUSTOM_NODELIST} ]]; then
				echo "Reinstalling custom nodes from ${ESSENTIAL_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n ${node_name} ]] && [[ ${node_name} != \#* ]]; then
						uv run comfy-cli node install "${node_name}"
					fi
				done <"${ESSENTIAL_CUSTOM_NODELIST}"
				echo ""
			else
				echo "No ${ESSENTIAL_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
			fi
		else
			echo "Skipping ComfyUI custom node install."
		fi

	}

	function EXTRAS() {

		if [[ ${INSTALL_EXTRA_NODES} == "true" ]]; then
			echo "Installing ComfyUI extra nodes..."
			if [[ -f ${EXTRA_CUSTOM_NODELIST} ]]; then
				echo "Reinstalling custom nodes from ${EXTRA_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n ${node_name} ]] && [[ ${node_name} != \#* ]]; then
						uv run comfy-cli node install "${node_name}"
					fi
				done <"${EXTRA_CUSTOM_NODELIST}"
				echo ""
			else
				echo "No ${EXTRA_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
			fi
		else
			echo "Skipping ComfyUI extra node install."
		fi

	}

	function DISABLED() {

		if [[ ${INSTALL_DEFAULT_NODES} == "true" ]]; then
			echo "Disableing some ComfyUI custom nodes..."
			if [[ -f ${DISABLED_CUSTOM_NODELIST} ]]; then
				echo "Disableing custom nodes from ${DISABLED_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n ${node_name} ]] && [[ ${node_name} != \#* ]]; then
						uv run comfy-cli node disable "${node_name}"
					fi
				done <"${DISABLED_CUSTOM_NODELIST}"
				echo ""
			else
				echo "No ${DISABLED_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
			fi
		else
			echo "Skipping disableing some ComfyUI custom node install."
		fi

	}

	function REMOVED() {

		if [[ ${INSTALL_DEFAULT_NODES} == "true" ]]; then
			echo "Removing some ComfyUI custom nodes..."
			if [[ -f ${REMOVED_CUSTOM_NODELIST} ]]; then
				echo "Removing custom nodes from ${REMOVED_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n ${node_name} ]] && [[ ${node_name} != \#* ]]; then
						uv run comfy-cli node disable "${node_name}"
					fi
				done <"${REMOVED_CUSTOM_NODELIST}"
				echo ""
			else
				echo "No ${REMOVED_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
			fi
		else
			echo "Skipping Removing some ComfyUI custom node install."
		fi

	}

	ESSENTIAL
	EXTRAS
	DISABLED
	REMOVED
	UPDATE_CUSTOM_NODES

}

function UPDATE_CUSTOM_NODES() {

	if [[ ${UPDATE} == "true" ]]; then
		echo "Updating all ComfyUI custom nodes..."
		uv run comfy-cli update all
	else
		echo "Skipping ComfyUI custom node update."
	fi

}

function LOCAL_SETUP() {

	echo "Using Local setup"
	# ./install.sh

	if [[ -f .venv/bin/activate ]]; then
		# shellcheck source=/dev/null
		source .venv/bin/activate
	else
		export UV_LINK_MODE=copy
		uv venv --clear --seed
		# shellcheck source=/dev/null
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

		CREATE_FOLDERS
		LINK_FOLDERS

		uv pip install comfy-cli
		yes | uv run comfy-cli install --nvidia --restore || true
	fi

}

function DOCKER_SETUP() {

	echo "Using Docker setup"
	# cp -f "${STACK_BASEPATH}/SCRIPTS/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
	# cp -f "${STACK_BASEPATH}/SCRIPTS/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
	# cp -f "${STACK_BASEPATH}/SCRIPTS/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
	# docker build -t whisperx .

}

function RUN_COMFYUI() {

	cd "${COMFYUI_PATH}" || exit 1

	if [[ -f .venv/bin/activate ]]; then
		# shellcheck source=/dev/null
		source .venv/bin/activate
	else
		export UV_LINK_MODE=copy
		uv venv --clear --seed
		# shellcheck source=/dev/null
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install comfy-cli
		yes | uv run comfy-cli install --nvidia --restore || true

		echo "ComfyUI virtual environment created and dependencies installed."
	fi

	if [[ ${BACKGROUND} == "true" ]]; then
		echo "Starting ComfyUI in background mode..."
		uv run comfy-cli launch --background -- --preview-method auto --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	else
		echo "Starting ComfyUI in foreground mode..."
		uv run comfy-cli launch --no-background -- --preview-method auto --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	fi

}

LOCAL_SETUP  # >/dev/null 2>&1 &
DOCKER_SETUP # >/dev/null 2>&1 &

INSTALL_DEFAULT_NODES=true
INSTALL_EXTRA_NODES=true
UPDATE=true

CREATE_FOLDERS
LINK_FOLDERS

INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &
CLONE_WORKFLOWS

"${STACK_BASEPATH}"/SCRIPTS/done_sound.sh
xdg-open "http://${IP_ADDRESS}:8188/"

RUN_COMFYUI
