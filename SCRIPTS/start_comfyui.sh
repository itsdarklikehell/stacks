#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export REPAIR=true

export COMFY_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/comfyui"

export COMFYUI_MODEL_PATH="${COMFY_PATH}/models"

ln -sf "${COMFYUI_MODEL_PATH}" "${COMFY_PATH}/custom_nodes/models"

function REPAIR_COMFYUI() {
	if [[ ${REPAIR} == "true" ]]; then
		echo "Repairing ComfyUI installation..."
		echo ""

		for dir in "${COMFY_PATH}/custom_nodes"/*; do
			echo "Checking custom node: ${dir}"
			if [[ -f "${dir}/install.py" ]]; then
				echo "Reinstalling dependencies for custom node: ${dir}"
				uv run python "${dir}/install.py" --force
				echo ""
			elif [[ -f "${dir}/requirements.txt" ]]; then
				echo "Reinstalling requirements for custom node: ${dir}"
				uv pip install -r "${dir}/requirements.txt"
				echo ""
			fi
		done

		# echo "Installing additional requirements..."
		# find "${COMFY_PATH}" -type f -name "install.py" -exec uv run python "{}" \;
		# find "${COMFY_PATH}" -type f -name "requirements.txt" -exec uv pip install -r "{}" \;
		# echo ""
		uv run comfy-cli update all
	fi
}

RUN_COMFYUI() {

	cd "${COMFY_PATH}" || exit 1

	if [[ -f .venv/bin/activate ]]; then
		source .venv/bin/activate
	else
		export UV_LINK_MODE=copy
		uv venv --clear --seed
		source .venv/bin/activate

		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install comfy-cli
		uv run comfy-cli install --nvidia --restore
	fi

	echo ""
	REPAIR_COMFYUI
	echo ""

	if [[ ${BACKGROUND} == "true" ]]; then
		echo "Starting ComfyUI in background mode..."
		uv run comfy-cli launch --background -- --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	else
		echo "Starting ComfyUI in foreground mode..."
		uv run comfy-cli launch --no-background -- --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	fi
}

RUN_COMFYUI
