#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	openllm-vtuber
)

function CREATE_FOLDERS() {
	for FOLDERNAME in "${FOLDERS[@]}"; do
		if [[ ! -d "${FOLDER}/${FOLDERNAME}" ]]; then
			echo "Creating folder: ${FOLDER}/${FOLDERNAME}"
			mkdir -p "${FOLDER}/${FOLDERNAME}"
		# else
		# 	echo "Folder already exists: ${FOLDER}/${FOLDERNAME}, skipping creation"
		fi
	done
}

function SETUP_FOLDERS() {

	if [[ ${SERVICE_NAME} == "openllm-vtuber" ]]; then

		FOLDERS=(
			"avatars"
			"backgrounds"
			"characters"
			"models"
			"chat_history"
			"live2d-models"
			"logs"
			"prompts"
		)

		SOURCE_FOLDER="${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}" || exit 1

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/models"

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/prompts"
		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/characters"

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${SOURCE_FOLDER}/Dockerfile"
		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/autostart-${SERVICE_NAME}.sh" "${SOURCE_FOLDER}/autostart.sh"
		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/mcp_servers.json"
		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/model_dict.json"

		if [[ ! -d "${FOLDER}/models" ]]; then
			mkdir -p "${SOURCE_FOLDER}/models"
			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/models"
		fi

		if [[ ! -d "${FOLDER}/prompts" ]]; then
			mkdir -p "${SOURCE_FOLDER}/prompts"
			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/prompts"
		fi

		if [[ ! -d "${FOLDER}/characters" ]]; then
			mkdir -p "${SOURCE_FOLDER}/characters"
			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/characters"
		fi

		if [[ ! -f "${FOLDER}/Dockerfile" ]]; then
			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${SOURCE_FOLDER}/Dockerfile"
		fi

		if [[ ! -f "${FOLDER}/conf.yaml" ]]; then
			if [[ ${USER} == "hans" ]]; then
				rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-hans-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			elif [[ ${USER} == "rizzo" ]]; then
				rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			else
				rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			fi
		fi

		if [[ ! -f "${FOLDER}/mcp_servers.json" ]]; then
			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/mcp_servers.json"
		fi

		if [[ ! -f "${FOLDER}/model_dict.json" ]]; then
			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/model_dict.json"
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
