#!/bin/bash
echo "Start ComfyUI script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/extra_custom_nodes.txt"

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"

mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs"
mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"

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

echo "Cloning ComfyUI"
echo ""
git clone --recursive https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_PATH}"
cd "${COMFYUI_PATH}" || exit 1

function SETUP_FOLDERS() {
	function MODELS() {
		if test -L "${COMFYUI_PATH}/models"; then
			echo "${COMFYUI_PATH}/models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models"
		elif test -d "${COMFYUI_PATH}/models"; then
			echo "${COMFYUI_PATH}/models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${COMFYUI_PATH}/models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/models"
		fi
		if test -L "${COMFYUI_PATH}/custom_nodes/models"; then
			echo "${COMFYUI_PATH}/custom_nodes/models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/custom_nodes/models"
		elif test -d "${COMFYUI_PATH}/custom_nodes/models"; then
			echo "${COMFYUI_PATH}/custom_nodes/models is just a plain directory"
			mv -f "${COMFYUI_PATH}/custom_nodes/models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${COMFYUI_PATH}/custom_nodes/models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/custom_nodes/models"
		fi
	}
	function OUTPUTS() {
		if test -L "${COMFYUI_PATH}/output"; then
			echo "${COMFYUI_PATH}/output is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/output"
		elif test -d "${COMFYUI_PATH}/output"; then
			echo "${COMFYUI_PATH}/output is just a plain directory"
			mv -f "${COMFYUI_PATH}/output"/* "${STACK_BASEPATH}/DATA/ai-outputs"
			rm -rf "${COMFYUI_PATH}/output"
			ln -s "${STACK_BASEPATH}/DATA/ai-outputs" "${COMFYUI_PATH}/output"
		fi
	}
	function INPUTS() {
		if test -L "${COMFYUI_PATH}/input"; then
			echo "${COMFYUI_PATH}/input is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/input"
		elif test -d "${COMFYUI_PATH}/input"; then
			echo "${COMFYUI_PATH}/input is just a plain directory"
			mv -f "${COMFYUI_PATH}/input"/* "${STACK_BASEPATH}/DATA/ai-inputs"
			rm -rf "${COMFYUI_PATH}/input"
			ln -s "${STACK_BASEPATH}/DATA/ai-inputs" "${COMFYUI_PATH}/input"
		fi
	}
	function WORKFLOWS() {
		mkdir -p "${COMFYUI_PATH}/user/default/workflows"
		if test -L "${COMFYUI_PATH}/user/default/workflows"; then
			echo "${COMFYUI_PATH}/user/default/workflows is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/user/default/workflows"
		elif test -d "${COMFYUI_PATH}/user/default/workflows"; then
			echo "${COMFYUI_PATH}/user/default/workflows is just a plain directory"
			mv -f "${COMFYUI_PATH}/user/default/workflows"/* "${STACK_BASEPATH}/DATA/ai-workflows"
			rm -rf "${COMFYUI_PATH}/user/default/workflows"
			ln -s "${STACK_BASEPATH}/DATA/ai-workflows" "${COMFYUI_PATH}/user/default/workflows"
		fi
		if test -L "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"; then
			echo "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
		elif test -d "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"; then
			echo "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"/* "${STACK_BASEPATH}/DATA/ai-workflows"
			rm -rf "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
			ln -s "${STACK_BASEPATH}/DATA/ai-workflows" "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
		fi
	}
	MODELS
	OUTPUTS
	INPUTS
	WORKFLOWS

	# if test -d "/home/${USER}/.config/variety/Downloaded"; then
	# 	if test -L "/home/${USER}/.config/variety/Downloaded"; then
	# 		echo "/home/${USER}/.config/variety/Downloaded is a symlink to a directory"
	# 		# ls -la "/home/${USER}/.config/variety/Downloaded"
	# 	else
	# 		# echo "/home/${USER}/.config/variety/Downloaded is just a plain directory"
	# 		mv -f "/home/${USER}/.config/variety/Downloaded/*" "${COMFYUI_PATH}/input/Downloaded"
	# 		rm -rf "/home/${USER}/.config/variety/Downloaded"
	# 		ln -s "${COMFYUI_PATH}/input/Downloaded" "/home/${USER}/.config/variety/Downloaded"

	# 	fi
	# # else
	# # 	echo "/home/${USER}/.config/variety/Downloaded is not a directory (nor a link to one)"
	# fi

	# if test -d "/home/${USER}/.config/variety/Favorites"; then
	# 	if test -L "/home/${USER}/.config/variety/Favorites"; then
	# 		echo "/home/${USER}/.config/variety/Favorites is a symlink to a directory"
	# 		# ls -la "/home/${USER}/.config/variety/Favorites"
	# 	else
	# 		# echo "/home/${USER}/.config/variety/Favorites is just a plain directory"
	# 		mv -f "/home/${USER}/.config/variety/Favorites/*" "${COMFYUI_PATH}/input/Favorites"
	# 		rm -rf "/home/${USER}/.config/variety/Favorites"
	# 		ln -s "${COMFYUI_PATH}/input/Favorites" "/home/${USER}/.config/variety/Favorites"
	# 	fi
	# # else
	# # 	echo "/home/${USER}/.config/variety/Favorites is not a directory (nor a link to one)"
	# fi

	# if test -d "/home/${USER}/.config/variety/Fetched"; then
	# 	if test -L "/home/${USER}/.config/variety/Fetched"; then
	# 		echo "/home/${USER}/.config/variety/Fetched is a symlink to a directory"
	# 		# ls -la "/home/${USER}/.config/variety/Fetched"
	# 	else
	# 		# echo "/home/${USER}/.config/variety/Fetched is just a plain directory"
	# 		mv -f "/home/${USER}/.config/variety/Fetched/*" "${COMFYUI_PATH}/input/Fetched"
	# 		rm -rf "/home/${USER}/.config/variety/Fetched"
	# 		ln -s "${COMFYUI_PATH}/input/Fetched" "/home/${USER}/.config/variety/Fetched"
	# 	fi
	# # else
	# # 	echo "/home/${USER}/.config/variety/Fetched is not a directory (nor a link to one)"
	# fi
}

function CLONE_WORKFLOWS() {
	export WORKFLOWDIR="${COMFYUI_PATH}/user/default/workflows"
	cd "${WORKFLOWDIR}" || exit 1

	git clone --recursive https://github.com/comfyanonymous/ComfyUI_examples.git "${WORKFLOWDIR}/comfyanonymous/ComfyUI_examples"

	git clone --recursive https://github.com/cubiq/ComfyUI_Workflows.git "${WORKFLOWDIR}/cubiq/ComfyUI_Workflows"

	git clone --recursive https://github.com/aimpowerment/comfyui-workflows.git "${WORKFLOWDIR}/aimpowerment/comfyui-workflows"

	git clone --recursive https://github.com/wyrde/wyrde-comfyui-workflows.git "${WORKFLOWDIR}/wyrde/wyrde-comfyui-workflows"

}

function INSTALL_CUSTOM_NODES() {
	ESSENTIAL() {
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
	EXTRAS() {
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

	ESSENTIAL
	EXTRAS
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

	if [[ ${BACKGROUND} == "true" ]]; then
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

INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &

SETUP_FOLDERS
CLONE_WORKFLOWS

"${STACK_BASEPATH}"/SCRIPTS/done_sound.sh

xdg-open "http://0.0.0.0:8188/"

RUN_COMFYUI
