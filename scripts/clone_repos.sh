#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD
export UV_LINK_MODE=copy

echo "Working directory is set to ${WD}"
cd "${WD}" || exit

mkdir -p "../DATA/ai-stack"
mkdir -p "../DATA/jaison-stack"
mkdir -p "../DATA/openllm-vtuber-stack"
mkdir -p "../DATA/media-stack"
mkdir -p "../DATA/essential-stack"
mkdir -p "../DATA/riko-stack"
mkdir -p "../DATA/aiwaifu-stack"
mkdir -p "../DATA/airi-stack"
./install_uv.sh
./install_toolhive.sh

function CLONE_AIRI() {
	cd "${WD}" || exit
	cd "../DATA/airi-stack" || exit 1

	function LOCAL_SETUP() {

		function INSTALL_XSAI() {
			cd "${WD}" || exit
			cd "../DATA/airi-stack" || exit 1

			echo "Cloning xsai"
			echo ""
			git clone --recursive https://github.com/moeru-ai/xsai.git xsai
			cd xsai || exit

			npx npm-check-updates -u
			ni
			nr build
		}
		function INSTALL_XSAI_TRANSFORMERS() {
			cd "${WD}" || exit
			cd "../DATA/airi-stack" || exit 1

			echo "Cloning xsai-transformers"
			echo ""
			git clone --recursive https://github.com/moeru-ai/xsai-transformers.git xsai-transformers
			cd xsai-transformers || exit

			npx npm-check-updates -u
			ni
			nr build
		}
		function INSTALL_AIRI_CHAT() {
			cd "${WD}" || exit
			cd "../DATA/airi-stack" || exit 1

			echo "Cloning airi_chat"
			echo ""
			git clone --recursive https://github.com/moeru-ai/chat.git airi-chat
			cd airi-chat || exit

			ni
			nr build
		}
		function INSTALL_AIRI() {

			cd "${WD}" || exit
			cd "../DATA/airi-stack" || exit 1

			echo "Cloning airi"
			echo ""
			git clone --recursive https://github.com/moeru-ai/airi.git airi
			cd airi || exit
			npx npm-check-updates -u
			npm i -g @antfu/ni
			npm i -g shiki
			npm i -g pkgroll

			ni
			nr build

			# For Rust dependencies
			# Not required if you are not going to develop on either crates or apps/tamagotchi
			sudo apt install -y cargo
			cargo fetch

			export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
			corepack enable

			# telegram bot setup
			cd services/telegram-bot || exit
			cp .env .env.local
			# docker compose -p airi-telegram-bot-db up -d

			npx npm-check-updates -u
			ni
			nr build
			# nr -F @proj-airi/telegram-bot db:generate
			# nr -F @proj-airi/telegram-bot db:push
			# nr -F @proj-airi/telegram-bot dev

			# discord bot setup
			cd ../discord-bot || exit
			cp .env .env.local

			npx npm-check-updates -u
			ni
			nr build
			# nr -F @proj-airi/discord-bot dev

			# minecraft bot setup
			cd ../minecraft || exit
			cp .env .env.local

			npx npm-check-updates -u
			ni
			nr build
			# nr -F @proj-airi/minecraft dev

			cd .. || exit

			# Run as desktop pet:
			# pnpm dev:tamagotchi
			# nr dev:tamagotchi

			# Run as web app:
			# nr dev
			# pnpm dev --host

			# nr dev:docs
			# pnpm dev:docs

			cd "${WD}" || exit
			cd "../DATA/airi-stack/airi" || exit 1
			npx npm-check-updates -u

			cp -f "${WD}/CustomDockerfile-airi-uv" CustomDockerfile-airi-uv
			cp -f "${WD}/CustomDockerfile-airi-conda" CustomDockerfile-airi-conda
			cp -f "${WD}/CustomDockerfile-airi-venv" CustomDockerfile-airi-venv
		}
		# echo "Cloning airi"
		# echo ""
		INSTALL_AIRI
		# echo "Cloning xsai"
		# echo ""
		INSTALL_XSAI
		# echo "Cloning xsai-transformers"
		# echo ""
		INSTALL_XSAI_TRANSFORMERS
		# echo "Cloning airi_chat"
		# echo ""
		INSTALL_AIRI_CHAT
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-airi-uv" CustomDockerfile-airi-uv
		cp -f "${WD}/CustomDockerfile-airi-conda" CustomDockerfile-airi-conda
		cp -f "${WD}/CustomDockerfile-airi-venv" CustomDockerfile-airi-venv
		# docker build -t airi .
	}
	LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_ANYTHINGLLM() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning anything-llm"
	echo ""
	git clone --recursive https://github.com/Mintplex-Labs/anything-llm.git anything-llm
	cd anything-llm || exit 1
	mkdir -p anything-llm_storage anything-llm_skills

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-anything-llm-uv" CustomDockerfile-anything-llm-uv
		# cp -f "${WD}/CustomDockerfile-anything-llm-conda" CustomDockerfile-anything-llm-conda
		# cp -f "${WD}/CustomDockerfile-anything-llm-venv" CustomDockerfile-anything-llm-venv
		# docker build -t anything-llm .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_AIWAIFU() {
	cd "${WD}" || exit
	cd "../DATA/aiwaifu-stack" || exit 1

	echo "Cloning AIwaifu"
	echo ""
	git clone --recursive https://github.com/HRNPH/AIwaifu.git aiwaifu
	cd aiwaifu || exit 1

	function LOCAL_SETUP() {
		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras
		uv pip install -e .
		# uv pip install -r requirements.txt

		# pipx install poetry --force
		# poetry env use 3.8
		# poetry lock
		# poetry install
		# poetry env activate
		# uv venv .venv --clear
		# uv pip install -r requirements.txt
		# cd AIVoifu/voice_conversion/Sovits/monotonic_align || exit 1
		# python setup.py build_ext --inplace && cd ../../../../

		# this run on localhost 8267 by default
		# python ./api_inference_server.py

		# this will connect to all the server (Locally)
		# it is possible to host the api model on the external server, just beware of security issue
		# I'm planning to make a docker container for hosting on cloud provider for inference, but not soon
		# python ./main.py
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-aiwaifu-uv" CustomDockerfile-aiwaifu-uv
		cp -f "${WD}/CustomDockerfile-aiwaifu-conda" CustomDockerfile-aiwaifu-conda
		cp -f "${WD}/CustomDockerfile-aiwaifu-venv" CustomDockerfile-aiwaifu-venv
		# docker build -t aiwaifu .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_CHROMA() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning chroma"
	echo ""
	git clone --recursive https://github.com/ecsricktorzynski/chroma.git chroma
	cd chroma || exit 1

	function LOCAL_SETUP() {
		uv venv --clear --seed
		source .venv/bin/activate
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-chroma-uv" CustomDockerfile-chroma-uv
		cp -f "${WD}/CustomDockerfile-chroma-conda" CustomDockerfile-chroma-conda
		cp -f "${WD}/CustomDockerfile-chroma-venv" CustomDockerfile-chroma-venv
		# docker build -t chroma .
	}
	LOCAL_SETUP
	# DOCKER_SETUP
}
function CLONE_CLICKHOUSE() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning clickhouse"
	echo ""
	git clone --recursive https://github.com/mostafaghadimi/clickhouse.git clickhouse
	cd clickhouse || exit 1

	function LOCAL_SETUP() {
		if [[ ! -f .env ]]; then
			cp .env.sample .env
		fi
		chmod +x script.sh
		./script.sh
		uv venv --clear --seed
		source .venv/bin/activate

		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		if [[ ! -f .env ]]; then
			cp .env.sample .env
		fi
		chmod +x script.sh
		./script.sh
		cp -f "${WD}/CustomDockerfile-chroma-uv" CustomDockerfile-chroma-uv
		cp -f "${WD}/CustomDockerfile-chroma-conda" CustomDockerfile-chroma-conda
		cp -f "${WD}/CustomDockerfile-chroma-venv" CustomDockerfile-chroma-venv
		cp -f config_files/prometheus/templates/prometheus.yaml config_files/prometheus/prometheus.yaml
		# docker build -t chroma .
	}
	LOCAL_SETUP
	# DOCKER_SETUP
}
function CLONE_JAISON() {
	cd "${WD}" || exit
	cd "../DATA/jaison-stack" || exit 1

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

		uv sync --all-extras
		uv pip install -e .
		uv pip install -r requirements.txt
		uv pip install --no-deps -r requirements.no_deps.txt
		uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
		uv pip install nltk
		uv pip install spacy
		python -m spacy download en_core_web_sm
		uv pip install unidic
		python -m unidic download >/dev/null 2>&1 &
		python install.py
		# python ./src/main.py --help
		# python ./src/main.py --config=example
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-jaison-core-uv" CustomDockerfile-jaison-core-uv
		cp -f "${WD}/CustomDockerfile-jaison-core-conda" CustomDockerfile-jaison-core-conda
		cp -f "${WD}/CustomDockerfile-jaison-core-venv" CustomDockerfile-jaison-core-venv
		# docker build -t jaison-core . --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_LETTA() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning Letta"
	echo ""
	git clone --recursive https://github.com/letta-ai/letta.git letta-server
	cd letta-server || exit

	function LOCAL_SETUP() {
		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras

		uv pip install -e .
		# uv pip install -r requirements.txt
		# uv run letta server
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-letta-uv" CustomDockerfile-letta-uv
		cp -f "${WD}/CustomDockerfile-letta-conda" CustomDockerfile-letta-conda
		cp -f "${WD}/CustomDockerfile-letta-venv" CustomDockerfile-letta-venv

		# docker build -t letta .
	}
	LOCAL_SETUP
	# DOCKER_SETUP
}
function CLONE_LIBRECHAT() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning librechat"
	echo ""
	git clone --recursive https://github.com/danny-avila/librechat.git librechat
	cd librechat || exit 1
	mkdir -p images uploads logs data-node meili_data

	function DOCKER_SETUP() {
		if [[ ! -f .env ]]; then
			cp .env.example .env
		fi
		# cp docker-compose.override.yml.example docker-compose.override.yml
		# docker build -t whisper-webui .
	}
	# DOCKER_SETUP
}
function CLONE_LOCALAI() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning LocalAI"
	echo ""
	git clone --recursive https://github.com/mudler/LocalAI.git localai
	git clone --recursive https://github.com/mudler/LocalAI-examples.git localai-examples
	cd localai || exit 1
	mkdir -p .cache
	mkdir -p backends
	mkdir -p configuration
	mkdir -p content
	mkdir -p images
	mkdir -p models

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-localai-uv" CustomDockerfile-localai-uv
		# cp -f "${WD}/CustomDockerfile-localai-conda" CustomDockerfile-localai-conda
		# cp -f "${WD}/CustomDockerfile-localai-venv" CustomDockerfile-text-localai-venv
		# docker build -t localai .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_LLMSTACK() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning LLMStack"
	echo ""
	git clone --recursive https://github.com/trypromptly/LLMStack.git llmstack
	cd llmstack || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras
		uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-llmstack-uv" CustomDockerfile-llmstack-uv
		# cp -f "${WD}/CustomDockerfile-llmstack-conda" CustomDockerfile-llmstack-conda
		# cp -f "${WD}/CustomDockerfile-llmstack-venv" CustomDockerfile-text-llmstack-venv

		# npx npm-check-updates -u

		cd llmstack/client || exit 1

		npx npm-check-updates -u
		npm install
		npm run build
		# cd ../../
		# make api
		# make api-image
		# make app
		# docker build -t llmstack .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_STABLE-DIFFUSION-WEBUI-DOCKER() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning stable-diffusion-webui-docker"
	echo ""
	git clone --recursive https://github.com/AbdBarho/stable-diffusion-webui-docker.git stable-diffusion-webui-docker
	cd stable-diffusion-webui-docker || exit 1
	mkdir -p data/Models/CLIPEncoder

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras
		uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-stable-diffusion-webui-docker-uv" CustomDockerfile-stable-diffusion-webui-docker-uv
		# cp -f "${WD}/CustomDockerfile-stable-diffusion-webui-docker-conda" CustomDockerfile-stable-diffusion-webui-docker-conda
		# cp -f "${WD}/CustomDockerfile-stable-diffusion-webui-docker-venv" CustomDockerfile-text-stable-diffusion-webui-docker-venv
		# docker build -t stable-diffusion-webui-docker .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_LOCALAGI() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning LocalAGI"
	echo ""
	git clone --recursive https://github.com/mudler/LocalAGI.git localagi
	cd localagi || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-localagi-uv" CustomDockerfile-localagi-uv
		# cp -f "${WD}/CustomDockerfile-localagi-conda" CustomDockerfile-localagi-conda
		# cp -f "${WD}/CustomDockerfile-localagi-venv" CustomDockerfile-text-localagi-venv
		# docker build -t localagi .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_BIGAGI() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning BIG-AGI"
	echo ""
	git clone --recursive https://github.com/enricoros/big-agi.git big-agi
	cd big-agi || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-big-agi-uv" CustomDockerfile-big-agi-uv
		# cp -f "${WD}/CustomDockerfile-big-agi-conda" CustomDockerfile-big-agi-conda
		# cp -f "${WD}/CustomDockerfile-big-agi-venv" CustomDockerfile-text-big-agi-venv
		# docker build -t big-agi .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_NEXTCLOUD() {
	cd "${WD}" || exit
	cd "../DATA/essential-stack" || exit 1

	echo "Cloning nextcloud"
	echo ""
	git clone --recursive https://github.com/nextcloud/all-in-one.git nextcloud
	cd nextcloud || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-nextcloud-uv" CustomDockerfile-nextcloud-uv
		# cp -f "${WD}/CustomDockerfile-nextcloud-conda" CustomDockerfile-nextcloud-conda
		# cp -f "${WD}/CustomDockerfile-nextcloud-venv" CustomDockerfile-text-nextcloud-venv
		# docker build -t nextcloud .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_MIDORIAISUBSYSTEM() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning subsystem-manager"
	echo ""
	git clone --recursive https://github.com/lunamidori5/subsystem-manager.git subsystem-manager
	cd subsystem-manager || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-subsystem-manager-uv" CustomDockerfile-subsystem-manager-uv
		# cp -f "${WD}/CustomDockerfile-subsystem-manager-conda" CustomDockerfile-subsystem-manager-conda
		# cp -f "${WD}/CustomDockerfile-subsystem-manager-venv" CustomDockerfile-text-subsystem-manager-venv
		# docker build -t subsystem-manager .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_LOCALRECALL() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning LocalRecall"
	echo ""
	git clone --recursive https://github.com/mudler/LocalRecall.git localrecall
	cd localrecall || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-localrecall-uv" CustomDockerfile-localrecall-uv
		# cp -f "${WD}/CustomDockerfile-localrecall-conda" CustomDockerfile-localrecall-conda
		# cp -f "${WD}/CustomDockerfile-localrecall-venv" CustomDockerfile-text-localrecall-venv
		# docker build -t localrecall .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_MELOTTS() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning MeloTTS"
	echo ""
	git clone --recursive https://github.com/myshell-ai/MeloTTS.git melotts
	cd melotts || exit

	function LOCAL_SETUP() {
		uv venv --clear --seed
		source .venv/bin/activate

		# uv sync --all-extras
		uv pip install -e .
		# uv pip install -r requirements.txt
		uv pip install unidic
		python -m unidic download >/dev/null 2>&1 &
		# docker build -t melotts .
		# docker run --gpus all -itd -p 8888:8888 melotts
		# melo-webui
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-melotts-uv" CustomDockerfile-melotts-uv
		cp -f "${WD}/CustomDockerfile-melotts-conda" CustomDockerfile-melotts-conda
		cp -f "${WD}/CustomDockerfile-melotts-venv" CustomDockerfile-melotts-venv
		# docker build -t melotts .
	}
	LOCAL_SETUP
	# DOCKER_SETUP
}
function CLONE_OLLMVT() {
	cd "${WD}" || exit
	cd "../DATA/openllm-vtuber-stack" || exit 1

	echo "Cloning openllm-vtuber"
	echo ""
	git clone --recursive https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git openllm-vtuber
	cd openllm-vtuber || exit
	function LOCAL_SETUP() {
		export INSTALL_WHISPER=true
		export INSTALL_BARK=true

		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras

		# uv pip install -e .
		uv pip install -r requirements.txt
		uv pip install -r requirements-bilibili.txt

		uv pip install py3-tts sherpa-onnx fish-audio-sdk unidic-lite mecab-python3

		uv add git+https://github.com/myshell-ai/MeloTTS.git
		uv pip install git+https://github.com/myshell-ai/MeloTTS.git

		uv add git+https://github.com/suno-ai/bark.git
		uv pip install git+https://github.com/suno-ai/bark.git

		uv pip install unidic
		python -m unidic download >/dev/null 2>&1 &

		#     python3 - <<PYCODE
		# import nltk
		# nltk.download('averaged_perceptron_tagger_eng')
		# PYCODE
		if [[ ! -f "conf.yaml" ]]; then
			cp config_templates/conf.default.yaml conf.yaml
		fi

		function CLONE_L2D_MODELS() {
			cd "${WD}" || exit
			cd "../DATA/openllm-vtuber-stack/openllm-vtuber/live2d-models" || exit 1
			echo "Cloning Live2D Models"
			echo ""
			# git clone --recursive https://github.com/Eikanya/Live2d-model
			# git clone --recursive https://github.com/Mnaisuka/Live2d-model Live2d-models
			# git clone --recursive https://github.com/andatoshiki/toshiki-live2d
			# git clone --recursive https://github.com/xiaoski/live2d_models_collection
			# git clone --recursive https://github.com/ezshine/AwesomeLive2D
			# git clone --recursive https://github.com/n0099/TouhouCannonBall-Live2d-Models
		}
		function CLONE_VOICE_MODELS() {
			cd "${WD}" || exit
			cd "../DATA/openllm-vtuber-stack/openllm-vtuber/models" || exit 1
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
			cd "${WD}" || exit
			cd "../DATA/openllm-vtuber-stack/openllm-vtuber" || exit 1
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
		cp -f "${WD}/CustomDockerfile-openllm-vtuber-uv" CustomDockerfile-openllm-vtuber-uv
		cp -f "${WD}/CustomDockerfile-openllm-vtuber-conda" CustomDockerfile-openllm-vtuber-conda
		cp -f "${WD}/CustomDockerfile-openllm-vtuber-venv" CustomDockerfile-openllm-vtuber-venv

		# docker build -t open-llm-vtuber .
		# --build-arg INSTALL_ORIGINAL_WHISPER=true --build-arg INSTALL_BARK=true
	}
	LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_OOGABOOGA() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning text-generation-webui-docker"
	echo ""
	git clone --recursive https://github.com/Atinoda/text-generation-webui-docker.git text-generation-webui-docker
	cd text-generation-webui-docker || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-text-generation-webui-docker-uv" CustomDockerfile-text-generation-webui-docker-uv
		# cp -f "${WD}/CustomDockerfile-text-generation-webui-docker-conda" CustomDockerfile-text-generation-webui-docker-conda
		# cp -f "${WD}/CustomDockerfile-text-generation-webui-docker-venv" CustomDockerfile-text-generation-webui-docker-venv
		# docker build -t text-generation-webui-docker .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_PRIVATEGPT() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning privateGPT"
	echo ""
	git clone --recursive https://github.com/zylon-ai/private-gpt.git private-gpt
	cd private-gpt || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-private-gpt-uv" CustomDockerfile-private-gpt-uv
		# cp -f "${WD}/CustomDockerfile-private-gpt-conda" CustomDockerfile-private-gpt-conda
		# cp -f "${WD}/CustomDockerfile-private-gpt-venv" CustomDockerfile-private-gpt-venv
		# docker build -t private-gpt .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_PROMETHEUS() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning prometheus"
	echo ""
	git clone --recursive https://github.com/prometheus/prometheus.git prometheus
	cd prometheus || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# make && sudo make install

		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-prometheus-uv" CustomDockerfile-prometheus-uv
		# cp -f "${WD}/CustomDockerfile-prometheus-conda" CustomDockerfile-prometheus-conda
		# cp -f "${WD}/CustomDockerfile-prometheus-venv" CustomDockerfile-prometheus-venv
		# docker build -t prometheus .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_RIKOPROJECT() {
	cd "${WD}" || exit
	cd "../DATA/riko-stack" || exit 1

	echo "Cloning riko-project"
	echo ""
	git clone --recursive https://github.com/rayenfeng/riko_project.git riko-project
	cd riko-project || exit

	function LOCAL_SETUP() {
		cp -f "${WD}/CustomDockerfile-riko-project-uv" CustomDockerfile-riko-project-uv
		cp -f "${WD}/CustomDockerfile-riko-project-conda" CustomDockerfile-riko-project-conda
		cp -f "${WD}/CustomDockerfile-riko-project-venv" CustomDockerfile-riko-project-venv
		cp -f "${WD}/install_reqs-riko.sh" install_reqs.sh

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
		cp -f "${WD}/CustomDockerfile-riko-project-uv" CustomDockerfile-riko-project-uv
		cp -f "${WD}/CustomDockerfile-riko-project-conda" CustomDockerfile-riko-project-conda
		cp -f "${WD}/CustomDockerfile-riko-project-venv" CustomDockerfile-riko-project-venv
		cp -f "${WD}/install_reqs-riko.sh" install_reqs.sh
		# docker build -t riko-project .
	}
	LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_SIGNOZ() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning signoz"
	echo ""
	git clone --recursive https://github.com/SigNoz/signoz.git signoz
	cd signoz || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-signoz-uv" CustomDockerfile-signoz-uv
		# cp -f "${WD}/CustomDockerfile-signoz-conda" CustomDockerfile-signoz-conda
		# cp -f "${WD}/CustomDockerfile-signoz-venv" CustomDockerfile-signoz-venv
		# docker build -t signoz .
	}
	# LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_SWARMUI() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning SwarmUI"
	echo ""
	git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git swarmui
	cd swarmui || exit 1
	function LOCAL_SETUP() {
		# ./install.sh
		# uv venv --clear --seed
		# source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
		chmod +x launch-linux.sh
		# ./launch-linux.sh --launch_mode none --host 0.0.0.0 >/dev/null 2>&1 &

	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${WD}/CustomDockerfile-swarmui-uv" CustomDockerfile-swarmui-uv
		# cp -f "${WD}/CustomDockerfile-swarmui-conda" CustomDockerfile-swarmui-conda
		# cp -f "${WD}/CustomDockerfile-swarmui-venv" CustomDockerfile-swarmui-venv

		cp -f "${WD}/CustomDockerfile-swarmui" launchtools/CustomDockerfile.docker
		cp -f "${WD}/custom-launch-docker.sh" launchtools/custom-launch-docker.sh
		# docker build -t swarmui .
		./launchtools/custom-launch-docker.sh
	}
	LOCAL_SETUP
	DOCKER_SETUP
}
function CLONE_WHISPER_WEBUI() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning Whisper-WebUI"
	echo ""
	git clone --recursive https://github.com/jhj0517/Whisper-WebUI.git whisper-webui
	cd whisper-webui || exit 1

	function DOCKER_SETUP() {
		cp -f "../../../ai-stack/ai-services/whisper-webui/docker-compose.yaml" docker-compose.yaml

		# docker build -t whisper-webui .
	}
	# DOCKER_SETUP
}
function CLONE_WHISPERX() {
	cd "${WD}" || exit
	cd "../DATA/ai-stack" || exit 1

	echo "Cloning whisperx"
	echo ""
	git clone --recursive https://github.com/jim60105/docker-whisperX.git whisperx
	cd whisperx || exit 1

	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		cp -f "${WD}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		cp -f "${WD}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .
	}
	# DOCKER_SETUP
}

