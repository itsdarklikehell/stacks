#!/bin/bash
echo "Clone repos script started."
SCRIPT_DIR="$(dirname "$(realpath "$0")")" || true
export SCRIPT_DIR

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
export UV_LINK_MODE=copy

echo "Building is set to: ${BUILDING}"
echo "Working directory is set to ${SCRIPT_DIR}"
echo "Configs directory is set to ${CONFIGS_DIR}"
echo "Data directory is set to ${PERM_DATA}"
echo "Secrets directory is set to ${SECRETS_DIR}"

cd "${SCRIPT_DIR}" || exit 1

mkdir -p "${STACK_BASEPATH}/DATA/ai-models"
mkdir -p "${STACK_BASEPATH}/DATA/ai-backends"
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs"
mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"

mkdir -p "${STACK_BASEPATH}/DATA/ai-stack"
mkdir -p "${STACK_BASEPATH}/DATA/jaison-stack"
mkdir -p "${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
mkdir -p "${STACK_BASEPATH}/DATA/media-stack"
mkdir -p "${STACK_BASEPATH}/DATA/essential-stack"
mkdir -p "${STACK_BASEPATH}/DATA/riko-stack"
mkdir -p "${STACK_BASEPATH}/DATA/aiwaifu-stack"
mkdir -p "${STACK_BASEPATH}/DATA/airi-stack"

./install_uv.sh
./install_toolhive.sh

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

