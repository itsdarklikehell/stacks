#!/bin/bash
# set -e

echo "Clone repos script started."
SCRIPT_DIR="$(dirname "$(realpath "$0")")" || true
export SCRIPT_DIR

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"

export UV_LINK_MODE=copy

echo "Building is set to: ${BUILDING}"
echo "Working directory is set to ${SCRIPT_DIR}"
echo "Configs directory is set to ${CONFIGS_DIR}"
echo "Data directory is set to ${PERM_DATA}"
echo "Secrets directory is set to ${SECRETS_DIR}"

cd "${SCRIPT_DIR}" || exit 1

if ! command -v uv >/dev/null 2>&1; then
	"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
fi
if ! command -v uv >/dev/null 2>&1; then
	"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"
fi
if ! command -v pnpm >/dev/null 2>&1; then
	"${STACK_BASEPATH}/SCRIPTS/install_pnpm.sh"
fi

function IMPORT_NLTK() {

	echo "Importing NLTK averaged_perceptron_tagger_eng"
	temp_file=$(mktemp /tmp/import_nltk.py)

	cat >"${temp_file}" <<'EOF'
import nltk
nltk.download('averaged_perceptron_tagger_eng')
EOF

	python "${temp_file}"
	rm "${temp_file}"

}

if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
	mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
fi

# cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

function LINK_FOLDERS() {

	"${STACK_BASEPATH}"/SCRIPTS/folder_linker.sh

}

function CLONE_ANYTHINGLLM() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	if [[ ! -d "anything-llm" ]]; then
		echo "Cloning anything-llm"
		echo ""
		git clone --recursive https://github.com/Mintplex-Labs/anything-llm.git anything-llm
		cd anything-llm || exit 1
	else
		echo "Checking anything-llm for updates"
		cd anything-llm || exit 1
		git pull
	fi

	mkdir -p anything-llm_storage anything-llm_skills

}

function CLONE_SCANOPY() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/essential-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/essential-stack" || exit 1

	if [[ ! -d "scanopy" ]]; then
		echo "Cloning scanopy"
		echo ""
		git clone --recursive https://github.com/scanopy/scanopy.git scanopy
		cd scanopy || exit 1
	else
		echo "Checking scanopy for updates"
		cd scanopy || exit 1
		git pull
	fi

}

function CLONE_CLAIR() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/essential-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/essential-stack" || exit 1

	if [[ ! -d "clair" ]]; then
		echo "Cloning clair"
		echo ""
		git clone --recursive https://github.com/quay/clair.git clair
		cd clair || exit 1
	else
		echo "Checking clair for updates"
		cd clair || exit 1
		git pull
	fi

}

function CLONE_PUPPETEER() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	if [[ ! -d "puppeteer" ]]; then
		echo "Cloning puppeteer"
		echo ""
		git clone --recursive https://github.com/puppeteer/puppeteer.git puppeteer
		cd puppeteer || exit 1
	else
		echo "Checking puppeteer for updates"
		cd puppeteer || exit 1
		git pull
	fi

	function LOCAL_SETUP() {

		echo "Using Local setup"
		ni # >/dev/null 2>&1 &

		ni puppeteer # Downloads compatible Chrome during installation.
		yes | pnpm add puppeteer || true

		ni puppeteer-core # Alternatively, install as a library, without downloading Chrome.
		yes | pnpm add puppeteer-core || true

		npx puppeteer install chrome

		yes | npx npm-check-updates -u || true # >/dev/null 2>&1 &
		bash docker/pack.sh

		# npm init --yes
		# npm install puppeteer puppeteer-core @puppeteer/browsers

	}

	LOCAL_SETUP # >/dev/null 2>&1 &

}