function CLONE_VIEWTUBE() {
	cd "${WD}" || exit
	cd "../DATA/media-stack" || exit 1

	echo "Cloning viewtube"
	echo ""
	git clone --recursive https://github.com/ViewTube/viewtube.git viewtube
	cd viewtube || exit 1

	function LOCAL_SETUP() {
		# ./install.sh
		uv venv --clear --seed
		source .venv/bin/activate
		#
		# uv sync --all-extras
		# uv pip install -e .
		# uv pip install -r requirements.txt
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		cp -f "${WD}/CustomDockerfile-viewtube-uv" CustomDockerfile-viewtube-uv
		cp -f "${WD}/CustomDockerfile-viewtube-conda" CustomDockerfile-viewtube-conda
		cp -f "${WD}/CustomDockerfile-viewtube-venv" CustomDockerfile-viewtube-venv
		# docker build -t viewtube .
	}
	LOCAL_SETUP
	# DOCKER_SETUP
}

CLONE_AIRI
CLONE_AIWAIFU
CLONE_CHROMA
CLONE_CLICKHOUSE
CLONE_JAISON
CLONE_LETTA
CLONE_LIBRECHAT
CLONE_LOCALAI
CLONE_LOCALAGI
CLONE_BIGAGI
CLONE_MIDORIAISUBSYSTEM
CLONE_NEXTCLOUD
CLONE_LLMSTACK
CLONE_ANYTHINGLLM
CLONE_LOCALRECALL
CLONE_MELOTTS
CLONE_OLLMVT
CLONE_OOGABOOGA
CLONE_PRIVATEGPT
CLONE_PROMETHEUS
CLONE_RIKOPROJECT
CLONE_SIGNOZ
CLONE_WHISPER_WEBUI
CLONE_VIEWTUBE
CLONE_WHISPERX
CLONE_STABLE-DIFFUSION-WEBUI-DOCKER
CLONE_SWARMUI
