#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	# coqui-tts-cpu
	# faster-whisper-gpu
	# koboldccp
	# kokoro-tts
	# llmstack
	# make-sense
	# midori-ai-subsystem-manager
	# piper
	# text-generation-webui-docker
	# vllm-openai
	# whishper
	# whisper-webui
	# whisperx
	# wyoming-piper
	anything-llm
	# basic-memory
	big-agi
	# chatbot-ollama
	# chatgpt-next-web
	# chroma
	# clickhouse
	# comfyui
	# grafana
	# hollama
	homeassistant
	# invokeai
	letta-mcp-server
	letta-server
	# librechat
	# libretranslate-whispher
	# lobe-chat
	localai
	# minio
	# mongo-whispher
	n8n
	ollama
	open-webui
	# private-gpt
	# prometheus
	# prompt-optimizer
	searxng
	# signoz
	# stable-diffusion-models-download
	# stable-diffusion-webui
	# stable-diffusion-webui-docker
	# swarmui
	# voice-chat-ai
)

function CREATE_FOLDERS() {
	for FOLDERNAME in "${FOLDERS[@]}"; do
		if [[ ! -d "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}" ]]; then
			echo "Creating folder: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
			mkdir -p "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
		# else
		# 	echo "Folder already exists: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}, skipping creation"
		fi
	done
}

