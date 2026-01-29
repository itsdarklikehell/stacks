#!/bin/bash
# set -e

export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	anything-llm
	ComfyUI
	habridge
	homeassistant
	InvokeAI
	letta-mcp-server
	letta-server
	localai
	n8n
	ollama
	pygotchi
	open-webui
	# puppeteer
	searxng
	SwarmUI
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

		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"storage"
			"prompts"
			"vectorstores"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "InvokeAI" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"data"
			"models/anything-llm_models"
			"models/localai_models"
			"models/ollama_models"
			"models/ComfyUI_models"
			"outputs/anything-llm_output"
			"outputs/localai_output"
			"outputs/ollama_output"
			"outputs/ComfyUI_output"
			"outputs/motioneye_shared"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "homeassistant" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"config"
			"media"
			"recordings"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"
	fi

	if [[ ${SERVICE_NAME} == "letta-server" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"data"
			"tool_execution_dir"
		)
	fi

	if [[ ${SERVICE_NAME} == "localai" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"cache"
			"configuration"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "n8n" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"data"
			"local_files"
		)
	fi

	if [[ ${SERVICE_NAME} == "ollama" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"data"
		)

		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/${SERVICE_NAME}_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/${SERVICE_NAME}_output"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-models/${SERVICE_NAME}_models"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-inputs/ComfyUI_input"
		mkdir -p "${STACK_BASEPATH}/DATA/ai-outputs/ComfyUI_output"
		mkdir -p "${STACK_BASEPATH}/DATA/books-stack/motioneye/motioneye_shared"

	fi

	if [[ ${SERVICE_NAME} == "open-webui" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"data"
		)
	fi

	if [[ ${SERVICE_NAME} == "habridge" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"config"
		)
	fi

	if [[ ${SERVICE_NAME} == "searxng" ]]; then
		declare -a FOLDERS=()
		FOLDERS=(
			"data"
			"cache"
		)
	fi

	if [[ ${SERVICE_NAME} == "SwarmUI" ]]; then
		declare -a FOLDERS=()
		# FOLDERS=(
		# 	"backend"
		# 	"data"
		# 	"dlnodes"
		# 	"extensions"
		# 	"config"
		# 	"embeddings"
		# 	"workflows"
		# )

		if [[ -d "${STACK_BASEPATH}/DATA/SwarmUI/.git" ]]; then
			git pull
		else
			git clone --recursive https://github.com/mcmonkeyprojects/SwarmUI.git "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-SwarmUI" "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}/Dockerfile"
		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerignore-SwarmUI" "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}/.dockerignore"

	fi

	if [[ ${SERVICE_NAME} == "ComfyUI" ]]; then
		declare -a FOLDERS=()
		# FOLDERS=(
		# 	"models"
		# 	"output"
		# 	"input"
		# 	"custom_nodes"
		# )

		if [[ -d "${STACK_BASEPATH}/DATA/ComfyUI/.git" ]]; then
			git pull
		else
			git clone --recursive https://github.com/comfyanonymous/ComfyUI.git "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-ComfyUI" "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}/Dockerfile"
		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerignore-ComfyUI" "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}/.dockerignore"

	fi

	if [[ ${SERVICE_NAME} == "pygotchi" ]]; then
		declare -a FOLDERS=()
		# FOLDERS=(
		# 	"models"
		# 	"output"
		# 	"input"
		# 	"custom_nodes"
		# )

		if [[ -d "${STACK_BASEPATH}/DATA/ai-stack/pygotchi/.git" ]]; then
			git pull
		else
			git clone --recursive https://github.com/almarch/pygotchi.git "${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}"
		fi

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
