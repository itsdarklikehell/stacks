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
		for dir in "${COMFY_PATH}"/custom_nodes/*; do
			if [[ -d "${dir}" ]]; then
				if [[ -f "${dir}/install.py" ]]; then
					echo ""
					echo "Reinstalling dependencies for custom node: ${dir} using install.py"
					uv run python "${dir}/install.py" --force
					echo ""
				elif [[ -f "${dir}/requirements.txt" ]]; then
					echo ""
					echo "Reinstalling requirements for custom node: ${dir} using requirements.txt"
					uv pip install -r "${dir}/requirements.txt"
					echo ""
				else
					echo "No install.py or requirements.txt found in ${dir}, skipping."
				fi
			fi
		done
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

		echo "ComfyUI virtual environment created and dependencies installed."
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
