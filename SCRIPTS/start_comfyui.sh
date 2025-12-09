#!/bin/bash
echo "Start comfyui script started."

export UV_LINK_MODE=copy
export BACKGROUND=false
export COMFYUI_PORT=8188

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
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

ln -sf "${COMFYUI_MODEL_PATH}" "${COMFYUI_PATH}/custom_nodes/"

function TRY_REPAIR_COMFYUI() {
	if [[ "${REPAIR}" == "true" ]]; then

		if [[ -f "${COMFYUI_PATH}/custom_nodes.list" ]]; then
			echo "Reinstalling custom nodes from custom_nodes.list"
			while IFS= read -r node_name; do
				if [[ -n "${node_name}" ]]; then
					uv run comfy-cli node install "${node_name}" # --force
				fi
			done <"${STACK_BASEPATH}/SCRIPTS/comfyui_custom_nodes.txt"
			echo ""
		else
			echo "No custom_nodes.list file found."
		fi

		# for dir in "${COMFYUI_PATH}"/custom_nodes/*; do
		# 	if [[ -d "${dir}" && ! -L "${dir}" ]]; then

		# 		node_name=$(basename "${dir}")
		# 		echo ""
		# 		echo "Reinstalling custom node: ${node_name}"
		# 		uv run comfy-cli node install "${node_name}"

		# 		if [[ -f "${dir}/install.py" ]]; then
		# 			echo ""
		# 			echo "Reinstalling dependencies for custom node: ${dir} using install.py"
		# 			uv run python "${dir}/install.py"
		# 			echo ""
		# 		elif [[ -f "${dir}/requirements.txt" ]]; then
		# 			echo ""
		# 			echo "Reinstalling requirements for custom node: ${dir} using requirements.txt"
		# 			uv pip install -r "${dir}/requirements.txt"
		# 			echo ""
		# 		# elif [[ -f "${dir}/pyproject.toml" ]]; then
		# 		# 	echo ""
		# 		# 	echo "Reinstalling package for custom node: ${dir} using pyproject.toml"
		# 		# 	uv pip install -e "${dir}"
		# 		# 	echo ""
		# 		else
		# 			echo "No install.py, requirements.txt, setup.py, or pyproject.toml found in ${dir}. Skipping."
		# 		fi
		# 	fi
		# done
	else
		echo "Skipping repair of ComfyUI custom nodes."
	fi

	uv run comfy-cli update all
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

	echo ""
	TRY_REPAIR_COMFYUI
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
