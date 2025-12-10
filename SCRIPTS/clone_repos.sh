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
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs"
mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input"
mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs"

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

					npx npm-check-updates -u >/dev/null 2>&1 &

					ni >/dev/null 2>&1 &
					nr -F @proj-airi/telegram-bot db:generate >/dev/null 2>&1
					nr -F @proj-airi/telegram-bot db:push >/dev/null 2>&1
					nr -F @proj-airi/telegram-bot dev >/dev/null 2>&1
				}
				function DISCORDBOT() {
					cd "${STACK_BASEPATH}/DATA/airi-stack/airi/services/discord-bot" || exit 1
					cp .env .env.local

					npx npm-check-updates -u >/dev/null 2>&1 &

					ni >/dev/null 2>&1 &
					nr -F @proj-airi/discord-bot dev >/dev/null 2>&1 &
				}
				function MINECRAFTBOT() {
					cd "${STACK_BASEPATH}/DATA/airi-stack/airi/services/minecraft" || exit 1

					cp .env .env.local

					npx npm-check-updates -u >/dev/null 2>&1 &

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

			npx npm-check-updates -u >/dev/null 2>&1 &

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

			npx npm-check-updates -u >/dev/null 2>&1 &

			ni >/dev/null 2>&1 &
			# nr -F build >/dev/null 2>&1 &
		}

		function INSTALL_XSAI_TRANSFORMERS() {
			cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

			echo "Cloning xsai-transformers"
			echo ""
			git clone --recursive https://github.com/moeru-ai/xsai-transformers.git xsai-transformers
			cd xsai-transformers || exit

			npx npm-check-updates -u >/dev/null 2>&1 &

			ni >/dev/null 2>&1 &
			# nr -F build >/dev/null 2>&1 &
		}

		function INSTALL_AIRI_CHAT() {
			cd "${STACK_BASEPATH}/DATA/airi-stack" || exit 1

			echo "Cloning airi_chat"
			echo ""
			git clone --recursive https://github.com/moeru-ai/chat.git airi-chat
			cd airi-chat || exit

			npx npm-check-updates -u >/dev/null 2>&1 &

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
function CLONE_CHROMA() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-chroma-uv" CustomDockerfile-chroma-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-chroma-conda" CustomDockerfile-chroma-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-chroma-venv" CustomDockerfile-chroma-venv
		# docker build -t chroma .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_CLICKHOUSE() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning clickhouse"
	echo ""
	git clone --recursive https://github.com/mostafaghadimi/clickhouse.git clickhouse
	cd clickhouse || exit 1

	function LOCAL_SETUP() {
		if [[ ! -f .env ]]; then
			cp .env.sample .env
			sed -i -e 's/<minio_root_user>/root/g' .env
			sed -i -e 's/<minio_root_password>/root/g' .env
			sed -i -e 's/<minio_clickhouse_backup_bucket>/clickhouse_backups/g' .env
			sed -i -e 's/<clickhouse_admin_user_password>/root/g' .env
			sed -i -e 's/<clickhouse_business_injection_user_password>/root/g' .env
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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-chroma-uv" CustomDockerfile-chroma-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-chroma-conda" CustomDockerfile-chroma-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-chroma-venv" CustomDockerfile-chroma-venv
		cp -f config_files/prometheus/templates/prometheus.yaml config_files/prometheus/prometheus.yaml
		# docker build -t chroma .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
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
function CLONE_LETTA() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-letta-uv" CustomDockerfile-letta-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-letta-conda" CustomDockerfile-letta-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-letta-venv" CustomDockerfile-letta-venv

		# docker build -t letta .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_LIBRECHAT() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

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
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_LOCALAI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning LocalAI"
	echo ""
	git clone --recursive https://github.com/mudler/LocalAI.git localai
	git clone --recursive https://github.com/mudler/LocalAI-examples.git localai-examples
	cd localai || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localai-uv" CustomDockerfile-localai-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localai-conda" CustomDockerfile-localai-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localai-venv" CustomDockerfile-text-localai-venv
		# docker build -t localai .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_LLMSTACK() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning LLMStack"
	echo ""
	git clone --recursive https://github.com/trypromptly/LLMStack.git llmstack
	cd llmstack || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		cd llmstack/client || exit 1

		npx npm-check-updates -u >/dev/null 2>&1 &

		ni >/dev/null 2>&1 &
		# nr -F build >/dev/null 2>&1 &
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-llmstack-uv" CustomDockerfile-llmstack-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-llmstack-conda" CustomDockerfile-llmstack-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-llmstack-venv" CustomDockerfile-text-llmstack-venv

		# cd ${STACK_BASEPATH}/${STACK_BASEPATH}/
		# make api
		# make api-image
		# make app
		# docker build -t llmstack .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_LOCALAGI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning LocalAGI"
	echo ""
	git clone --recursive https://github.com/mudler/LocalAGI.git localagi
	cd localagi || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localagi-uv" CustomDockerfile-localagi-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localagi-conda" CustomDockerfile-localagi-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localagi-venv" CustomDockerfile-text-localagi-venv
		# docker build -t localagi .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_BIGAGI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning BIG-AGI"
	echo ""
	git clone --recursive https://github.com/enricoros/big-agi.git big-agi
	cd big-agi || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-big-agi-uv" CustomDockerfile-big-agi-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-big-agi-conda" CustomDockerfile-big-agi-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-big-agi-venv" CustomDockerfile-text-big-agi-venv
		# docker build -t big-agi .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}

function CLONE_MIDORIAISUBSYSTEM() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning subsystem-manager"
	echo ""
	git clone --recursive https://github.com/lunamidori5/subsystem-manager.git subsystem-manager
	cd subsystem-manager || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-subsystem-manager-uv" CustomDockerfile-subsystem-manager-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-subsystem-manager-conda" CustomDockerfile-subsystem-manager-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-subsystem-manager-venv" CustomDockerfile-text-subsystem-manager-venv
		# docker build -t subsystem-manager .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_LOCALRECALL() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning LocalRecall"
	echo ""
	git clone --recursive https://github.com/mudler/LocalRecall.git localrecall
	cd localrecall || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localrecall-uv" CustomDockerfile-localrecall-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localrecall-conda" CustomDockerfile-localrecall-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-localrecall-venv" CustomDockerfile-text-localrecall-venv
		# docker build -t localrecall .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_MELOTTS() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

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

		IMPORT_NLTK >/dev/null 2>&1 &

		# docker build -t melotts .
		# docker run --gpus all -itd -p 8888:8888 melotts
		# melo-webui
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-melotts-uv" CustomDockerfile-melotts-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-melotts-conda" CustomDockerfile-melotts-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-melotts-venv" CustomDockerfile-melotts-venv
		# docker build -t melotts .
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
function CLONE_OOGABOOGA() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning text-generation-webui-docker"
	echo ""
	git clone --recursive https://github.com/Atinoda/text-generation-webui-docker.git text-generation-webui-docker
	cd text-generation-webui-docker || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-text-generation-webui-docker-uv" CustomDockerfile-text-generation-webui-docker-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-text-generation-webui-docker-conda" CustomDockerfile-text-generation-webui-docker-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-text-generation-webui-docker-venv" CustomDockerfile-text-generation-webui-docker-venv
		# docker build -t text-generation-webui-docker .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_PRIVATEGPT() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning privateGPT"
	echo ""
	git clone --recursive https://github.com/zylon-ai/private-gpt.git private-gpt
	cd private-gpt || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-private-gpt-uv" CustomDockerfile-private-gpt-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-private-gpt-conda" CustomDockerfile-private-gpt-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-private-gpt-venv" CustomDockerfile-private-gpt-venv
		# docker build -t private-gpt .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_PROMETHEUS() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning prometheus"
	echo ""
	git clone --recursive https://github.com/prometheus/prometheus.git prometheus
	cd prometheus || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		# ./install.sh
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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-prometheus-uv" CustomDockerfile-prometheus-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-prometheus-conda" CustomDockerfile-prometheus-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-prometheus-venv" CustomDockerfile-prometheus-venv
		# docker build -t prometheus .
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
function CLONE_SIGNOZ() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning signoz"
	echo ""
	git clone --recursive https://github.com/SigNoz/signoz.git signoz
	cd signoz || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-signoz-uv" CustomDockerfile-signoz-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-signoz-conda" CustomDockerfile-signoz-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-signoz-venv" CustomDockerfile-signoz-venv
		# docker build -t signoz .
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
function CLONE_WHISPER_WEBUI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning Whisper-WebUI"
	echo ""
	git clone --recursive https://github.com/jhj0517/Whisper-WebUI.git whisper-webui
	cd whisper-webui || exit 1

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
		cp -f "${STACK_BASEPATH}/${STACK_BASEPATH}/${STACK_BASEPATH}/STACKS/ai-stack/ai-services/whisper-webui/docker-compose.yaml" docker-compose.yaml

		# docker build -t whisper-webui .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}
function CLONE_WHISPERX() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning whisperx"
	echo ""
	git clone --recursive https://github.com/jim60105/docker-whisperX.git whisperx
	cd whisperx || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-uv" CustomDockerfile-whisperx-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-conda" CustomDockerfile-whisperx-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-whisperx-venv" CustomDockerfile-whisperx-venv
		# docker build -t whisperx .
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

	mv "${COMFYUI_PATH}/models/*" "${STACK_BASEPATH}/DATA/ai-models"
	mv "${COMFYUI_PATH}/output/*" "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output"
	mv "${COMFYUI_PATH}/input/*" "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input"

	rm -rf "${COMFYUI_PATH}/models"
	rm -rf "${COMFYUI_PATH}/output"
	rm -rf "${COMFYUI_PATH}/input"

	ln -sf "${STACK_BASEPATH}/DATA/ai-models" "${COMFYUI_PATH}/models"

	ln -sf "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output" "${COMFYUI_PATH}/output"
	ln -sf "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input" "${COMFYUI_PATH}/input"

	ln -sf "${COMFYUI_PATH}/models" "${COMFYUI_PATH}/custom_nodes/models"

	function INSTALL_CUSTOM_NODES() {
		ESSENTIAL() {
			if [[ -f "${ESSENTIAL_CUSTOM_NODELIST}" ]]; then
				echo "Reinstalling custom nodes from ${ESSENTIAL_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n "${node_name}" ]]; then
						uv run comfy-cli node install "${node_name}"
					fi
				done <"${ESSENTIAL_CUSTOM_NODELIST}"
				echo ""
			else
				echo "No ${ESSENTIAL_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
			fi
		}
		EXTRAS() {
			if [[ -f "${EXTRA_CUSTOM_NODELIST}" ]]; then
				echo "Reinstalling custom nodes from ${EXTRA_CUSTOM_NODELIST}"
				while IFS= read -r node_name; do
					if [[ -n "${node_name}" ]]; then
						uv run comfy-cli node install "${node_name}"
					fi
				done <"${EXTRA_CUSTOM_NODELIST}"
				echo ""
			else
				echo "No ${EXTRA_CUSTOM_NODELIST} file found. Skipping custom node reinstallation."
			fi
		}
		if [[ ${INSTALL_DEFAULT_NODES} == "true" ]]; then
			echo "Installing ComfyUI custom nodes..."
			ESSENTIAL
		else
			echo "Skipping ComfyUI custom node install."
		fi
		if [[ ${INSTALL_EXTRA_NODES} == "true" ]]; then
			echo "Installing ComfyUI extra nodes..."
			EXTRAS
		else
			echo "Skipping ComfyUI extra node install."
		fi
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

		if [[ ${BACKGROUND} == "true" ]]; then
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
	INSTALL_EXTRA_NODES=false
	UPDATE=true

	INSTALL_CUSTOM_NODES # >/dev/null 2>&1 &
	# RUN_COMFYUI
}

function CLONE_CUSHYSTUDIO() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning cushy-studio"
	echo ""
	git clone --recursive https://github.com/rvion/CushyStudio.git CushyStudio
	cd CushyStudio || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		./_mac-linux-install.sh >/dev/null 2>&1 &
		# ./_mac-linux-start.sh
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

function CLONE_COMFYUIMINI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning ComfyUIMini"
	echo ""
	git clone --recursive https://github.com/ImDarkTom/ComfyUIMini.git ComfyUIMini
	cd ComfyUIMini || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"

		cp config/default.example.json config/default.json

		chmod +x scripts/install.sh
		./scripts/install.sh

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

function CLONE_FORGE() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning forge"
	echo ""
	git clone --recursive https://github.com/lllyasviel/stable-diffusion-webui-forge.git forge
	cd forge || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		# ./install.sh
		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras
		uv pip install -r requirements.txt
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

}
function CLONE_INVOKEAI() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning invoke-ai"
	echo ""
	git clone --recursive https://github.com/invoke-ai/InvokeAI.git invoke-ai
	cd invoke-ai || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		# ./install.sh
		uv venv --clear --seed
		source .venv/bin/activate

		uv sync --all-extras
		uv pip install -r requirements.txt
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

}