function CLONE_AIRI() {
	cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

	function LOCAL_SETUP() {

		if ! command -v cargo &>/dev/null; then
			sudo apt install -y cargo
		fi

		function INSTALL_AIRI() {
			cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

			echo "Cloning airi"
			echo ""
			git clone --recursive https://github.com/moeru-ai/airi.git airi
			cd airi || exit

			function INSTALL_AIRI_PLUGINS() {

				function TELEGRAMBOT() {
					cd "${STACK_BASEPATH}/DATA/airi-stack/airi/services/telegram-bot" || exit 1
					cp .env .env.local

					# docker compose -p airi-telegram-bot-db up -d >/dev/null 2>&1

					sleep 3

					yes | npx npm-check-updates -u >/dev/null 2>&1 &

					ni >/dev/null 2>&1 &
					nr -F @proj-airi/telegram-bot db:generate >/dev/null 2>&1
					nr -F @proj-airi/telegram-bot db:push >/dev/null 2>&1
					nr -F @proj-airi/telegram-bot dev >/dev/null 2>&1
				}
				function DISCORDBOT() {
					cd "${STACK_BASEPATH}/DATA/airi-stack/airi/services/discord-bot" || exit 1
					cp .env .env.local

					yes | npx npm-check-updates -u >/dev/null 2>&1 &

					ni >/dev/null 2>&1 &
					nr -F @proj-airi/discord-bot dev >/dev/null 2>&1 &
				}
				function MINECRAFTBOT() {
					cd "${STACK_BASEPATH}/DATA/airi-stack/airi/services/minecraft" || exit 1

					cp .env .env.local

					yes | npx npm-check-updates -u >/dev/null 2>&1 &

					ni >/dev/null 2>&1 &
					nr -F @proj-airi/minecraft dev >/dev/null 2>&1 &
				}
				TELEGRAMBOT
				DISCORDBOT
				MINECRAFTBOT
			}

			npm i -g @antfu/ni >/dev/null 2>&1 &
			npm i -g shiki >/dev/null 2>&1 &
			npm i -g pkgroll >/dev/null 2>&1 &
			npm i -g @craco/craco >/dev/null 2>&1 &

			yes | npx npm-check-updates -u >/dev/null 2>&1 &

			INSTALL_AIRI_PLUGINS >/dev/null 2>&1 &

			ni >/dev/null 2>&1 &
			# nr -F build >/dev/null 2>&1 &

			## export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
			## corepack enable
			## cargo fetch

			# Run as desktop pet:
			# pnpm dev:tamagotchi # >/dev/null 2>&1 &
			nr -F dev:tamagotchi >/dev/null 2>&1 &

			# Run as web app:
			# pnpm dev --host # >/dev/null 2>&1 &
			# nr -F dev --host >/dev/null 2>&1 &
			# pnpm dev:docs # >/dev/null 2>&1 &
			nr dev:docs >/dev/null 2>&1 &

			cd "${STACK_BASEPATH}/DATA/airi-stack/airi" || exit 1
			cp -f "${SCRIPT_DIR}/CustomDockerfile-airi-uv" CustomDockerfile-airi-uv
			cp -f "${SCRIPT_DIR}/CustomDockerfile-airi-conda" CustomDockerfile-airi-conda
			cp -f "${SCRIPT_DIR}/CustomDockerfile-airi-venv" CustomDockerfile-airi-venv
		}

		function INSTALL_XSAI() {
			cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

			echo "Cloning xsai"
			echo ""
			git clone --recursive https://github.com/moeru-ai/xsai.git xsai
			cd xsai || exit

			yes | npx npm-check-updates -u >/dev/null 2>&1 &

			ni >/dev/null 2>&1 &
			# nr -F build >/dev/null 2>&1 &
		}

		function INSTALL_XSAI_TRANSFORMERS() {
			cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

			echo "Cloning xsai-transformers"
			echo ""
			git clone --recursive https://github.com/moeru-ai/xsai-transformers.git xsai-transformers
			cd xsai-transformers || exit

			yes | npx npm-check-updates -u >/dev/null 2>&1 &

			ni >/dev/null 2>&1 &
			# nr -F build >/dev/null 2>&1 &
		}

		function INSTALL_AIRI_CHAT() {
			cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

			echo "Cloning airi_chat"
			echo ""
			git clone --recursive https://github.com/moeru-ai/chat.git airi-chat
			cd airi-chat || exit

			yes | npx npm-check-updates -u >/dev/null 2>&1 &

			ni >/dev/null 2>&1 &
			# nr -F build >/dev/null 2>&1 &
		}

		# echo "Cloning airi"
		# echo ""
		INSTALL_AIRI
		# # echo "Cloning xsai"
		# # echo ""
		INSTALL_XSAI
		# # echo "Cloning xsai-transformers"
		# # echo ""
		INSTALL_XSAI_TRANSFORMERS
		# # echo "Cloning airi_chat"
		# # echo ""
		INSTALL_AIRI_CHAT
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${SCRIPT_DIR}/CustomDockerfile-airi-uv" CustomDockerfile-airi-uv
		cp -f "${SCRIPT_DIR}/CustomDockerfile-airi-conda" CustomDockerfile-airi-conda
		cp -f "${SCRIPT_DIR}/CustomDockerfile-airi-venv" CustomDockerfile-airi-venv
		# docker build -t airi .
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

function CLONE_AIWAIFU() {
	cd "${STACK_BASEPATH}/DATA/aiwaifu-stack" || exit 1

	echo "Cloning AIwaifu"
	echo ""
	git clone --recursive https://github.com/HRNPH/AIwaifu.git aiwaifu
	cd aiwaifu || exit 1

	function LOCAL_SETUP() {
		uv venv --clear --seed
		source .venv/bin/activate

		uv pip install -r requirements.txt
		uv pip install poetry fairseq

		# poetry env use 3.8
		# poetry lock
		# poetry install
		# poetry env activate

		# cd "${DATA_DIR}/aiwaifu-stack/aiwaifu/AIVoifu/voice_conversion/Sovits/monotonic_align" || exit 1
		# python setup.py build_ext --inplace

		cd "${STACK_BASEPATH}/DATA/aiwaifu-stack/aiwaifu" || exit 1

		# this run on 0.0.0.0 8267 by default
		python ./api_inference_server.py

		# this will connect to all the server (Locally)
		# it is possible to host the api model on the external server, just beware of security issue
		# I'm planning to make a docker container for hosting on cloud provider for inference, but not soon
		python ./main.py
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${SCRIPT_DIR}/CustomDockerfile-aiwaifu-uv" CustomDockerfile-aiwaifu-uv
		cp -f "${SCRIPT_DIR}/CustomDockerfile-aiwaifu-conda" CustomDockerfile-aiwaifu-conda
		cp -f "${SCRIPT_DIR}/CustomDockerfile-aiwaifu-venv" CustomDockerfile-aiwaifu-venv
		# docker build -t aiwaifu .
	}

	LOCAL_SETUP >/dev/null 2>&1 &
	DOCKER_SETUP >/dev/null 2>&1 &
}

function CLONE_JAISON() {
	cd "${STACK_BASEPATH}/DATA/jaison-stack" || exit 1

	echo "Cloning jaison-core"
	echo ""
	git clone --recursive https://github.com/limitcantcode/jaison-core.git jaison
	cd jaison || exit

	function LOCAL_SETUP() {
		export INSTALL_WHISPER=false
		export INSTALL_BARK=false

		# sudo apt install -y ffmpeg
		uv venv --clear --seed
		source .venv/bin/activate

		# uv sync --all-extras
		# uv pip install -e .
		uv pip install -r requirements.txt
		uv pip install --no-deps -r requirements.no_deps.txt
		uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
		uv pip install nltk
		uv pip install spacy
		python -m spacy download en_core_web_sm

		uv pip install unidic
		python -m unidic download >/dev/null 2>&1 &

		IMPORT_NLTK >/dev/null 2>&1 &

		python install.py
		# python ./src/main.py --help
		# python ./src/main.py --config=example
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${SCRIPT_DIR}/CustomDockerfile-jaison-core-uv" CustomDockerfile-jaison-core-uv
		cp -f "${SCRIPT_DIR}/CustomDockerfile-jaison-core-conda" CustomDockerfile-jaison-core-conda
		cp -f "${SCRIPT_DIR}/CustomDockerfile-jaison-core-venv" CustomDockerfile-jaison-core-venv
		# docker build -t jaison-core . --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
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

function CLONE_RIKOPROJECT() {
	cd "${STACK_BASEPATH}/DATA/riko-stack" || exit 1

	echo "Cloning riko-project"
	echo ""
	git clone --recursive https://github.com/rayenfeng/riko_project.git riko-project
	cd riko-project || exit

	function LOCAL_SETUP() {
		cp -f "${SCRIPT_DIR}/CustomDockerfile-riko-project-uv" CustomDockerfile-riko-project-uv
		cp -f "${SCRIPT_DIR}/CustomDockerfile-riko-project-conda" CustomDockerfile-riko-project-conda
		cp -f "${SCRIPT_DIR}/CustomDockerfile-riko-project-venv" CustomDockerfile-riko-project-venv
		cp -f "${SCRIPT_DIR}/install_reqs-riko.sh" install_reqs.sh

		# sed -i "s/python_mecab_ko; sys_platform != 'win32'//" requirements.txt
		# sed -i "s/transformers>=4.43/transformers>=4.53.0/" requirements.txt

		uv venv --clear --seed
		source .venv/bin/activate
		uv pip install -r requirements.txt
		uv pip install -r extra-req.txt --no-deps
		uv pip install distro jiter

		# pip install --upgrade pip uv nltk
		# uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

		# chmod +x install_reqs.sh
		# ./install_reqs.sh

		# uv run python3 ./server/main_chat.py
		# uv run ./server/main_chat.py
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${SCRIPT_DIR}/CustomDockerfile-riko-project-uv" CustomDockerfile-riko-project-uv
		cp -f "${SCRIPT_DIR}/CustomDockerfile-riko-project-conda" CustomDockerfile-riko-project-conda
		cp -f "${SCRIPT_DIR}/CustomDockerfile-riko-project-venv" CustomDockerfile-riko-project-venv
		cp -f "${SCRIPT_DIR}/install_reqs-riko.sh" install_reqs.sh
		# docker build -t riko-project .
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

function CLONE_COMFYUI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	export UV_LINK_MODE=copy
	export BACKGROUND=true
	export COMFYUI_PORT=8188

	export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

	export ESSENTIAL_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/essential_custom_nodes.txt"
	export EXTRA_CUSTOM_NODELIST="${STACK_BASEPATH}/SCRIPTS/extra_custom_nodes.txt"

	export COMFYUI_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/ComfyUI"

	mkdir -p "${STACK_BASEPATH}/DATA/ai-models/comfyui_models"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs"
	mkdir -p "${STACK_BASEPATH}/DATA/ai-workflows"

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

	function SETUP_FOLDERS() {
		function MODELS() {
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
		}
		function OUTPUTS() {
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
			if test -L "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"; then
				echo "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows is a symlink to a directory"
				# ls -la "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
			elif test -d "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"; then
				echo "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows is just a plain directory"
				mv -f "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"/* "${STACK_BASEPATH}/DATA/ai-workflows"
				rm -rf "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
				ln -s "${STACK_BASEPATH}/DATA/ai-workflows" "${STACK_BASEPATH}/DATA/ai-stack/ComfyUIMini/workflows"
			fi
		}
		MODELS
		OUTPUTS
		INPUTS
		WORKFLOWS

		# if test -d "/home/${USER}/.config/variety/Downloaded"; then
		# 	if test -L "/home/${USER}/.config/variety/Downloaded"; then
		# 		echo "/home/${USER}/.config/variety/Downloaded is a symlink to a directory"
		# 		# ls -la "/home/${USER}/.config/variety/Downloaded"
		# 	else
		# 		# echo "/home/${USER}/.config/variety/Downloaded is just a plain directory"
		# 		mv -f "/home/${USER}/.config/variety/Downloaded/*" "${COMFYUI_PATH}/input/Downloaded"
		# 		rm -rf "/home/${USER}/.config/variety/Downloaded"
		# 		ln -s "${COMFYUI_PATH}/input/Downloaded" "/home/${USER}/.config/variety/Downloaded"

		# 	fi
		# # else
		# # 	echo "/home/${USER}/.config/variety/Downloaded is not a directory (nor a link to one)"
		# fi

		# if test -d "/home/${USER}/.config/variety/Favorites"; then
		# 	if test -L "/home/${USER}/.config/variety/Favorites"; then
		# 		echo "/home/${USER}/.config/variety/Favorites is a symlink to a directory"
		# 		# ls -la "/home/${USER}/.config/variety/Favorites"
		# 	else
		# 		# echo "/home/${USER}/.config/variety/Favorites is just a plain directory"
		# 		mv -f "/home/${USER}/.config/variety/Favorites/*" "${COMFYUI_PATH}/input/Favorites"
		# 		rm -rf "/home/${USER}/.config/variety/Favorites"
		# 		ln -s "${COMFYUI_PATH}/input/Favorites" "/home/${USER}/.config/variety/Favorites"
		# 	fi
		# # else
		# # 	echo "/home/${USER}/.config/variety/Favorites is not a directory (nor a link to one)"
		# fi

		# if test -d "/home/${USER}/.config/variety/Fetched"; then
		# 	if test -L "/home/${USER}/.config/variety/Fetched"; then
		# 		echo "/home/${USER}/.config/variety/Fetched is a symlink to a directory"
		# 		# ls -la "/home/${USER}/.config/variety/Fetched"
		# 	else
		# 		# echo "/home/${USER}/.config/variety/Fetched is just a plain directory"
		# 		mv -f "/home/${USER}/.config/variety/Fetched/*" "${COMFYUI_PATH}/input/Fetched"
		# 		rm -rf "/home/${USER}/.config/variety/Fetched"
		# 		ln -s "${COMFYUI_PATH}/input/Fetched" "/home/${USER}/.config/variety/Fetched"
		# 	fi
		# # else
		# # 	echo "/home/${USER}/.config/variety/Fetched is not a directory (nor a link to one)"
		# fi
	}

	function CLONE_WORKFLOWS() {
		export WORKFLOWDIR="${COMFYUI_PATH}/user/default/workflows"
		cd "${WORKFLOWDIR}" || exit 1

		git clone --recursive https://github.com/comfyanonymous/ComfyUI_examples.git "${WORKFLOWDIR}comfyanonymous/ComfyUI_examples"
	}

	function INSTALL_CUSTOM_NODES() {
		ESSENTIAL() {
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
		EXTRAS() {
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

		ESSENTIAL
		UPDATE_CUSTOM_NODES

		EXTRAS
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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &

	INSTALL_DEFAULT_NODES=true
	INSTALL_EXTRA_NODES=false
	UPDATE=true

	INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &

	SETUP_FOLDERS
	CLONE_WORKFLOWS

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

# CLONE_COMFYUI >/dev/null 2>&1 &

CLONE_COMFYUIMINI >/dev/null 2>&1 &
CLONE_PUPPETEER >/dev/null 2>&1 &

CLONE_SWARMUI >/dev/null 2>&1 &

CLONE_ANYTHINGLLM >/dev/null 2>&1 &

CLONE_AIRI >/dev/null 2>&1 &
CLONE_AIWAIFU >/dev/null 2>&1 &
CLONE_RIKOPROJECT >/dev/null 2>&1 &
CLONE_JAISON >/dev/null 2>&1 &
CLONE_OLLMVT >/dev/null 2>&1 &
