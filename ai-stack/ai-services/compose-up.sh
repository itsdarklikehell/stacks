#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	anything-llm
	autoheal
	basic-memory
	big-agi
	chroma
	clickhouse
	coqui-tts-cpu
	faster-whisper-gpu
	grafana
	hollama
	homeassistant
	# koboldccp
	kokoro-tts
	letta-mcp-server
	letta-server
	librechat
	libretranslate-whispher
	# llmstack
	lobe-chat
	localai
	midori-ai-subsystem-manager
	minio
	mongo-whispher
	n8n
	ollama
	open-webui
	piper
	private-gpt
	prometheus
	searxng
	signoz
	stable-diffusion-models-download
	stable-diffusion-webui
	stable-diffusion-webui-docker
	swarmui
	text-generation-webui-docker
	voice-chat-ai
	watchtower
	whishper
	whisper-webui
	whisperx
	wyoming-piper
)

function CREATE_FOLDERS() {
	if [[ ${f} == "anything-llm" ]]; then
		mkdir -p "${FOLDER}/${f}_storage"
		if [[ ! -f "${FOLDER}/${f}_storage/.env" ]]; then
			echo "Downloading example anything-llm .env file"
			sudo wget -c "https://raw.githubusercontent.com/Mintplex-Labs/anything-llm/refs/heads/master/server/.env.example" -O "${FOLDER}/${f}_storage/.env"
		else
			echo "anything-llm .env file already exists, skipping download"
		fi
	fi
	if [[ ${f} == "basic-memory" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
		mkdir -p "${FOLDER}/${f}_knowledge"
		mkdir -p "${FOLDER}/${f}_personal-notes"
		mkdir -p "${FOLDER}/${f}_work-notes"
	fi
	if [[ ${f} == "chroma" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_index"
	fi
	if [[ ${f} == "clickhouse" ]]; then
		mkdir -p "${FOLDER}/${f}_backups"
		mkdir -p "${FOLDER}/${f}_configs"
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_initdb"
		mkdir -p "${FOLDER}/${f}_logs"
		mkdir -p "${FOLDER}/${f}_users"
	fi
	if [[ ${f} == "grafana" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "mongo-whispher" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_logs"
	fi
	if [[ ${f} == "homeassistant" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
		mkdir -p "${FOLDER}/${f}_media"
	fi
	if [[ ${f} == "koboldccp" ]]; then
		mkdir -p "${FOLDER}/${f}_workspace"
	fi
	if [[ ${f} == "kokoro-tts" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_index_data"
	fi
	if [[ ${f} == "coqui-tts-cpu" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_index_data"
	fi
	if [[ ${f} == "letta-server" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_tool_execution_dir"
	fi
	if [[ ${f} == "librechat" ]]; then
		mkdir -p "${FOLDER}/${f}_postgress_data"
		mkdir -p "${FOLDER}/${f}_mongo_data"
		mkdir -p "${FOLDER}/${f}_images"
		mkdir -p "${FOLDER}/${f}_uploads"
		mkdir -p "${FOLDER}/${f}_logs"
		mkdir -p "${FOLDER}/${f}_meili_data"
	fi
	if [[ ${f} == "libretranslate-whispher" ]]; then
		mkdir -p "${FOLDER}/${f}_cache"
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "localai" ]]; then
		mkdir -p "${FOLDER}/${f}_cache"
		mkdir -p "${FOLDER}/${f}_backends"
		mkdir -p "${FOLDER}/${f}_configuration"
		mkdir -p "${FOLDER}/${f}_content"
		mkdir -p "${FOLDER}/${f}_localai_images"
		mkdir -p "${FOLDER}/${f}_models"
	fi
	if [[ ${f} == "minio" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "mongo-whispher" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_logs"
	fi
	if [[ ${f} == "n8n" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_local_files"
	fi
	if [[ ${f} == "ollama" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_models"
	fi
	if [[ ${f} == "open-webui" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "piper" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "faster-whisper-gpu" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
	fi
	if [[ ${f} == "text-generation-webui-docker" ]]; then
		mkdir -p "${FOLDER}/${f}_cache"
		mkdir -p "${FOLDER}/${f}_characters"
		mkdir -p "${FOLDER}/${f}_grammars"
		mkdir -p "${FOLDER}/${f}_templates"
		mkdir -p "${FOLDER}/${f}_loras"
		mkdir -p "${FOLDER}/${f}_logs"
		mkdir -p "${FOLDER}/${f}_models"
		mkdir -p "${FOLDER}/${f}_presets"
		mkdir -p "${FOLDER}/${f}_prompts"
		mkdir -p "${FOLDER}/${f}_training"
		mkdir -p "${FOLDER}/${f}_extensions"
		mkdir -p "${FOLDER}/${f}_coqui_tts"
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_instruction-templates"
	fi
	if [[ ${f} == "llmstack" ]]; then
		mkdir -p "${FOLDER}/${f}_code"
		mkdir -p "${FOLDER}/${f}_userdata"
		mkdir -p "${FOLDER}/${f}_postgres_data"
		mkdir -p "${FOLDER}/${f}_weaviate_data"
		mkdir -p "${FOLDER}/${f}_redis_data"
	fi
	if [[ ${f} == "prometheus" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "searxng" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
	if [[ ${f} == "signoz" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_index"
	fi
	if [[ ${f} == "stable-diffusion-webui-docker" ]]; then
		mkdir -p "${FOLDER}/${f}_config"
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_embeddings"
		mkdir -p "${FOLDER}/${f}_models"
		mkdir -p "${FOLDER}/${f}_output"
		mkdir -p "${FOLDER}/${f}_workflows"
	fi
	if [[ ${f} == "swarmui" ]]; then
		mkdir -p "${FOLDER}/${f}_backend"
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_dlnodes"
		mkdir -p "${FOLDER}/${f}_extensions"
	fi
	if [[ ${f} == "whishper" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_logs"
		mkdir -p "${FOLDER}/${f}_models"
		mkdir -p "${FOLDER}/${f}_uploads"
		mkdir -p "${FOLDER}/${f}_cache"
		mkdir -p "${FOLDER}/${f}_outputs"
		mkdir -p "${FOLDER}/${f}_configs"
	fi
	if [[ ${f} == "whisperx" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_logs"
		mkdir -p "${FOLDER}/${f}_models"
		mkdir -p "${FOLDER}/${f}_uploads"
		mkdir -p "${FOLDER}/${f}_cache"
		mkdir -p "${FOLDER}/${f}_outputs"
		mkdir -p "${FOLDER}/${f}_configs"
	fi
	if [[ ${f} == "whisper-webui" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
		mkdir -p "${FOLDER}/${f}_logs"
		mkdir -p "${FOLDER}/${f}_models"
		mkdir -p "${FOLDER}/${f}_uploads"
		mkdir -p "${FOLDER}/${f}_cache"
		mkdir -p "${FOLDER}/${f}_outputs"
		mkdir -p "${FOLDER}/${f}_configs"
	fi
	if [[ ${f} == "wyoming-piper" ]]; then
		mkdir -p "${FOLDER}/${f}_data"
	fi
}

ARGS=""
for f in "${COMPOSE_FILES[@]}"; do
	ARGS+="-f ${f}/docker-compose.yaml "
	FOLDER="../../DATA/${STACKNAME}-stack/${f}"
	mkdir -p "${FOLDER}"
	CREATE_FOLDERS
done

function BUILDING() {
	echo ""
	echo "Building is set to: ${BUILDING}"
	echo ""
	if [[ ${BUILDING} == "force_rebuild" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
	elif [[ ${BUILDING} == "true" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi
}
BUILDING