function CLONE_OLLMVT() {
	SERVICE_NAME="openllm-vtuber"

	if [[ ! -d "${STACK_BASEPATH}/DATA/openllm-vtuber-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/openllm-vtuber-stack" || exit 1

	if [[ ! -d "openllm-vtuber" ]]; then
		echo "Cloning openllm-vtuber"
		echo ""
		git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git openllm-vtuber
		cd openllm-vtuber || exit
	else
		echo "Checking openllm-vtuber for updates"
		cd openllm-vtuber || exit 1
		git pull
	fi

	function LOCAL_SETUP() {

		export INSTALL_WHISPER=true
		export INSTALL_BARK=true
		export UV_LINK_MODE=copy

		uv venv --clear --seed
		# shellcheck source=/dev/null
		source .venv/bin/activate
		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install -r requirements.txt
		# uv pip install -r requirements-bilibili.txt

		# uv pip install py3-tts sherpa-onnx fish-audio-sdk unidic-lite mecab-python3

		# uv add git+https://github.com/myshell-ai/MeloTTS.git
		# uv pip install git+https://github.com/myshell-ai/MeloTTS.git

		# uv add git+https://github.com/suno-ai/bark.git
		# uv pip install git+https://github.com/suno-ai/bark.git

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"

		# docker build -t open-llm-vtuber .
		# --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true

	}

	# LOCAL_SETUP  # >/dev/null 2>&1 &
	# DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_SWARMUI() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	if [[ ! -d "swarmui" ]]; then
		echo "Cloning swarmui"
		echo ""
		git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git swarmui
		cd swarmui || exit 1
	else
		echo "Checking swarmui for updates"
		cd swarmui || exit 1
		git pull
	fi

	function LOCAL_SETUP() {
		# ./install.sh
		uv venv --clear --seed
		# shellcheck source=/dev/null
		source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
		chmod +x launch-linux.sh

	}

	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-swarmui-uv" CustomDockerfile-swarmui-uv
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-swarmui-conda" CustomDockerfile-swarmui-conda
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-swarmui-venv" CustomDockerfile-swarmui-venv

		cp -rf "${SCRIPT_DIR}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
		cp -rf "${SCRIPT_DIR}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh
		# docker build -t swarmui .
		./launchtools/custom-launch-docker.sh

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

}

function CREATE_FOLDERS() {

	mkdir -p "${STACK_BASEPATH}/DATA/ai-backends"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/anything-llm_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/InvokeAI_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/localai_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/swarmui_input"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/anything-llm_output"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
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

function CLONE_COMFYUI() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	export UV_LINK_MODE=copy
	export BACKGROUND=true
	export COMFYUI_PORT=8188

	if [[ ! -d ${COMFYUI_PATH} ]]; then
		echo "Cloning ComfyUI"
		echo ""
		git clone --recursive https://github.com/comfyanonymous/ComfyUI.git ComfyUI
		cd ComfyUI || exit 1
	else
		echo "Checking ComfyUI for updates"
		cd "${COMFYUI_PATH}" || exit 1
		git pull
	fi

	"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
	"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"

	function CLONE_WORKFLOWS() {

		export WORKFLOWDIR="${STACK_BASEPATH}/DATA/ai-workflows"
		# export WORKFLOWDIR="${COMFYUI_PATH}/user/default/workflows"

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

		export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/default_custom_nodes.txt"
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

			uv pip install comfy-cli

			if [[ ${USER} == "hans" ]]; then
				yes | uv run comfy-cli --workspace "${COMFYUI_PATH}" --skip-prompt install --nvidia --restore || true
			elif [[ ${USER} == "rizzo" ]]; then
				yes | uv run comfy-cli --workspace "${COMFYUI_PATH}" --skip-prompt install --nvidia --restore || true
			else
				yes | uv run comfy-cli --workspace "${COMFYUI_PATH}" --skip-prompt install --nvidia --restore || true
			fi

			uv run comfy-cli --install-completion

		fi

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"
		# cp -rf "${STACK_BASEPATH}/SCRIPTS/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -rf "${STACK_BASEPATH}/SCRIPTS/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -rf "${STACK_BASEPATH}/SCRIPTS/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

	INSTALL_DEFAULT_NODES=true
	INSTALL_EXTRA_NODES=false
	UPDATE=false

	CREATE_FOLDERS
	LINK_FOLDERS

	INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &
	CLONE_WORKFLOWS      # >/dev/null 2>&1 &

	# "${STACK_BASEPATH}"/SCRIPTS/done_sound.sh
	# xdg-open "http://${IP_ADDRESS}:8188/"

}

function CLONE_COMFYUI_MCP() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	if [[ ! -d "comfyui-mcp-server" ]]; then
		echo "Cloning comfyui-mcp-server"
		echo ""
		git clone --recursive https://github.com/joenorton/comfyui-mcp-server.git "comfyui-mcp-server"
		cd "comfyui-mcp-server" || exit 1
	else
		echo "Checking comfyui-mcp-server for updates"
		cd "comfyui-mcp-server" || exit 1
		git pull
	fi

	function LOCAL_SETUP() {

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

			uv pip install requests websockets mcp

		fi

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_COMFYUIMINI() {

	if [[ ! -d "${STACK_BASEPATH}/DATA/ai-stack" ]]; then
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
	fi

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	if [[ ! -d "ComfyUIMini" ]]; then
		echo "Cloning ComfyUIMini"
		echo ""
		git clone --recursive https://github.com/ImDarkTom/ComfyUIMini.git "ComfyUIMini"
		cd "ComfyUIMini" || exit 1
	else
		echo "Checking ComfyUIMini for updates"
		cd "ComfyUIMini" || exit 1
		git pull
	fi

	rsync -aHAX "workflows"/* "${STACK_BASEPATH}/DATA/ai-workflows"
	rm -rf "workflows"
	ln -sf "${STACK_BASEPATH}/DATA/ai-workflows" "workflows"

	function LOCAL_SETUP() {

		echo "Using Local setup"

		cp -rf "config/default.example.json" "config/default.json"

		chmod +x scripts/install.sh
		yes | ./scripts/install.sh || true

		# npm install
		# npm run build
		chmod +x scripts/start.sh
		./scripts/start.sh >/dev/null 2>&1 &
		# npm start

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

	# cd custom_nodes || exit 1
	# git clone --recursive https://github.com/ltdrdata/ComfyUI-Manager.git ComfyUI-Manager
	# cd ComfyUI-Manager || exit 1

	# LOCAL_SETUP  # >/dev/null 2>&1 &
	# DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_COPYPARTY() {

	cd "${STACK_BASEPATH}/DATA/media-stack" || exit 1

	if [[ ! -d "copyparty" ]]; then
		echo "Cloning copyparty"
		echo ""
		git clone --recursive https://github.com/9001/copyparty.git "copyparty"
		cd "copyparty" || exit 1

		mkdir -p "copyparty_configs"

		if [[ ! -f copyparty_configs/config.conf ]]; then
			cp -rf "docs/examples/docker/basic-docker-compose/copyparty.conf" "${FOLDER}/copyparty_configs/config.conf"
		fi

		if [[ -f copyparty_configs/config.conf ]]; then
			cp -rf "copyparty_configs/config.conf" "copyparty_configs/config.conf".bak
		fi

		if [[ -f copyparty_configs/config.conf.bak ]]; then
			cp -rf "copyparty_configs/config.conf.bak" "copyparty_configs/config.conf"
		fi

		cd "copyparty" || exit 1
	else
		echo "Checking copyparty for updates"
		cd "copyparty" || exit 1

		if [[ ! -f copyparty_configs/config.conf ]]; then
			cp -rf "${FOLDER}/docs/examples/docker/basic-docker-compose/copyparty.conf" "${FOLDER}/copyparty_configs/config.conf"
		fi

		if [[ -f copyparty_configs/config.conf ]]; then
			cp -rf "copyparty_configs/config.conf" "copyparty_configs/config.conf".bak
		fi

		git pull

		if [[ -f copyparty_configs/config.conf.bak ]]; then
			cp -rf "copyparty_configs/config.conf.bak" "copyparty_configs/config.conf"
		fi
	fi

	function LOCAL_SETUP() {

		echo "Using Local setup"

		# if [[ -f .venv/bin/activate ]]; then
		# 	# shellcheck source=/dev/null
		# 	source .venv/bin/activate
		# else

		# 	export UV_LINK_MODE=copy
		# 	uv venv --clear --seed
		# 	# shellcheck source=/dev/null
		# 	source .venv/bin/activate

		# 	uv pip install --upgrade pip
		# 	uv sync --all-extras
		#   export PRTY_CONFIG=config.conf
		# 	uv pip install .
		# 	uv pip install --user -U copyparty

		# fi

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

	# LOCAL_SETUP  # >/dev/null 2>&1 &
	# DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_SYNCTUBE() {

	cd "${STACK_BASEPATH}/DATA/testing-stack" || exit 1

	if [[ ! -d "synctube" ]]; then
		echo "Cloning synctube"
		echo ""
		git clone --recursive https://github.com/RblSb/SyncTube.git "synctube"
		cd "synctube" || exit 1
	else
		echo "Checking synctube for updates"
		cd "synctube" || exit 1
		git pull
	fi

	if [[ ! -d "octosubs" ]]; then
		echo "Cloning octosubs"
		echo ""
		git clone --recursive https://github.com/RblSb/SyncTube-octosubs.git "octosubs"
		# cd "synctube" || exit 1
	else
		echo "Checking octosubs for updates"
		# cd "synctube" || exit 1
		git pull
	fi

	if [[ ! -d "qswitcher" ]]; then
		echo "Cloning qswitcher"
		echo ""
		git clone --recursive https://github.com/aNNiMON/SyncTube-QSwitcher.git "qswitcher"
		# cd "synctube" || exit 1
	else
		echo "Checking qswitcher for updates"
		# cd "synctube" || exit 1
		git pull
	fi

	function LOCAL_SETUP() {

		echo "Using Local setup"

		# if [[ -f .venv/bin/activate ]]; then
		# 	# shellcheck source=/dev/null
		# 	source .venv/bin/activate
		# else

		# 	export UV_LINK_MODE=copy
		# 	uv venv --clear --seed
		# 	# shellcheck source=/dev/null
		# 	source .venv/bin/activate

		# 	uv pip install --upgrade pip
		# 	uv sync --all-extras
		#   export PRTY_CONFIG=config.conf
		# 	uv pip install .
		# 	uv pip install --user -U synctube

		# fi

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -rf "${SCRIPT_DIR}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

	# LOCAL_SETUP  # >/dev/null 2>&1 &
	# DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_PYGOTCHI() {

	cd "${STACK_BASEPATH}/DATA/testing-stack" || exit 1

	if [[ ! -d "pygotchi" ]]; then
		echo "Cloning pygotchi"
		echo ""
		git clone --recursive https://github.com/almarch/pygotchi.git "pygotchi"
		cd "pygotchi" || exit 1
	else
		echo "Checking pygotchi for updates"
		cd "pygotchi" || exit 1
		git pull
	fi

	# function LOCAL_SETUP() {

	# 	echo "Using Local setup"

	# }

	# function DOCKER_SETUP() {

	# 	echo "Using Docker setup"

	# }

	# LOCAL_SETUP  # >/dev/null 2>&1 &
	# DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_KASMWORKSPACES() {

	cd "${STACK_BASEPATH}/DATA/testing-stack" || exit 1

	cd /tmp || exit
	curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.17.0.7f020d.tar.gz
	tar -xf kasm_release_1.17.0.7f020d.tar.gz
	yes | sudo bash kasm_release/install.sh -L 8443 || true

}

function CLONE_STRUDEL() {

	cd "${STACK_BASEPATH}/DATA/testing-stack" || exit 1
	if [[ ! -d strudel-cli ]]; then
		echo "Cloning strudel-cli"
		echo ""
		git clone --recursive https://codeberg.org/uzu/strudel.git strudel
		cd strudel || exit 1
		pnpm i
		# pnpm dev
		npm install -g strudel-cli
	else
		echo "Checking strudel for updates"
		cd strudel || exit 1
		git pull
	fi

}

function CLONE_SDR_TCP() {

	mkdir -p "${STACK_BASEPATH}/DATA/sdr-stack"
	cd "${STACK_BASEPATH}/DATA/sdr-stack" || exit 1

	if [[ ! -d rtl-tcp ]]; then
		echo "Cloning rtl-tcp"
		echo ""
		git clone --recursive https://github.com/LizenzFass78851/docker-rtl-tcp.git rtl-tcp
		cd rtl-tcp || exit 1
		echo -e 'blacklist dvb_usb_rtl28xxu\nblacklist rtl2832\nblacklist rtl2830' | sudo tee /lib/modprobe.d/blacklist-rtl.conf
	else
		echo "Checking rtl-tcp for updates"
		cd rtl-tcp || exit 1
		git pull
	fi

}

function CLONE_BIRDNETPI_TCP() {

	cd "${STACK_BASEPATH}/DATA/sdr-stack" || exit 1
	if [[ ! -d birdnet-pi ]]; then
		echo "Cloning birdnet-pi"
		echo ""
		git clone --recursive https://github.com/Nachtzuster/BirdNET-Pi.git birdnet-pi
		cd birdnet-pi || exit 1
	else
		echo "Checking birdnet-pi for updates"
		cd birdnet-pi || exit 1
		git pull
	fi

}

CREATE_FOLDERS

CLONE_ANYTHINGLLM    # >/dev/null 2>&1 &
CLONE_CLAIR          # >/dev/null 2>&1 &
CLONE_COMFYUI        # >/dev/null 2>&1 &
CLONE_SYNCTUBE       # >/dev/null 2>&1 &
CLONE_COMFYUI_MCP    # >/dev/null 2>&1 &
CLONE_COMFYUIMINI    # >/dev/null 2>&1 &
CLONE_COPYPARTY      # >/dev/null 2>&1 &
CLONE_OLLMVT         # >/dev/null 2>&1 &
CLONE_PUPPETEER      # >/dev/null 2>&1 &
CLONE_SCANOPY        # >/dev/null 2>&1 &
CLONE_SWARMUI        # >/dev/null 2>&1 &
CLONE_PYGOTCHI       # >/dev/null 2>&1 &
CLONE_STRUDEL        # >/dev/null 2>&1 &
CLONE_SDR_TCP        # >/dev/null 2>&1 &
CLONE_BIRDNETPI_TCP  # >/dev/null 2>&1 &
CLONE_KASMWORKSPACES # >/dev/null 2>&1 &
LINK_FOLDERS
