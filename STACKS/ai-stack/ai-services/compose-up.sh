#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	anything-llm
	automatic1111
	big-agi
	ComfyUI
	forge
	homeassistant
	invokeai
	letta-mcp-server
	letta-server
	librechat
	lobe-chat
	localai
	n8n
	ollama
	open-webui
	searxng
	stable-diffusion-webui
	# swarmui
)

function CREATE_FOLDERS() {
	for FOLDERNAME in "${FOLDERS[@]}"; do
		if [[ ! -d "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}" ]]; then
			echo "Creating folder: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
			mkdir -p "${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}"
		else
			echo "Folder already exists: ${FOLDER}/${SERVICE_NAME}_${FOLDERNAME}, skipping creation"
		fi
	done
}

function SETUP_FOLDERS() {
	if [[ ${SERVICE_NAME} == "anything-llm" ]]; then
		FOLDERS=(
			"config"
			"data"
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

	if [[ ${SERVICE_NAME} == "stable-diffusion-webui" ]]; then
		FOLDERS=(
			"configdir"
		)
	fi

	if [[ ${SERVICE_NAME} == "ComfyUI" ]]; then
		FOLDERS=(
			"common_storage"
		)
	fi

	if [[ ${SERVICE_NAME} == "forge" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "automatic1111" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "invokeai" ]]; then
		FOLDERS=(
			"data"
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

	if [[ ${SERVICE_NAME} == "homeassistant" ]]; then
		FOLDERS=(
			"config"
			"media"
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

	if [[ ${SERVICE_NAME} == "localai" ]]; then
		FOLDERS=(
			"cache"
			"configuration"
			"backends"
			"content"
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
		)
	fi

	if [[ ${SERVICE_NAME} == "open-webui" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "searxng" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "swarmui" ]]; then
		FOLDERS=(
			"backend"
			"data"
			"dlnodes"
			"extensions"
			"config"
			"embeddings"
			"workflows"
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
