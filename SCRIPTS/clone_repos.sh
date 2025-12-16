#!/bin/bash
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

function CREATE_FOLDERS() {

	mkdir -p "${COMFYUI_PATH}/custom_nodes/models"
	mkdir -p "${COMFYUI_PATH}/input"
	mkdir -p "${COMFYUI_PATH}/models"
	mkdir -p "${COMFYUI_PATH}/models/anything-llm_models"
	mkdir -p "${COMFYUI_PATH}/models/forge_models"
	mkdir -p "${COMFYUI_PATH}/models/InvokeAI_models"
	mkdir -p "${COMFYUI_PATH}/models/localai_models"
	mkdir -p "${COMFYUI_PATH}/models/ollama_models"
	mkdir -p "${COMFYUI_PATH}/output"
	mkdir -p "${COMFYUI_PATH}/user/default/workflows"
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
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
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
	mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"
	mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
	mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"

}

CREATE_FOLDERS

"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"

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

function CLONE_ANYTHINGLLM() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning anything-llm"
	echo ""
	git clone --recursive https://github.com/Mintplex-Labs/anything-llm.git anything-llm
	cd anything-llm || exit 1
	mkdir -p anything-llm_storage anything-llm_skills

	function LOCAL_SETUP() {
		echo "Using Local setup"
		# ./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-anything-llm-uv" CustomDockerfile-anything-llm-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-anything-llm-conda" CustomDockerfile-anything-llm-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-anything-llm-venv" CustomDockerfile-anything-llm-venv
		# docker build -t anything-llm .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}

function CLONE_PUPPETEER() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning puppeteer"
	echo ""
	git clone --recursive https://github.com/puppeteer/puppeteer.git puppeteer
	cd puppeteer || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		ni # >/dev/null 2>&1 &

		ni puppeteer # Downloads compatible Chrome during installation.
		yes | pnpm add puppeteer

		ni puppeteer-core # Alternatively, install as a library, without downloading Chrome.
		yes | pnpm add puppeteer-core

		npx puppeteer install chrome

		yes | npx npm-check-updates -u >/dev/null 2>&1 &
		bash docker/pack.sh

		# npm init --yes
		# npm install puppeteer puppeteer-core @puppeteer/browsers

		# ./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}

	LOCAL_SETUP # >/dev/null 2>&1 &
}

