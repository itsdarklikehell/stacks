#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/comfyui_essential_custom_nodes.txt"
export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/comfyui_extra_custom_nodes.txt"

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/comfyui"
export COMFYUI_MODEL_PATH="${COMFYUI_PATH}/models"

if [[ "$1" == "-r" ]] || [[ "$1" == "--repair" ]] || [[ "$1" == "--reinstall" ]]; then
	echo "Repair mode enabled."
	export REPAIR=true
elif [[ "$1" == "-fr" ]] || [[ "$1" == "--full-repair" ]] || [[ "$1" == "--factory-reset" ]] || [[ "$1" == "--full-reinstal" ]]; then
	echo "Full repair mode enabled."
	export REPAIR=true
	rm -rf "${COMFYUI_PATH}/.venv"
elif [[ -z "$1" ]] || [[ "$1" == "-nr" ]] || [[ "$1" == "--no-repair" ]]; then
	echo "Skipping repair mode."
	export REPAIR=false
fi

echo "Cloning comfyui"
echo ""
git clone --recursive https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_PATH}"
cd "${COMFYUI_PATH}" || exit 1

ln -sf "${COMFYUI_MODEL_PATH}" "${COMFYUI_PATH}/custom_nodes/"

function TRY_REPAIR_COMFYUI() {
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

	uv run comfy-cli update all
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
	# cp -f "${WD}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
	# cp -f "${WD}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
	# cp -f "${WD}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
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

LOCAL_SETUP        # >/dev/null 2>&1 &
DOCKER_SETUP       # >/dev/null 2>&1 &
TRY_REPAIR_COMFYUI # >/dev/null 2>&1 &
RUN_COMFYUI