function CLONE_MAKESENSE() {
	cd "${STACK_BASEPATH}/DATA/ai-stack" || exit 1

	echo "Cloning make-sense"
	echo ""
	git clone --recursive https://github.com/SkalskiP/make-sense.git make-sense
	cd make-sense || exit 1

	function LOCAL_SETUP() {
		echo "Using Local setup"
		npx npm-check-updates -u >/dev/null 2>&1 &

		ni >/dev/null 2>&1 &
		# nr start >/dev/null 2>&1 &
	}
	function DOCKER_SETUP() {
		echo "Using Docker setup"
		# Build Docker Image
		# docker build -t make-sense -f docker/Dockerfile .

		# Run Docker Image as Service
		# docker run -dit -p 3000:3000 --restart=always --name=make-sense make-sense

		# Get Docker Container Logs
		# docker logs make-sense

		# Access make-sense: http://0.0.0.0:3000/
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}

function CLONE_VIEWTUBE() {
	cd "${STACK_BASEPATH}/DATA/media-stack" || exit 1

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
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-viewtube-uv" CustomDockerfile-viewtube-uv
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-viewtube-conda" CustomDockerfile-viewtube-conda
		# cp -f "${SCRIPT_DIR}/CustomDockerfile-viewtube-venv" CustomDockerfile-viewtube-venv
		# docker build -t viewtube .
	}

	LOCAL_SETUP  # >/dev/null 2>&1 &
	DOCKER_SETUP # >/dev/null 2>&1 &
}

# CLONE_AIRI
# CLONE_AIWAIFU
CLONE_ANYTHINGLLM
CLONE_BIGAGI
# CLONE_CHROMA
# CLONE_CLICKHOUSE
CLONE_COMFYUI
CLONE_COMFYUIMINI
CLONE_CUSHYSTUDIO
CLONE_FORGE
CLONE_INVOKEAI
# CLONE_JAISON
CLONE_LETTA
CLONE_LIBRECHAT
# CLONE_LLMSTACK
# CLONE_LOCALAGI
CLONE_LOCALAI
# CLONE_LOCALRECALL
# CLONE_MAKESENSE
# CLONE_MELOTTS
CLONE_MIDORIAISUBSYSTEM
CLONE_OLLMVT
# CLONE_OOGABOOGA
# CLONE_PRIVATEGPT
# CLONE_PROMETHEUS
# CLONE_RIKOPROJECT
# CLONE_SIGNOZ
# CLONE_SWARMUI
# CLONE_VIEWTUBE
# CLONE_WHISPER_WEBUI
# CLONE_WHISPERX