function SETUP_FOLDERS() {
	if [[ ${SERVICE_NAME} == "anything-llm" ]]; then
		FOLDERS=(
			"config"
			"data"
			"models"
			"prompts"
			"vectorstores"
		)
		CREATE_FOLDERS
		if [[ ! -f "${FOLDER}/${SERVICE_NAME}_storage/.env" ]]; then
			echo "Downloading example anything-llm .env file"
			sudo wget -c "https://raw.githubusercontent.com/Mintplex-Labs/anything-llm/refs/heads/master/server/.env.example" -O "${FOLDER}/${SERVICE_NAME}_storage/.env"
		else
			echo "anything-llm .env file already exists, skipping download"
		fi
	fi

	if [[ ${SERVICE_NAME} == "private-gpt" ]]; then
		FOLDERS=(
			"ollama_local_data"
			"llamacpp-cpu_local_data"
			"llamacpp-cpu_models"
		)
	fi

	if [[ ${SERVICE_NAME} == "comfyui" ]]; then
		FOLDERS=(
			"common_storage"
		)
	fi

	if [[ ${SERVICE_NAME} == "basic-memory" ]]; then
		FOLDERS=(
			"config"
			"knowledge"
			"personal-notes"
			"work-notes"
		)
	fi

	if [[ ${SERVICE_NAME} == "vllm-openai" ]]; then
		FOLDERS=(
			"huggingface_cache"
		)
	fi

	if [[ ${SERVICE_NAME} == "chroma" ]]; then
		FOLDERS=(
			"data"
			"index"
		)
	fi

	if [[ ${SERVICE_NAME} == "clickhouse" ]]; then
		FOLDERS=(
			"backups"
			"configs"
			"data"
			"initdb"
			"logs"
			"users"
		)
	fi

	if [[ ${SERVICE_NAME} == "grafana" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "mongo-whispher" ]]; then
		FOLDERS=(
			"data"
			"logs"
		)
	fi

	if [[ ${SERVICE_NAME} == "homeassistant" ]]; then
		FOLDERS=(
			"config"
			"media"
		)
	fi

	if [[ ${SERVICE_NAME} == "koboldccp" ]]; then
		FOLDERS=(
			"workspace"
		)
	fi

	if [[ ${SERVICE_NAME} == "kokoro-tts" ]]; then
		FOLDERS=(
			"data"
			"index_data"
		)
	fi

	if [[ ${SERVICE_NAME} == "coqui-tts-cpu" ]]; then
		FOLDERS=(
			"data"
			"index_data"
		)
	fi

	if [[ ${SERVICE_NAME} == "letta-server" ]]; then
		FOLDERS=(
			"data"
			"tool_execution_dir"
		)
	fi

	if [[ ${SERVICE_NAME} == "librechat" ]]; then
		FOLDERS=(
			"vectordb_data"
			"mongo_data"
			"images"
			"uploads"
			"logs"
			"meili_data"
		)
	fi

	if [[ ${SERVICE_NAME} == "libretranslate-whispher" ]]; then
		FOLDERS=(
			"cache"
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "localai" ]]; then
		FOLDERS=(
			"cache"
			"backends"
			"configuration"
			"content"
			"images"
			"models"
		)
	fi

	if [[ ${SERVICE_NAME} == "minio" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "mongo-whispher" ]]; then
		FOLDERS=(
			"data"
			"logs"
		)
	fi

	if [[ ${SERVICE_NAME} == "n8n" ]]; then
		FOLDERS=(
			"data"
			"local_files"
		)
	fi

	if [[ ${SERVICE_NAME} == "ollama" ]]; then
		FOLDERS=(
			"data"
			"models"
		)
	fi

	if [[ ${SERVICE_NAME} == "open-webui" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "piper" ]]; then
		FOLDERS=(
			"config"
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "faster-whisper-gpu" ]]; then
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "text-generation-webui-docker" ]]; then
		FOLDERS=(
			"cache"
			"characters"
			"grammars"
			"templates"
			"loras"
			"logs"
			"models"
			"presets"
			"prompts"
			"training"
			"extensions"
			"coqui_tts"
			"data"
			"instruction-templates"
		)
	fi

	if [[ ${SERVICE_NAME} == "llmstack" ]]; then
		FOLDERS=(
			"code"
			"userdata"
			"postgres_data"
			"weaviate_data"
			"redis_data"
		)
	fi

	if [[ ${SERVICE_NAME} == "prometheus" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "searxng" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "signoz" ]]; then
		FOLDERS=(
			"data"
			"index"
		)
	fi

	if [[ ${SERVICE_NAME} == "stable-diffusion-webui-docker" ]]; then
		FOLDERS=(
			"config"
			"data"
			"embeddings"
			"models"
			"output"
			"workflows"
		)
	fi

	if [[ ${SERVICE_NAME} == "swarmui" ]]; then
		FOLDERS=(
			"backend"
			"data"
			"dlnodes"
			"extensions"
		)
	fi

	if [[ ${SERVICE_NAME} == "whishper" ]]; then
		FOLDERS=(
			"data"
			"logs"
			"models"
			"uploads"
			"cache"
			"outputs"
			"configs"
		)
	fi

	if [[ ${SERVICE_NAME} == "whisperx" ]]; then
		FOLDERS=(
			"data"
			"logs"
			"models"
			"uploads"
			"cache"
			"outputs"
			"configs"
		)
	fi

	if [[ ${SERVICE_NAME} == "whisper-webui" ]]; then
		FOLDERS=(
			"data"
			"logs"
			"models"
			"uploads"
			"cache"
			"outputs"
			"configs"
		)
	fi

	if [[ ${SERVICE_NAME} == "wyoming-piper" ]]; then
		FOLDERS=(
			"data"
		)
	fi
	CREATE_FOLDERS
}

ARGS=""
for SERVICE_NAME in "${COMPOSE_FILES[@]}"; do
	ARGS+="-f ${SERVICE_NAME}/docker-compose.yaml "
	FOLDER="../../../DATA/${STACK_NAME}-stack/${SERVICE_NAME}"
	if [[ ! -d ${FOLDER} ]]; then
		echo ""
		echo "Creating folder: ${FOLDER}"
		mkdir -p "${FOLDER}"
	# else
	# 	echo ""
	# 	echo "Folder already exists: ${FOLDER}, skipping creation"
	fi
	SETUP_FOLDERS
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
