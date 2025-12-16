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

# if [[ ! -f "extra_model_paths.yaml" ]]; then
# 	cp extra_model_paths.yaml.example extra_model_paths.yaml
# fi

mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"

mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"

mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"

mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"

mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"

mkdir -p "${COMFYUI_PATH}/user/default/workflows"
mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"

function SETUP_FOLDERS() {

	function MODELS() {

		## ComfyUI itself:
		mkdir -p "${COMFYUI_PATH}/models"
		if test -L "${COMFYUI_PATH}/models"; then
			echo "${COMFYUI_PATH}/models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models"
		elif test -d "${COMFYUI_PATH}/models"; then
			echo "${COMFYUI_PATH}/models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${COMFYUI_PATH}/models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/models"
		fi
		mkdir -p "${COMFYUI_PATH}/custom_nodes/models"
		if test -L "${COMFYUI_PATH}/custom_nodes/models"; then
			echo "${COMFYUI_PATH}/custom_nodes/models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/custom_nodes/models"
		elif test -d "${COMFYUI_PATH}/custom_nodes/models"; then
			echo "${COMFYUI_PATH}/custom_nodes/models is just a plain directory"
			mv -f "${COMFYUI_PATH}/custom_nodes/models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${COMFYUI_PATH}/custom_nodes/models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/custom_nodes/models"
		fi

		## Anything-LLM
		mkdir -p "${COMFYUI_PATH}/models/anything-llm_models"
		if test -L "${COMFYUI_PATH}/models/anything-llm_models"; then
			echo "${COMFYUI_PATH}/models/anything-llm_models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models/anything-llm_models"
		elif test -d "${COMFYUI_PATH}/models/anything-llm_models"; then
			echo "${COMFYUI_PATH}/models/anything-llm_models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models/anything-llm_models"/* "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"
			rm -rf "${COMFYUI_PATH}/models/anything-llm_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models" "${COMFYUI_PATH}/models/anything-llm_models"
		fi
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
		if test -L "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
		elif test -d "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/anything-llm_models/comfyui_models"
		fi

		## InvokeAI
		mkdir -p "${COMFYUI_PATH}/models/InvokeAI_models"
		if test -L "${COMFYUI_PATH}/models/InvokeAI_models"; then
			echo "${COMFYUI_PATH}/models/InvokeAI_models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models/InvokeAI_models"
		elif test -d "${COMFYUI_PATH}/models/InvokeAI_models"; then
			echo "${COMFYUI_PATH}/models/InvokeAI_models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models/InvokeAI_models"/* "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"
			rm -rf "${COMFYUI_PATH}/models/InvokeAI_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models" "${COMFYUI_PATH}/models/InvokeAI_models"
		fi
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
		if test -L "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
		elif test -d "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/InvokeAI_models/comfyui_models"
		fi

		## LocalAI
		mkdir -p "${COMFYUI_PATH}/models/localai_models"
		if test -L "${COMFYUI_PATH}/models/localai_models"; then
			echo "${COMFYUI_PATH}/models/localai_models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models/localai_models"
		elif test -d "${COMFYUI_PATH}/models/localai_models"; then
			echo "${COMFYUI_PATH}/models/localai_models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models/localai_models"/* "${STACK_BASEPATH}/DATA/ai-models/localai_models"
			rm -rf "${COMFYUI_PATH}/models/localai_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/localai_models" "${COMFYUI_PATH}/models/localai_models"
		fi
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
		if test -L "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
		elif test -d "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/localai_models/comfyui_models"
		fi

		## Ollama
		mkdir -p "${COMFYUI_PATH}/models/ollama_models"
		if test -L "${COMFYUI_PATH}/models/ollama_models"; then
			echo "${COMFYUI_PATH}/models/ollama_models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models/ollama_models"
		elif test -d "${COMFYUI_PATH}/models/ollama_models"; then
			echo "${COMFYUI_PATH}/models/ollama_models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models/ollama_models"/* "${STACK_BASEPATH}/DATA/ai-models/ollama_models"
			rm -rf "${COMFYUI_PATH}/models/ollama_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/ollama_models" "${COMFYUI_PATH}/models/ollama_models"
		fi
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
		if test -L "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
		elif test -d "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/ollama_models/comfyui_models"
		fi

		## Forge
		mkdir -p "${COMFYUI_PATH}/models/forge_models"
		if test -L "${COMFYUI_PATH}/models/forge_models"; then
			echo "${COMFYUI_PATH}/models/forge_models is a symlink to a directory"
			# ls -la "${COMFYUI_PATH}/models/forge_models"
		elif test -d "${COMFYUI_PATH}/models/forge_models"; then
			echo "${COMFYUI_PATH}/models/forge_models is just a plain directory"
			mv -f "${COMFYUI_PATH}/models/forge_models"/* "${STACK_BASEPATH}/DATA/ai-models/forge_models"
			rm -rf "${COMFYUI_PATH}/models/forge_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/forge_models" "${COMFYUI_PATH}/models/forge_models"
		fi
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
		if test -L "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
		elif test -d "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"; then
			echo "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"/* "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			rm -rf "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
			ln -s "${STACK_BASEPATH}/DATA/ai-models/comfyui_models" "${COMFYUI_PATH}/forge_models/comfyui_models"
		fi

	}

	function OUTPUTS() {
		mkdir -p "${COMFYUI_PATH}/output"
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
		mkdir -p "${COMFYUI_PATH}/input"
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

		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
		if test -L "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"; then
			echo "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
		elif test -d "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"; then
			echo "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"/* "${STACK_BASEPATH}/DATA/ai-workflows"
			rm -rf "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
			ln -s "${STACK_BASEPATH}/DATA/ai-workflows" "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
		fi

		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"
		if test -L "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"; then
			echo "$${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
		elif test -d "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"; then
			echo "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"/* "${STACK_BASEPATH}/DATA/ai-workflows"

			rm -rf "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"
			ln -s "${STACK_BASEPATH}/DATA/ai-workflows" "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"
		fi

	}

	function VARIETY() {

		### INPUTS
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
		if test -L "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"; then
			echo "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
		elif test -d "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"; then
			echo "${STACK_BASEPATH}/DATA/ai-inputs/variety is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-inputs/variety"/* "${COMFYUI_PATH}/input/Downloaded"
			rm -rf "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
			ln -s "/home/${USER}/.config/variety/Downloaded" "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
		fi

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
		if test -L "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"; then
			echo "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
		elif test -d "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"; then
			echo "${STACK_BASEPATH}/DATA/ai-inputs/variety is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-inputs/variety"/* "${COMFYUI_PATH}/input/Fetched"
			rm -rf "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
			ln -s "/home/${USER}/.config/variety/Fetched" "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
		fi

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
		if test -L "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"; then
			echo "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
		elif test -d "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"; then
			echo "${STACK_BASEPATH}/DATA/ai-inputs/variety is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-inputs/variety"/* "${COMFYUI_PATH}/input/Favorites"
			rm -rf "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
			ln -s "/home/${USER}/.config/variety/Favorites" "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
		fi

		### OUTPUTS
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
		if test -L "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"; then
			echo "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
		elif test -d "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"; then
			echo "${STACK_BASEPATH}/DATA/ai-outputs/variety is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-outputs/variety"/* "${COMFYUI_PATH}/input/Downloaded"
			rm -rf "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
			ln -s "/home/${USER}/.config/variety/Downloaded" "${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
		fi

		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
		if test -L "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"; then
			echo "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
		elif test -d "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"; then
			echo "${STACK_BASEPATH}/DATA/ai-outputs/variety is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-outputs/variety"/* "${COMFYUI_PATH}/input/Fetched"
			rm -rf "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
			ln -s "/home/${USER}/.config/variety/Fetched" "${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
		fi

		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
		if test -L "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"; then
			echo "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites is a symlink to a directory"
			# ls -la "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
		elif test -d "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"; then
			echo "${STACK_BASEPATH}/DATA/ai-outputs/variety is just a plain directory"
			mv -f "${STACK_BASEPATH}/DATA/ai-outputs/variety"/* "${COMFYUI_PATH}/input/Favorites"
			rm -rf "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
			ln -s "/home/${USER}/.config/variety/Favorites" "${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
		fi

	}

	# MODELS
	# OUTPUTS
	# INPUTS
	# WORKFLOWS
	# VARIETY
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

	git clone --recursive https://github.com/https://github.com/ecjojo/ecjojo-comfyui-workflows.git "${WORKFLOWDIR}/ecjojo/ecjojo-comfyui-workflows"

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

SETUP_FOLDERS
CLONE_WORKFLOWS

INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &

"${STACK_BASEPATH}"/SCRIPTS/done_sound.sh

xdg-open "http://0.0.0.0:8188/"

RUN_COMFYUI
