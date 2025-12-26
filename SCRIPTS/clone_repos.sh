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

"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"
curl -fsSL https://get.pnpm.io/install.sh | sh - || true

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

function CLONE_ANYTHINGLLM() {

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

function CLONE_MYPMD() {

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	sudo apt install -y mpd

	sudo cp -rf "${STACK_BASEPATH}/SCRIPTS/mympdconf.example" "/etc/mympd.conf"
	sudo chown -R "${USER}":"${USER}" "/etc/mympd.conf"

	mkdir -p "/home/${USER}/.mpd/playlists"
	mkdir -p "/home/${USER}/music"
	touch "/home/${USER}/.mpd/log"
	touch "/home/${USER}/.mpd/database"
	# mkdir -p "/home/${USER}/.mpd/log"
	# mkdir -p "/home/${USER}/.mpd/pid"
	# mkdir -p "/home/${USER}/.mpd/state"
	# mkdir -p "/home/${USER}/.mpd/sticker.sql"

}

function CLONE_SCANOPY() {

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
	cd "${STACK_BASEPATH}/DATA/openllm-vtuber-stack" || exit 1

	if [[ ! -d "Open-LLM-VTuber" ]]; then
		echo "Cloning Open-LLM-VTuber"
		echo ""
		git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber
		cd Open-LLM-VTuber || exit
	else
		echo "Checking Open-LLM-VTuber for updates"
		cd Open-LLM-VTuber || exit 1
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
		uv pip install -r requirements-bilibili.txt

		uv pip install py3-tts sherpa-onnx fish-audio-sdk unidic-lite mecab-python3

		uv add git+https://github.com/myshell-ai/MeloTTS.git
		uv pip install git+https://github.com/myshell-ai/MeloTTS.git

		uv add git+https://github.com/suno-ai/bark.git
		uv pip install git+https://github.com/suno-ai/bark.git

		uv pip install unidic
		python -m unidic download >/dev/null 2>&1 &

		IMPORT_NLTK >/dev/null 2>&1 &

		if [[ ! -f "conf.yaml" ]]; then
			cp config_templates/conf.default.yaml conf.yaml
		else
			echo "conf.yaml already exists, skipping copy."
		fi

		function CLONE_L2D_MODELS() {

			cd "${STACK_BASEPATH}/DATA/openllm-vtuber-stack/Open-LLM-VTuber/live2d-models" || exit 1
			echo "Cloning Live2D Models"
			echo ""
			git clone --recursive https://github.com/ezshine/AwesomeLive2D ezshine-AwesomeLive2D
			git clone --recursive https://github.com/Mnaisuka/Live2d-model Mnaisuka-Live2d-model
			git clone --recursive https://github.com/xiaoski/live2d_models_collection xiaoski-live2d_models_collection
			git clone --recursive https://github.com/n0099/TouhouCannonBall-Live2d-Models n0099-TouhouCannonBall-Live2d-Models
			# git clone --recursive https://github.com/Eikanya/Live2d-model Eikanya-Live2d-model
			# git clone --recursive https://github.com/andatoshiki/toshiki-live2d andatoshiki-toshiki-live2d

		}

		function CLONE_VOICE_MODELS() {

			cd "${STACK_BASEPATH}/DATA/openllm-vtuber-stack/Open-LLM-VTuber/models" || exit 1
			echo "Cloning VITS Models"
			echo ""

			# if [[ ! -d "sherpa-onnx-sense-voice-zh-en-ja-ko-yue-2024-07-17" ]]; then
			#     git clone https://huggingface.co/csukuangfj/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-2024-07-17
			# fi

			if [[ ! -d "vits-melo-tts-zh_en" ]]; then
				wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-melo-tts-zh_en.tar.bz2
				tar xvf vits-melo-tts-zh_en.tar.bz2
				rm vits-melo-tts-zh_en.tar.bz2
			fi

			if [[ ! -d "vits-piper-en_US-glados" ]]; then
				# wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-glados.tar.bz2
				# tar xvf vits-piper-en_US-glados.tar.bz2
				# rm vits-piper-en_US-glados.tar.bz2
				git clone --recursive https://huggingface.co/csukuangfj/vits-piper-en_US-glados
			fi

			if [[ ! -d "vits-piper-en_US-libritts_r-medium" ]]; then
				wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-libritts_r-medium.tar.bz2
				tar xvf vits-piper-en_US-libritts_r-medium.tar.bz2
				rm vits-piper-en_US-libritts_r-medium.tar.bz22
			fi

			if [[ ! -d "vits-ljs" ]]; then
				wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-ljs.tar.bz2
				tar xvf vits-ljs.tar.bz2
				rm vits-ljs.tar.bz2
			fi

			if [[ ! -d "vits-vctk" ]]; then
				wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-vctk.tar.bz2
				tar xvf vits-vctk.tar.bz2
				rm vits-vctk.tar.bz2
			fi

			if [[ ! -d "vits-piper-en_US-lessac-medium" ]]; then
				wget https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/vits-piper-en_US-lessac-medium.tar.bz2
				tar xvf vits-piper-en_US-lessac-medium.tar.bz2
				rm vits-piper-en_US-lessac-medium.tar.bz2
			fi

			if [[ ! -d "vits-piper-en_GB-cori-high " ]]; then
				git clone https://huggingface.co/csukuangfj/vits-piper-en_GB-cori-high
			fi

			if [[ ! -d "vits-piper-nl_NL-miro-high " ]]; then
				git clone https://huggingface.co/csukuangfj/vits-piper-nl_NL-miro-high
			fi

		}

		function CLONE_TTS_BACKENDS() {

			cd "${STACK_BASEPATH}/DATA/openllm-vtuber-stack/Open-LLM-VTuber" || exit 1
			git clone --recursive https://github.com/FunAudioLLM/CosyVoice.git
			# # If you failed to clone the submodule due to network failures, please run the following command until success
			cd CosyVoice || exit 1
			git submodule update --init --recursive
			# # conda create -n cosyvoice -y python=3.10
			# # conda activate cosyvoice
			uv venv --clear --seed
			uv sync
			# uv pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com
			mkdir -p pretrained_models
			# git clone https://www.modelscope.cn/iic/CosyVoice2-0.5B.git pretrained_models/CosyVoice2-0.5B
			# git clone https://www.modelscope.cn/iic/CosyVoice-300M.git pretrained_models/CosyVoice-300M
			# git clone https://www.modelscope.cn/iic/CosyVoice-300M-SFT.git pretrained_models/CosyVoice-300M-SFT
			# git clone https://www.modelscope.cn/iic/CosyVoice-300M-Instruct.git pretrained_models/CosyVoice-300M-Instruct
			git clone https://www.modelscope.cn/iic/CosyVoice-ttsfrd.git pretrained_models/CosyVoice-ttsfrd
			cd pretrained_models/CosyVoice-ttsfrd/ || exit 1
			unzip resource.zip -d .
			uv pip install ttsfrd_dependency-0.1-py3-none-any.whl
			uv pip install ttsfrd-0.4.2-cp310-cp310-linux_x86_64.whl

			# # If you encounter sox compatibility issues
			# # ubuntu
			sudo apt install -y sox libsox-dev

		}

		CLONE_TTS_BACKENDS >/dev/null 2>&1 &
		CLONE_L2D_MODELS >/dev/null 2>&1 &
		# uv run run_server.py >/dev/null 2>&1 &
		CLONE_L2D_MODELS >/dev/null 2>&1 &
		CLONE_VOICE_MODELS >/dev/null 2>&1 &

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"
		cp -rf "${SCRIPT_DIR}/CustomDockerfile-openllm-vtuber-uv" CustomDockerfile-openllm-vtuber-uv
		cp -rf "${SCRIPT_DIR}/CustomDockerfile-openllm-vtuber-conda" CustomDockerfile-openllm-vtuber-conda
		cp -rf "${SCRIPT_DIR}/CustomDockerfile-openllm-vtuber-venv" CustomDockerfile-openllm-vtuber-venv

		# docker build -t open-llm-vtuber .
		# --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true

	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

}

function CLONE_SWARMUI() {

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

function CLONE_COMFYUI() {

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

	function CREATE_FOLDERS() {

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
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
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
		mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"
		mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
		mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-custom_nodes"

	}

	function LINK_FOLDERS() {

		function LINKER() {

			if test -L "${DEST}"; then
				echo "${DEST} is already a symlink."
				echo ""
			elif test -d "${DEST}"; then
				echo "${DEST} is just a plain directory!"

				# echo "Checking if ${SOURCE} exists"
				if [[ ! -d ${SOURCE} ]] && [[ ! -L ${SOURCE} ]]; then
					# echo "Creating ${SOURCE}"
					mkdir -p "${SOURCE}"
				fi

				# echo "Trying to move files!"
				# echo "from ${DEST} to ${SOURCE}"
				rsync -aHAX "${DEST}"/* "${SOURCE}"
				# mv -f "${DEST}"/* "${SOURCE}"
				# cp -au "${DEST}" "${SOURCE}"

				# echo "Removing ${DEST}"
				rm -rf "${DEST}"

				# echo "symlinking ${DEST} to ${SOURCE}"
				ln -sf "${SOURCE}" "${DEST}"
			else
				# echo "${DEST} is not a symlink nor a existing directory"

				# echo "Checking if folder ${SOURCE} exists"
				if [[ ! -d ${SOURCE} ]] && [[ ! -L ${SOURCE} ]]; then
					echo "Creating ${SOURCE}"
					mkdir -p "${SOURCE}"
				fi

				# echo "Checking if folder ${DEST} exists"
				if [[ ! -d ${DEST} ]] && [[ ! -L ${DEST} ]]; then
					mkdir -p "${DEST}"
					rm -rf "${DEST}"
				fi

				# echo "symlinking ${DEST} to ${SOURCE}"
				if [[ -d ${SOURCE} ]]; then
					ln -sf "${SOURCE}" "${DEST}"
				fi
			fi

		}

		function anything-llm_models() {
			SOURCE="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"

			# ### DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/anything-llm_models"
			# ### LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/anything-llm_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/anything-llm_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/anything-llm_models"
			LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/anything-llm_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/anything-llm_models"
			# LINKER
		}

		function COMFYUI_MODELS() {
			SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
			DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/models"
			LINKER

			# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
			# LINKER
			# ### DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/comfyui_models"
			# ### LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
			LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
			LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
			# LINKER
		}

		function FORGE_MODELS() {
			SOURCE="${STACK_BASEPATH}/DATA/ai-models/forge_models"

			# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/forge_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/forge_models"
			LINKER
			# ### DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/forge_models"
			# ### LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/forge_models"
			LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/forge_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/forge_models"
			# LINKER
		}

		function INVOKEAI_MODELS() {
			SOURCE="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"

			# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/InvokeAI_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/InvokeAI_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/InvokeAI_models"
			# LINKER
			# ### DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/InvokeAI_models"
			# ### LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/InvokeAI_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/InvokeAI_models"
			# LINKER
		}

		function LOCALAI_MODELS() {
			SOURCE="${STACK_BASEPATH}/DATA/ai-models/localai_models"

			# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/localai_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/localai_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/localai_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/localai_models"
			LINKER
			# ### DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/localai_models"
			# ### LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/localai_models"
			# LINKER
		}

		function OLLAMA_MODELS() {
			SOURCE="${STACK_BASEPATH}/DATA/ai-models/localai_models"

			# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/ollama_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/ollama_models"
			LINKER
			# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/ollama_models"
			# LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/ollama_models"
			LINKER
			DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/ollama_models"
			LINKER
			# ### DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/ollama_models"
			# ### LINKER
		}

		function AI_INPUTS() {
			## ai-outputs > ComfyUI/output
			SOURCE="${STACK_BASEPATH}/DATA/ai-outputs"
			DEST="${COMFYUI_PATH}/output"
			LINKER
			## variety/Downloaded > ai-outputs
			SOURCE="/home/${USER}/.config/variety/Downloaded"
			DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
			LINKER
			## variety/Fetched > ai-outputs
			SOURCE="/home/${USER}/.config/variety/Fetched"
			DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
			LINKER
			## variety/Favorites > ai-outputs
			SOURCE="/home/${USER}/.config/variety/Favorites"
			DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
			LINKER
		}

		function AI_OUTPUTS() {
			## ai-inputs > ComfyUI/input
			SOURCE="${STACK_BASEPATH}/DATA/ai-inputs"
			DEST="${COMFYUI_PATH}/input"
			LINKER
			## variety/Downloaded > ai-inputs
			SOURCE="/home/${USER}/.config/variety/Downloaded"
			DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
			LINKER
			## variety/Fetched > ai-inputs
			SOURCE="/home/${USER}/.config/variety/Fetched"
			DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
			LINKER
			## variety/Favorites > ai-inputs
			SOURCE="/home/${USER}/.config/variety/Favorites"
			DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
			LINKER
		}

		INVOKEAI_MODELS
		COMFYUI_MODELS
		anything-llm_models
		FORGE_MODELS
		LOCALAI_MODELS
		OLLAMA_MODELS

		AI_INPUTS
		AI_OUTPUTS
	}

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

		export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
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
			uv run comfy-cli --skip-prompt install --nvidia --restore
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
	UPDATE=true

	CREATE_FOLDERS
	LINK_FOLDERS

	INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &
	CLONE_WORKFLOWS      # >/dev/null 2>&1 &

	# "${STACK_BASEPATH}"/SCRIPTS/done_sound.sh
	# xdg-open "http://${IP_ADDRESS}:8188/"

}

function CLONE_COMFYUIMINI() {

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

	rm -rf "workflows"
	ln -sf "${STACK_BASEPATH}/DATA/ai-workflows" "workflows"

	function LOCAL_SETUP() {

		echo "Using Local setup"

		cp "config/default.example.json" "config/default.json"

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

CLONE_ANYTHINGLLM # >/dev/null 2>&1 &
CLONE_SCANOPY     # >/dev/null 2>&1 &
CLONE_MYPMD       # >/dev/null 2>&1 &
CLONE_CLAIR       # >/dev/null 2>&1 &
CLONE_COMFYUIMINI # >/dev/null 2>&1 &
CLONE_COMFYUI     # >/dev/null 2>&1 &
CLONE_OLLMVT      # >/dev/null 2>&1 &
CLONE_PUPPETEER   # >/dev/null 2>&1 &
CLONE_SWARMUI     # >/dev/null 2>&1 &

function CREATE_FOLDERS() {

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
	mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"
	mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
	mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-custom_nodes"

}

function LINK_FOLDERS() {

	function LINKER() {

		if test -L "${DEST}"; then
			echo "${DEST} is already a symlink."
			echo ""
		elif test -d "${DEST}"; then
			echo "${DEST} is just a plain directory!"

			# echo "Checking if ${SOURCE} exists"
			if [[ ! -d ${SOURCE} ]] && [[ ! -L ${SOURCE} ]]; then
				# echo "Creating ${SOURCE}"
				mkdir -p "${SOURCE}"
			fi

			# echo "Trying to move files!"
			# echo "from ${DEST} to ${SOURCE}"
			rsync -aHAX "${DEST}"/* "${SOURCE}"
			# mv -f "${DEST}"/* "${SOURCE}"
			# cp -au "${DEST}" "${SOURCE}"

			# echo "Removing ${DEST}"
			rm -rf "${DEST}"

			# echo "symlinking ${DEST} to ${SOURCE}"
			ln -sf "${SOURCE}" "${DEST}"
		else
			# echo "${DEST} is not a symlink nor a existing directory"

			# echo "Checking if folder ${SOURCE} exists"
			if [[ ! -d ${SOURCE} ]] && [[ ! -L ${SOURCE} ]]; then
				echo "Creating ${SOURCE}"
				mkdir -p "${SOURCE}"
			fi

			# echo "Checking if folder ${DEST} exists"
			if [[ ! -d ${DEST} ]] && [[ ! -L ${DEST} ]]; then
				mkdir -p "${DEST}"
				rm -rf "${DEST}"
			fi

			# echo "symlinking ${DEST} to ${SOURCE}"
			if [[ -d ${SOURCE} ]]; then
				ln -sf "${SOURCE}" "${DEST}"
			fi
		fi

	}

	function anything-llm_models() {
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"

		# ### DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/anything-llm_models"
		# ### LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/anything-llm_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/anything-llm_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/anything-llm_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/anything-llm_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/anything-llm_models"
		# LINKER
	}

	function COMFYUI_MODELS() {
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		DEST="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI/models"
		LINKER

		# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
		# LINKER
		# ### DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/comfyui_models"
		# ### LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
		# LINKER
	}

	function FORGE_MODELS() {
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/forge_models"

		# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/forge_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/forge_models"
		LINKER
		# ### DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/forge_models"
		# ### LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/forge_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/forge_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/forge_models"
		# LINKER
	}

	function INVOKEAI_MODELS() {
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"

		# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/InvokeAI_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/InvokeAI_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/InvokeAI_models"
		# LINKER
		# ### DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/InvokeAI_models"
		# ### LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/InvokeAI_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/InvokeAI_models"
		# LINKER
	}

	function LOCALAI_MODELS() {
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/localai_models"

		# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/localai_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/localai_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/localai_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/localai_models"
		LINKER
		# ### DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/localai_models"
		# ### LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/localai_models"
		# LINKER
	}

	function OLLAMA_MODELS() {
		SOURCE="${STACK_BASEPATH}/DATA/ai-models/localai_models"

		# DEST="${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/ollama_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/comfyui_models/ollama_models"
		LINKER
		# DEST="${STACK_BASEPATH}/DATA/ai-models/forge_models/ollama_models"
		# LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/ollama_models"
		LINKER
		DEST="${STACK_BASEPATH}/DATA/ai-models/localai_models/ollama_models"
		LINKER
		# ### DEST="${STACK_BASEPATH}/DATA/ai-models/ollama_models/ollama_models"
		# ### LINKER
	}

	function AI_INPUTS() {
		## ai-outputs > ComfyUI/output
		SOURCE="${STACK_BASEPATH}/DATA/ai-outputs"
		DEST="${COMFYUI_PATH}/output"
		LINKER
		## variety/Downloaded > ai-outputs
		SOURCE="/home/${USER}/.config/variety/Downloaded"
		DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Downloaded"
		LINKER
		## variety/Fetched > ai-outputs
		SOURCE="/home/${USER}/.config/variety/Fetched"
		DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Fetched"
		LINKER
		## variety/Favorites > ai-outputs
		SOURCE="/home/${USER}/.config/variety/Favorites"
		DEST="${STACK_BASEPATH}/DATA/ai-outputs/variety/Favorites"
		LINKER
	}

	function AI_OUTPUTS() {
		## ai-inputs > ComfyUI/input
		SOURCE="${STACK_BASEPATH}/DATA/ai-inputs"
		DEST="${COMFYUI_PATH}/input"
		LINKER
		## variety/Downloaded > ai-inputs
		SOURCE="/home/${USER}/.config/variety/Downloaded"
		DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Downloaded"
		LINKER
		## variety/Fetched > ai-inputs
		SOURCE="/home/${USER}/.config/variety/Fetched"
		DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Fetched"
		LINKER
		## variety/Favorites > ai-inputs
		SOURCE="/home/${USER}/.config/variety/Favorites"
		DEST="${STACK_BASEPATH}/DATA/ai-inputs/variety/Favorites"
		LINKER
	}

	INVOKEAI_MODELS
	COMFYUI_MODELS
	anything-llm_models
	FORGE_MODELS
	LOCALAI_MODELS
	OLLAMA_MODELS

	AI_INPUTS
	AI_OUTPUTS
}

CREATE_FOLDERS
LINK_FOLDERS
