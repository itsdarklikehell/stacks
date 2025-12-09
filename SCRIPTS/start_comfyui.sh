#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export COMFYUI_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/comfyui"

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

ln -sf "${COMFYUI_MODEL_PATH}" "${COMFYUI_PATH}/custom_nodes/models"

function TRY_REPAIR_COMFYUI() {
	if [[ "${REPAIR}" == "true" ]]; then
		for dir in "${COMFYUI_PATH}"/custom_nodes/*; do
			if [[ -d "${dir}" ]]; then
				if [[ -f "${dir}/install.py" ]]; then
					echo ""
					echo "Reinstalling dependencies for custom node: ${dir} using install.py"
					uv run python "${dir}/install.py"
					echo ""
				elif [[ -f "${dir}/requirements.txt" ]]; then
					echo ""
					echo "Reinstalling requirements for custom node: ${dir} using requirements.txt"
					uv pip install -r "${dir}/requirements.txt"
					echo ""
				# elif [[ -f "${dir}/pyproject.toml" ]]; then
				# 	echo ""
				# 	echo "Reinstalling package for custom node: ${dir} using pyproject.toml"
				# 	uv pip install -e "${dir}"
				# 	echo ""
				else
					echo "No install.py, requirements.txt, setup.py, or pyproject.toml found in ${dir}. Skipping."
				fi
			fi
		done
	else
		echo "Skipping repair of ComfyUI custom nodes."
	fi
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
		uv run comfy-cli install --nvidia --restore

		echo "ComfyUI virtual environment created and dependencies installed."
	fi

	echo ""
	TRY_REPAIR_COMFYUI
	echo ""

	uv run comfy-cli update all
	if [[ ${BACKGROUND} == "true" ]]; then
		echo "Starting ComfyUI in background mode..."
		uv run comfy-cli launch --background -- --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	else
		echo "Starting ComfyUI in foreground mode..."
		uv run comfy-cli launch --no-background -- --listen "0.0.0.0" --port "${COMFYUI_PORT}"
	fi
}

RUN_COMFYUI
