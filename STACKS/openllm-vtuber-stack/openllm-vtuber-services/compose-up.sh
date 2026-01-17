#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

COMPOSE_FILES=(
	openllm-vtuber
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

	if [[ ${SERVICE_NAME} == "openllm-vtuber" ]]; then

		FOLDERS=(
			"config"
			"data"
			"logs"
		)

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${FOLDER}/Dockerfile"

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}/Dockerfile" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${FOLDER}/Dockerfile"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/autostart-${SERVICE_NAME}.sh" "${FOLDER}/autostart.sh"

		if [[ ! -f "${FOLDER}/${SERVICE_NAME}/autostart.sh" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/autostart-${SERVICE_NAME}.sh" "${FOLDER}/autostart.sh"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-${SERVICE_NAME}.yaml" "${FOLDER}/conf.yaml"

		if [[ ! -f "${STACK_BASEPATH}/SCRIPTS/conf-${SERVICE_NAME}.yaml" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-${SERVICE_NAME}.yaml" "${FOLDER}/conf.yaml"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" "${FOLDER}/mcp_servers.json"

		if [[ ! -f "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" "${FOLDER}/mcp_servers.json"
		fi

		cp -rf "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" "${FOLDER}/mcp_servers.json"

		if [[ ! -f "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" "${FOLDER}/model_dict.json"
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
