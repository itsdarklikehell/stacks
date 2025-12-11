#!/bin/bash
echo "Start ComfyUI script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/extra_custom_nodes.txt"

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"

mkdir -p "${STACK_BASEPATH}/DATA/ai-models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs"

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

SETUP_FOLDERS() {
	mv "${COMFYUI_PATH}/models" "${STACK_BASEPATH}/DATA/ai-models"
	mv "${COMFYUI_PATH}/output" "${STACK_BASEPATH}/DATA/ai-outputs"
	mv "${COMFYUI_PATH}/input" "${STACK_BASEPATH}/DATA/ai-inputs"

	rm -rf "${COMFYUI_PATH}/models"
	rm -rf "${COMFYUI_PATH}/output"
	rm -rf "${COMFYUI_PATH}/input"

	ln -sf "${STACK_BASEPATH}/DATA/ai-models" "${COMFYUI_PATH}/models"
	ln -sf "${STACK_BASEPATH}/DATA/ai-outputs" "${COMFYUI_PATH}/output"
	ln -sf "${STACK_BASEPATH}/DATA/ai-inputs" "${COMFYUI_PATH}/input"

	ln -sf "${COMFYUI_PATH}/models" "${COMFYUI_PATH}/custom_nodes/models"
}

SETUP_FOLDERS

function INSTALL_CUSTOM_NODES() {
	ESSENTIAL() {
		if [[ -f "${ESSENTIAL_CUSTOM_NODELIST}" ]]; then
			echo "Reinstalling custom nodes from ${ESSENTIAL_CUSTOM_NODELIST}"
			while IFS= read -r node_name; do
				if [[ -n "${node_name}" ]]; then
					uv run comfy-cli node install "${node_name}"
				fi
			done <"${ESSENTIAL_CUSTOM_NODELIST}"
			echo ""
		else
			echo "No ${ESSENTIAL_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
		fi
	}
	EXTRAS() {
		if [[ -f "${EXTRA_CUSTOM_NODELIST}" ]]; then
			echo "Reinstalling custom nodes from ${EXTRA_CUSTOM_NODELIST}"
			while IFS= read -r node_name; do
				if [[ -n "${node_name}" ]]; then
					uv run comfy-cli node install "${node_name}"
				fi
			done <"${EXTRA_CUSTOM_NODELIST}"
			echo ""
		else
			echo "No ${EXTRA_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
		fi
	}
	if [[ "${INSTALL_DEFAULT_NODES}" == "true" ]]; then
		echo "Installing ComfyUI custom nodes..."
		ESSENTIAL
	else
		echo "Skipping ComfyUI custom node install."
	fi
	if [[ "${INSTALL_EXTRA_NODES}" == "true" ]]; then
		echo "Installing ComfyUI extra nodes..."
		EXTRAS
	else
		echo "Skipping ComfyUI extra node install."
	fi
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
RUN_COMFYUI
