#!/bin/bash

echo "Start ComfyUI script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/extra_custom_nodes.txt"
export DISABLED_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/disabled_custom_nodes.txt"
export REMOVED_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/removed_custom_nodes.txt"

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"

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

	eval "$(resize)" || true
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

if [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]] || [[ "$1" == "--reinstall" ]]; then
	echo "Install custom nodes enabled."
	export INSTALL_CUSTOM_NODES=true
elif [[ "$1" == "-fr" ]] || [[ "$1" == "--full-reinstall" ]] || [[ "$1" == "--factory-reset" ]] || [[ "$1" == "--full-reinstall" ]]; then
	echo "Full re-install custom nodes enabled."
	export INSTALL_CUSTOM_NODES=true
	rm -rf "${COMFYUI_PATH}/.venv"
elif [[ -z "$1" ]] || [[ "$1" == "-nr" ]] || [[ "$1" == "--no-reinstall" ]]; then
	echo "Skipping reinstall custom nodes."
	export INSTALL_CUSTOM_NODES=false
fi

if [[ ! -d "${COMFYUI_PATH}" ]]; then
	echo "Cloning ComfyUI"
	echo ""
	git clone --recursive https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_PATH}"
fi

"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"

cd "${COMFYUI_PATH}" || exit 1
git pull

function CREATE_FOLDERS() {

	# mkdir -p "${COMFYUI_PATH}/custom_nodes/models"
	# mkdir -p "${COMFYUI_PATH}/input"
	# mkdir -p "${COMFYUI_PATH}/models"
	# mkdir -p "${COMFYUI_PATH}/models/anything-llm_models"
	# mkdir -p "${COMFYUI_PATH}/models/forge_models"
	# mkdir -p "${COMFYUI_PATH}/models/InvokeAI_models"
	# mkdir -p "${COMFYUI_PATH}/models/localai_models"
	# mkdir -p "${COMFYUI_PATH}/models/ollama_models"
	# mkdir -p "${COMFYUI_PATH}/output"
	# mkdir -p "${COMFYUI_PATH}/user/default/workflows"
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
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
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
	mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
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
			if [[ ! -d "${ORIGIN}" ]] && [[ ! -L "${ORIGIN}" ]]; then
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
			ln -s "${ORIGIN}" "${LINK}"
		else
			# echo "${LINK} is not a symlink nor a existing directory"

			# echo "Checking if folder ${ORIGIN} exists"
			if [[ ! -d "${ORIGIN}" ]] && [[ ! -L "${ORIGIN}" ]]; then
				echo "Creating ${ORIGIN}"
				mkdir -p "${ORIGIN}"
			fi

			# echo "Checking if folder ${LINK} exists"
			if [[ ! -d "${LINK}" ]] && [[ ! -L "${LINK}" ]]; then
				mkdir -p "${LINK}"
				rm -rf "${LINK}"
			fi

			# echo "Symlinking ${LINK} to ${ORIGIN}"
			if [[ -d "${ORIGIN}" ]]; then
				ln -s "${ORIGIN}" "${LINK}"
			fi
		fi

	}
	## InvokeAI models
	LINK="${COMFYUI_PATH}/models/InvokeAI_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"
	LINKER

	## Anything-LLM models
	LINK="${COMFYUI_PATH}/models/anything-llm_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"
	LINKER

	## LocalAI models
	LINK="${COMFYUI_PATH}/models/localai_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/localai_models"
	LINKER

	## Ollama models
	LINK="${COMFYUI_PATH}/models/ollama_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/ollama_models"
	LINKER

	## Forge models
	LINK="${COMFYUI_PATH}/models/forge_models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/forge_models"
	LINKER

	## ComfyUI models
	LINK="${COMFYUI_PATH}/models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	LINKER

	## ComfyUI models > custom_nodes
	LINK="${COMFYUI_PATH}/custom_nodes/models"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	LINKER

	## ComfyUI custom_nodes
	LINK="${COMFYUI_PATH}/custom_nodes"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-custom_nodes"
	LINKER

	## ComfyUI workflows
	LINK="${COMFYUI_PATH}/user/default/workflows"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-workflows"
	LINKER

	## ComfyUI workflows > ComfyUIMini
	LINK="${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
	ORIGIN="${STACK_BASEPATH}/DATA/ai-workflows"
	LINKER

	# ## ComfyUI workflows > models/workflows
	LINK="${COMFYUI_PATH}/models/workflows/workflows"
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

	export WORKFLOWDIR="${COMFYUI_PATH}/user/default/workflows"
	cd "${WORKFLOWDIR}" || exit 1

	git clone --recursive https://github.com/comfyanonymous/ComfyUI_examples.git "${WORKFLOWDIR}/comfyanonymous/ComfyUI_examples"

	git clone --recursive https://github.com/cubiq/ComfyUI_Workflows.git "${WORKFLOWDIR}/cubiq/ComfyUI_Workflows"

	git clone --recursive https://github.com/aimpowerment/comfyui-workflows.git "${WORKFLOWDIR}/aimpowerment/comfyui-workflows"

	git clone --recursive https://github.com/wyrde/wyrde-comfyui-workflows.git "${WORKFLOWDIR}/wyrde/wyrde-comfyui-workflows"

	git clone --recursive https://github.com/comfyui-wiki/workflows.git "${WORKFLOWDIR}/comfyui-wiki/workflows"

	git clone --recursive https://github.com/loscrossos/comfy_workflows.git "${WORKFLOWDIR}/loscrossos/comfy_workflows"

	git clone --recursive https://github.com/jhj0517/ComfyUI-workflows.git "${WORKFLOWDIR}/jhj0517/ComfyUI-workflows"

	git clone --recursive https://github.com/ZHO-ZHO-ZHO/ComfyUI-Workflows-ZHO.git "${WORKFLOWDIR}/ZHO-ZHO-ZHO/ComfyUI-Workflows-ZHO"

	git clone --recursive https://github.com/yolain/ComfyUI-Yolain-Workflows.git "${WORKFLOWDIR}/yolain/ComfyUI-Yolain-Workflows"

	git clone --recursive https://github.com/dseditor/ComfyuiWorkflows.git "${WORKFLOWDIR}/dseditor/ComfyuiWorkflows"

	git clone --recursive https://github.com/Comfy-Org/workflow_templates.git "${WORKFLOWDIR}/Comfy-Org/workflow_templates"

	git clone --recursive https://github.com/Comfy-Org/workflows.git "${WORKFLOWDIR}/Comfy-Org/workflows"

	git clone --recursive https://github.com/xiwan/comfyUI-workflows.git "${WORKFLOWDIR}/xiwan/comfyUI-workflows"

	git clone --recursive https://github.com/BoosterCore/ChaosFlow.git "${WORKFLOWDIR}/BoosterCore/ChaosFlow"

	git clone --recursive https://github.com/yuyou-dev/workflow.git "${WORKFLOWDIR}/yuyou-dev/workflow"

	git clone --recursive https://github.com/dci05049/Comfyui-workflows.git "${WORKFLOWDIR}/dci05049/Comfyui-workflows"

	git clone --recursive https://github.com/ecjojo/ecjojo-comfyui-workflows.git "${WORKFLOWDIR}/ecjojo/ecjojo-comfyui-workflows"

	git clone --recursive https://github.com/ttio2tech/ComfyUI_workflows_collection.git "${WORKFLOWDIR}/ttio2tech/ComfyUI_workflows_collection"

	git clone --recursive https://github.com/pwillia7/Basic_ComfyUI_Workflows.git "${WORKFLOWDIR}/pwillia7/Basic_ComfyUI_Workflows"

	git clone --recursive https://github.com/pwillia7/Basic_ComfyUI_Workflows.git "${WORKFLOWDIR}/pwillia7/Basic_ComfyUI_Workflows"

	git clone --recursive https://github.com/nerdyrodent/AVeryComfyNerd.git "${WORKFLOWDIR}/nerdyrodent/AVeryComfyNerd"

}