function CLONE_OLLMVT() {
	cd "${STACK_BASEPATH}/DATA/openllm-vtuber-stack" || exit 1

	echo "Cloning Open-LLM-VTuber"
	echo ""
	git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git Open-LLM-VTuber
	cd Open-LLM-VTuber || exit
	function LOCAL_SETUP() {
		export INSTALL_WHISPER=true
		export INSTALL_BARK=true
		export UV_LINK_MODE=copy

		uv venv --clear --seed
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
		cp -f "${SCRIPT_DIR}/CustomDockerfile-openllm-vtuber-uv" CustomDockerfile-openllm-vtuber-uv
		cp -f "${SCRIPT_DIR}/CustomDockerfile-openllm-vtuber-conda" CustomDockerfile-openllm-vtuber-conda
		cp -f "${SCRIPT_DIR}/CustomDockerfile-openllm-vtuber-venv" CustomDockerfile-openllm-vtuber-venv

		# docker build -t open-llm-vtuber .
		# --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}

function CLONE_SWARMUI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning SwarmUI"
	echo ""
	git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git swarmui
	cd swarmui || exit 1
	function LOCAL_SETUP() {
		# ./install.sh
		uv venv --clear --seed
		source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
		chmod +x launch-linux.sh

	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-swarmui-uv" CustomDockerfile-swarmui-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-swarmui-conda" CustomDockerfile-swarmui-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-swarmui-venv" CustomDockerfile-swarmui-venv

		cp -f "${SCRIPT_DIR}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
		cp -f "${SCRIPT_DIR}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh
		# docker build -t swarmui .
		./launchtools/custom-launch-docker.sh
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}

function LINK_FOLDERS() {

	function LINK_COMFYUI_FOLDERS() {

		function LINK_COMFYUI_MODELS() {

			## ComfyUI
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

			## Anything-LLM
			if test -L "${COMFYUI_PATH}/models/anything-llm_models"; then
				echo "${COMFYUI_PATH}/models/anything-llm_models is a symlink to a directory"
				# ls -la "${COMFYUI_PATH}/models/anything-llm_models"
			elif test -d "${COMFYUI_PATH}/models/anything-llm_models"; then
				echo "${COMFYUI_PATH}/models/anything-llm_models is just a plain directory"
				mv -f "${COMFYUI_PATH}/models/anything-llm_models"/* "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"
				rm -rf "${COMFYUI_PATH}/models/anything-llm_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models" "${COMFYUI_PATH}/models/anything-llm_models"
			fi
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
			if test -L "${COMFYUI_PATH}/models/InvokeAI_models"; then
				echo "${COMFYUI_PATH}/models/InvokeAI_models is a symlink to a directory"
				# ls -la "${COMFYUI_PATH}/models/InvokeAI_models"
			elif test -d "${COMFYUI_PATH}/models/InvokeAI_models"; then
				echo "${COMFYUI_PATH}/models/InvokeAI_models is just a plain directory"
				mv -f "${COMFYUI_PATH}/models/InvokeAI_models"/* "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"
				rm -rf "${COMFYUI_PATH}/models/InvokeAI_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models" "${COMFYUI_PATH}/models/InvokeAI_models"
			fi
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
			if test -L "${COMFYUI_PATH}/models/localai_models"; then
				echo "${COMFYUI_PATH}/models/localai_models is a symlink to a directory"
				# ls -la "${COMFYUI_PATH}/models/localai_models"
			elif test -d "${COMFYUI_PATH}/models/localai_models"; then
				echo "${COMFYUI_PATH}/models/localai_models is just a plain directory"
				mv -f "${COMFYUI_PATH}/models/localai_models"/* "${STACK_BASEPATH}/DATA/ai-models/localai_models"
				rm -rf "${COMFYUI_PATH}/models/localai_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/localai_models" "${COMFYUI_PATH}/models/localai_models"
			fi
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
			if test -L "${COMFYUI_PATH}/models/ollama_models"; then
				echo "${COMFYUI_PATH}/models/ollama_models is a symlink to a directory"
				# ls -la "${COMFYUI_PATH}/models/ollama_models"
			elif test -d "${COMFYUI_PATH}/models/ollama_models"; then
				echo "${COMFYUI_PATH}/models/ollama_models is just a plain directory"
				mv -f "${COMFYUI_PATH}/models/ollama_models"/* "${STACK_BASEPATH}/DATA/ai-models/ollama_models"
				rm -rf "${COMFYUI_PATH}/models/ollama_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/ollama_models" "${COMFYUI_PATH}/models/ollama_models"
			fi
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
			if test -L "${COMFYUI_PATH}/models/forge_models"; then
				echo "${COMFYUI_PATH}/models/forge_models is a symlink to a directory"
				# ls -la "${COMFYUI_PATH}/models/forge_models"
			elif test -d "${COMFYUI_PATH}/models/forge_models"; then
				echo "${COMFYUI_PATH}/models/forge_models is just a plain directory"
				mv -f "${COMFYUI_PATH}/models/forge_models"/* "${STACK_BASEPATH}/DATA/ai-models/forge_models"
				rm -rf "${COMFYUI_PATH}/models/forge_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/forge_models" "${COMFYUI_PATH}/models/forge_models"
			fi
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

		function LINK_ANYTHINGLLM_MODELS() {

			## ComfyUI
			if test -L "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models is a symlink to a directory"
				# ls -la "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
			elif test -d "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models is just a plain directory"
				rm -rf "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models" "${COMFYUI_PATH}/models"
			fi

		}

		function LINK_FORGE_MODELS() {

			## ComfyUI
			if test -L "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models is a symlink to a directory"
				# ls -la "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
			elif test -d "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models is just a plain directory"
				rm -rf "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models" "${COMFYUI_PATH}/models"
			fi

		}

		function LINK_OLLAMA_MODELS() {

			## ComfyUI
			if test -L "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models is a symlink to a directory"
				# ls -la "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
			elif test -d "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models is just a plain directory"
				rm -rf "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models" "${COMFYUI_PATH}/models"
			fi

		}

		function LINK_INVOKEAI_MODELS() {

			## ComfyUI
			if test -L "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models is a symlink to a directory"
				# ls -la "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
			elif test -d "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models is just a plain directory"
				rm -rf "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models" "${COMFYUI_PATH}/models"
			fi

		}

		function LINK_LOCALAI_MODELS() {

			## ComfyUI
			if test -L "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models is a symlink to a directory"
				# ls -la "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
			elif test -d "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"; then
				echo "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models is just a plain directory"
				rm -rf "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
				ln -s "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models" "${COMFYUI_PATH}/models"
			fi

		}

		function LINK_COMFYUI_OUTPUTS() {

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

		function LINK_COMFYUI_INPUTS() {

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

		function LINK_COMFYUI_WORKFLOWS() {
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

		function LINK_COMFYUI_VARIETY() {

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
		LINK_COMFYUI_MODELS
		LINK_INVOKEAI_MODELS
		LINK_LOCALAI_MODELS
		LINK_ANYTHINGLLM_MODELS
		LINK_FORGE_MODELS
		LINK_OLLAMA_MODELS

		LINK_COMFYUI_INPUTS

		LINK_COMFYUI_OUTPUTS
		LINK_ANYTHINGLLM_OUTPUTS

		LINK_COMFYUI_WORKFLOWS

		LINK_COMFYUI_VARIETY

	}

	LINK_COMFYUI_FOLDERS

}

function CLONE_COMFYUI() {

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	export UV_LINK_MODE=copy
	export BACKGROUND=true
	export COMFYUI_PORT=8188

	export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
	export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/extra_custom_nodes.txt"
	export DISABLED_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/disabled_custom_nodes.txt"

	# if [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]] || [[ "$1" == "--reinstall" ]]; then
	# 	echo "Install custom nodes enabled."
	# 	export INSTALL_CUSTOM_NODES=true
	# elif [[ "$1" == "-fr" ]] || [[ "$1" == "--full-reinstall" ]] || [[ "$1" == "--factory-reset" ]] || [[ "$1" == "--full-reinstall" ]]; then
	# 	echo "Full re-install custom nodes enabled."
	# 	export INSTALL_CUSTOM_NODES=true
	# 	rm -rf "${COMFYUI_PATH}/.venv"
	# elif [[ -z "$1" ]] || [[ "$1" == "-nr" ]] || [[ "$1" == "--no-reinstall" ]]; then
	# 	echo "Skipping reinstall custom nodes."
	# 	export INSTALL_CUSTOM_NODES=false
	# fi

	echo "Cloning ComfyUI"
	echo ""
	git clone --recursive https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_PATH}"
	cd "${COMFYUI_PATH}" || exit 1

	function CREATE_FOLDERS() {

		mkdir -p "${COMFYUI_PATH}/custom_nodes/models"
		mkdir -p "${COMFYUI_PATH}/models"
		mkdir -p "${COMFYUI_PATH}/models/anything-llm_models"
		mkdir -p "${COMFYUI_PATH}/models/forge_models"
		mkdir -p "${COMFYUI_PATH}/models/InvokeAI_models"
		mkdir -p "${COMFYUI_PATH}/models/localai_models"
		mkdir -p "${COMFYUI_PATH}/models/ollama_models"
		mkdir -p "${COMFYUI_PATH}/user/default/workflows"

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
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models/comfyui_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/forge_models/comfyui_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models/comfyui_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/localai_models/comfyui_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/ollama_models/comfyui_models"
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
		mkdir -p "${STACK_BASEPATH}/DATA/ai-stack/models/workflows/workflows"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"
		mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
		mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"

	}

	CREATE_FOLDERS

	"${STACK_BASEPATH}/SCRIPTS/install_uv.sh"
	"${STACK_BASEPATH}/SCRIPTS/install_toolhive.sh"

	function LINK_FOLDERS() {

		function LINK_COMFYUI_FOLDERS() {

			function LINK_COMFYUI_MODELS() {

				## ComfyUI
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

				## Anything-LLM
				if test -L "${COMFYUI_PATH}/models/anything-llm_models"; then
					echo "${COMFYUI_PATH}/models/anything-llm_models is a symlink to a directory"
					# ls -la "${COMFYUI_PATH}/models/anything-llm_models"
				elif test -d "${COMFYUI_PATH}/models/anything-llm_models"; then
					echo "${COMFYUI_PATH}/models/anything-llm_models is just a plain directory"
					mv -f "${COMFYUI_PATH}/models/anything-llm_models"/* "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models"
					rm -rf "${COMFYUI_PATH}/models/anything-llm_models"
					ln -s "${STACK_BASEPATH}/DATA/ai-models/anything-llm_models" "${COMFYUI_PATH}/models/anything-llm_models"
				fi
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
				if test -L "${COMFYUI_PATH}/models/InvokeAI_models"; then
					echo "${COMFYUI_PATH}/models/InvokeAI_models is a symlink to a directory"
					# ls -la "${COMFYUI_PATH}/models/InvokeAI_models"
				elif test -d "${COMFYUI_PATH}/models/InvokeAI_models"; then
					echo "${COMFYUI_PATH}/models/InvokeAI_models is just a plain directory"
					mv -f "${COMFYUI_PATH}/models/InvokeAI_models"/* "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models"
					rm -rf "${COMFYUI_PATH}/models/InvokeAI_models"
					ln -s "${STACK_BASEPATH}/DATA/ai-models/InvokeAI_models" "${COMFYUI_PATH}/models/InvokeAI_models"
				fi
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
				if test -L "${COMFYUI_PATH}/models/localai_models"; then
					echo "${COMFYUI_PATH}/models/localai_models is a symlink to a directory"
					# ls -la "${COMFYUI_PATH}/models/localai_models"
				elif test -d "${COMFYUI_PATH}/models/localai_models"; then
					echo "${COMFYUI_PATH}/models/localai_models is just a plain directory"
					mv -f "${COMFYUI_PATH}/models/localai_models"/* "${STACK_BASEPATH}/DATA/ai-models/localai_models"
					rm -rf "${COMFYUI_PATH}/models/localai_models"
					ln -s "${STACK_BASEPATH}/DATA/ai-models/localai_models" "${COMFYUI_PATH}/models/localai_models"
				fi
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
				if test -L "${COMFYUI_PATH}/models/ollama_models"; then
					echo "${COMFYUI_PATH}/models/ollama_models is a symlink to a directory"
					# ls -la "${COMFYUI_PATH}/models/ollama_models"
				elif test -d "${COMFYUI_PATH}/models/ollama_models"; then
					echo "${COMFYUI_PATH}/models/ollama_models is just a plain directory"
					mv -f "${COMFYUI_PATH}/models/ollama_models"/* "${STACK_BASEPATH}/DATA/ai-models/ollama_models"
					rm -rf "${COMFYUI_PATH}/models/ollama_models"
					ln -s "${STACK_BASEPATH}/DATA/ai-models/ollama_models" "${COMFYUI_PATH}/models/ollama_models"
				fi
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
				if test -L "${COMFYUI_PATH}/models/forge_models"; then
					echo "${COMFYUI_PATH}/models/forge_models is a symlink to a directory"
					# ls -la "${COMFYUI_PATH}/models/forge_models"
				elif test -d "${COMFYUI_PATH}/models/forge_models"; then
					echo "${COMFYUI_PATH}/models/forge_models is just a plain directory"
					mv -f "${COMFYUI_PATH}/models/forge_models"/* "${STACK_BASEPATH}/DATA/ai-models/forge_models"
					rm -rf "${COMFYUI_PATH}/models/forge_models"
					ln -s "${STACK_BASEPATH}/DATA/ai-models/forge_models" "${COMFYUI_PATH}/models/forge_models"
				fi
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

			function LINK_COMFYUI_OUTPUTS() {
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

			function LINK_COMFYUI_INPUTS() {
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

			function LINK_COMFYUI_WORKFLOWS() {
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

			function LINK_COMFYUI_VARIETY() {

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

			LINK_COMFYUI_MODELS
			LINK_COMFYUI_OUTPUTS
			LINK_COMFYUI_INPUTS
			LINK_COMFYUI_WORKFLOWS
			LINK_COMFYUI_VARIETY

		}
		LINK_COMFYUI_FOLDERS

	}

	LINK_FOLDERS

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

		git clone --recursive https://github.com/ecjojo/ecjojo-comfyui-workflows.git "${WORKFLOWDIR}/ecjojo/ecjojo-comfyui-workflows"

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

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

	INSTALL_DEFAULT_NODES=true
	INSTALL_EXTRA_NODES=false
	UPDATE=true

	LINK_FOLDERS
	CLONE_WORKFLOWS

	INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &

	# xdg-open http://0.0.0.0:8188/

}

function CLONE_COMFYUIMINI() {

	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	export COMFYUIMINI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini"

	echo "Cloning ComfyUIMini"
	echo ""
	git clone --recursive https://github.com/ImDarkTom/ComfyUIMini.git "${COMFYUIMINI_PATH}"
	cd ComfyUIMini || exit 1

	rm -rf "workflows"
	ln -s "${STACK_BASEPATH}/DATA/ai-workflows" "${COMFYUIMINI_PATH}/workflows"

	function LOCAL_SETUP() {

		echo "Using Local setup"

		cp config/default.example.json config/default.json

		chmod +x scripts/install.sh
		yes | ./scripts/install.sh

		# npm install
		# npm run build
		chmod +x scripts/start.sh
		./scripts/start.sh >/dev/null 2>&1 &
		# npm start

		# if [[ ! -f .venv/bin/activate ]]; then
		# 	export UV_LINK_MODE=copy
		# 	uv venv --clear --seed
		# 	source .venv/bin/activate

		# 	uv pip install --upgrade pip
		# 	uv sync --all-extras

		# 	uv pip install comfy-cli
		# 	yes | uv run comfy-cli install --nvidia --restore || true
		# fi

	}

	function DOCKER_SETUP() {

		echo "Using Docker setup"
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
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

LINK_FOLDERS >/dev/null 2>&1 &
# CLONE_COMFYUI     # >/dev/null 2>&1 &
CLONE_COMFYUIMINI >/dev/null 2>&1 &
CLONE_PUPPETEER >/dev/null 2>&1 &
CLONE_SWARMUI >/dev/null 2>&1 &
CLONE_ANYTHINGLLM >/dev/null 2>&1 &
CLONE_OLLMVT >/dev/null 2>&1 &
