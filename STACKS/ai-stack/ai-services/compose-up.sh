#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	# anything-llm
	homeassistant
	# InvokeAI
	# letta-mcp-server
	# letta-server
	# localai
	# forge
	n8n
	ollama
	open-webui
	# puppeteer
	searxng
	# swarmui
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

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}_storage/.env" ]]; then
			echo "Downloading example anything-llm .env file"
			sudo wget -c "https://raw.githubusercontent.com/Mintplex-Labs/anything-llm/refs/heads/master/server/.env.example" -O "${FOLDER}/${SERVICE_NAME}_storage/.env"
		fi

		FOLDERS=(
			"config"
			"data"
			"prompts"
			"vectorstores"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "forge" ]]; then
		FOLDERS=(
			"data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "InvokeAI" ]]; then
		FOLDERS=(
			"data"
			"models/anything-llm_models"
			"models/localai_models"
			"models/ollama_models"
			"models/comfyui_models"
			"models/forge_models"
			"outputs/anything-llm_output"
			"outputs/localai_output"
			"outputs/ollama_output"
			"outputs/comfyui_output"
			"outputs/forge_output"
			"outputs/motioneye_shared"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "homeassistant" ]]; then
		FOLDERS=(
			"config"
			"media"
			"recordings"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"
	fi

	if [[ ${SERVICE_NAME} == "letta-server" ]]; then
		FOLDERS=(
			"data"
			"tool_execution_dir"
		)
	fi

	if [[ ${SERVICE_NAME} == "localai" ]]; then
		FOLDERS=(
			"cache"
			"configuration"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

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

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "open-webui" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "searxng" ]]; then
		FOLDERS=(
			"data"
			"cache"
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

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

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
		if [[ ${USER} == "hans" ]]; then
			docker compose -f base.hans.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
		else
			docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
		fi
	elif [[ ${BUILDING} == "true" ]] || [[ ${BUILDING} == "normal" ]]; then
		if [[ ${USER} == "hans" ]]; then
			docker compose -f base.hans.docker-compose.yaml ${ARGS} up -d
		else
			docker compose -f base.docker-compose.yaml ${ARGS} up -d
		fi
	elif [[ ${BUILDING} == "false" ]]; then
		echo "Skipping docker compose up"
	fi

}

BUILDING
