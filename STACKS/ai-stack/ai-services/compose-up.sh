#!/bin/bash

set -e
cd "$(dirname "$0")"

COMPOSE_FILES=(
	# ai-dock-comfyui
	# ai-dock-fooocus
	# ai-dock-forge
	# ai-dock-kohya
	# ai-dock-sd-webui
	anything-llm
	# automatic1111
	# big-agi
	# ComfyUI
	homeassistant
	InvokeAI
	letta-mcp-server
	letta-server
	localai
	forge
	# n8n
	ollama
	open-webui
	# puppeteer
	searxng
	# stable-diffusion-webui
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
	if [[ "${SERVICE_NAME}" == "anything-llm" ]]; then

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

	fi

	if [[ "${SERVICE_NAME}" == "stable-diffusion-webui" ]]; then
		FOLDERS=(
			"configdir"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "ComfyUI" ]]; then
		FOLDERS=(
			"common_storage"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "ai-dock-comfyui" ]]; then
		FOLDERS=(
			"data"
			"models"
			"output"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "ai-dock-fooocus" ]]; then
		FOLDERS=(
			"data"
			"models"
			"output"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "ai-dock-forge" ]]; then
		FOLDERS=(
			"data"
			"models"
			"output"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "ai-dock-kohya" ]]; then
		FOLDERS=(
			"data"
			"models"
			"output"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "ai-dock-forge" ]]; then
		FOLDERS=(
			"data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "forge" ]]; then
		FOLDERS=(
			"data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "automatic1111" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ "${SERVICE_NAME}" == "InvokeAI" ]]; then
		FOLDERS=(
			"data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "basic-memory" ]]; then
		FOLDERS=(
			"config"
			"knowledge"
			"personal-notes"
			"work-notes"
		)
	fi

	if [[ "${SERVICE_NAME}" == "homeassistant" ]]; then
		FOLDERS=(
			"config"
			"media"
			"recordings"
		)

		# ln -s "$(xdg-user-dir MUSIC)" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/Music"

		# ln -s "$(xdg-user-dir DOCUMENTS)" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/Documents"

		# ln -s "$(xdg-user-dir VIDEOS)" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/Videos"

		# ln -s "$(xdg-user-dir PICTURES)" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/Pictures"

		# ln -s "$(xdg-user-dir DOWNLOADS)" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/Downloads"

		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/localai_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/localai_input"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/InvokeAI_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/InvokeAI_input"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/variety" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/variety"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/swarmui_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/swarmui_input"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/ollama_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/ollama_input"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/forge_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/forge_input"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/comfyui_input"
		# ln -s "${STACK_BASEPATH}/DATA/ai-inputs/anything-llm_input" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/anything-llm_input"

		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/localai_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/localai_output"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/InvokeAI_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/InvokeAI_output"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/variety" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/variety"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/swarmui_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/swarmui_output"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/ollama_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/ollama_output"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/forge_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/forge_output"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/comfyui_output"
		# ln -s "${STACK_BASEPATH}/DATA/ai-outputs/anything-llm_output" "${STACK_BASEPATH}/DATA/ai-stack/homeassistant/homeassistant_media/anything-llm_output"
	fi

	if [[ "${SERVICE_NAME}" == "letta-server" ]]; then
		FOLDERS=(
			"data"
			"tool_execution_dir"
		)
	fi

	if [[ "${SERVICE_NAME}" == "librechat" ]]; then
		FOLDERS=(
			"vectordb_data"
			"mongo_data"
			"images"
			"uploads"
			"logs"
			"meili_data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "localai" ]]; then
		FOLDERS=(
			"cache"
			"configuration"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "n8n" ]]; then
		FOLDERS=(
			"data"
			"local_files"
		)
	fi

	if [[ "${SERVICE_NAME}" == "ollama" ]]; then
		FOLDERS=(
			"data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/comfyui_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/comfyui_output"

	fi

	if [[ "${SERVICE_NAME}" == "open-webui" ]]; then
		FOLDERS=(
			"data"
		)
	fi

	if [[ "${SERVICE_NAME}" == "searxng" ]]; then
		FOLDERS=(
			"data"
			"cache"
		)
	fi

	if [[ "${SERVICE_NAME}" == "swarmui" ]]; then
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
	if [[ "${BUILDING}" == "force_rebuild" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d --build --force-recreate --remove-orphans
	elif [[ "${BUILDING}" == "true" ]] || [[ "${BUILDING}" == "normal" ]]; then
		docker compose -f base.docker-compose.yaml ${ARGS} up -d
	elif [[ "${BUILDING}" == "false" ]]; then
		echo "Skipping docker compose up"
	fi
}
BUILDING