function INSTALL_CUSTOM_NODES() {

	function ESSENTIAL() {

		if [[ "${INSTALL_DEFAULT_NODES}" == "true" ]]; then
			echo "Installing ComfyUI custom nodes..."
			if [[ -f "${ESSENTIAL_CUSTOM_NODELIST}" ]]; then
				echo "Reinstalling custom nodes from ${ESSENTIAL_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n "${node_name}" ]] && [[ "${node_name}" != \#* ]]; then
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

		if [[ "${INSTALL_EXTRA_NODES}" == "true" ]]; then
			echo "Installing ComfyUI extra nodes..."
			if [[ -f "${EXTRA_CUSTOM_NODELIST}" ]]; then
				echo "Reinstalling custom nodes from ${EXTRA_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n "${node_name}" ]] && [[ "${node_name}" != \#* ]]; then
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

		if [[ "${INSTALL_DEFAULT_NODES}" == "true" ]]; then
			echo "Disableing some ComfyUI custom nodes..."
			if [[ -f "${DISABLED_CUSTOM_NODELIST}" ]]; then
				echo "Disableing custom nodes from ${DISABLED_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n "${node_name}" ]] && [[ "${node_name}" != \#* ]]; then
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

		if [[ "${INSTALL_DEFAULT_NODES}" == "true" ]]; then
			echo "Removing some ComfyUI custom nodes..."
			if [[ -f "${REMOVED_CUSTOM_NODELIST}" ]]; then
				echo "Removing custom nodes from ${REMOVED_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n "${node_name}" ]] && [[ "${node_name}" != \#* ]]; then
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

	if [[ "${UPDATE}" == "true" ]]; then
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
		source .venv/bin/activate
	else
		export UV_LINK_MODE=copy
		uv venv --clear --seed
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

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
		source .venv/bin/activate
	else
		export UV_LINK_MODE=copy
		uv venv --clear --seed
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install comfy-cli
		yes | uv run comfy-cli install --nvidia --restore || true

		echo "ComfyUI virtual environment created and dependencies installed."
	fi

	if [[ "${BACKGROUND}" == "true" ]]; then
		echo "Starting ComfyUI in background mode..."
		uv run comfy-cli launch --background -- --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	else
		echo "Starting ComfyUI in foreground mode..."
		uv run comfy-cli launch --no-background -- --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	fi

}

LOCAL_SETUP  # >/dev/null 2>&1 &
DOCKER_SETUP # >/dev/null 2>&1 &

INSTALL_DEFAULT_NODES=true
INSTALL_EXTRA_NODES=true
UPDATE=true

CREATE_FOLDERS
LINK_FOLDERS
exit 1
CLONE_WORKFLOWS

INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &

"${STACK_BASEPATH}"/SCRIPTS/done_sound.sh
xdg-open "http://0.0.0.0:8188/"

RUN_COMFYUI
