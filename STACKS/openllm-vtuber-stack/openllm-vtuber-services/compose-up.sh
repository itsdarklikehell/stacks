#!/bin/bash
# set -e

cd "$(dirname "$0")" || exit 1

sudo apt install -y # unison # unison-gtk

COMPOSE_FILES=(
	openllm-vtuber
	# openllm-vtuber-webtop
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
			"chat_history"
			"live2d-models"
			"logs"
			"models"
			"prompts"
		)

		CREATE_FOLDERS

		SOURCE_FOLDER="${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}" || exit 1

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}" "${SOURCE_FOLDER}/Dockerfile"

		# if [[ ! -f "${FOLDER}/conf.yaml" ]]; then

		if [[ ${USER} == "hans" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-hans-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-hans-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
		elif [[ ${USER} == "rizzo" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
		else
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
		fi

		# fi

		# if [[ ! -f "${FOLDER}/mcp_servers.json" ]]; then

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/mcp_servers.json"

		# fi

		# if [[ ! -f "${FOLDER}/model_dict.json" ]]; then

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/model_dict.json"

		# fi

		if [[ -d "${FOLDER}/avatars" ]]; then

			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/avatars-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/avatars/"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/avatars-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/avatars/"
			# # unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/avatars-${SERVICE_NAME}" "${SOURCE_FOLDER}/avatars"
		fi

		if [[ -d "${FOLDER}/backgrounds" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/backgrounds-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/backgrounds/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/backgrounds-${SERVICE_NAME}" "${SOURCE_FOLDER}/backgrounds"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/backgrounds-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/backgrounds/"
		fi

		if [[ -d "${FOLDER}/characters" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/characters/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}" "${SOURCE_FOLDER}/characters"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/characters/"

		fi

		if [[ -d "${FOLDER}/chat_history" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/chat_history-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/chat_history/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/chat_history-${SERVICE_NAME}" "${SOURCE_FOLDER}/chat_history"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/chat_history-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/chat_history/"

		fi

		if [[ -d "${FOLDER}/live2d-models" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/live2d-models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/live2d-models/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/live2d-models-${SERVICE_NAME}" "${SOURCE_FOLDER}/live2d-models"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/live2d-models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/live2d-models/"

		fi

		if [[ -d "${FOLDER}/logs" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/logs-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/logs/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/logs-${SERVICE_NAME}" "${SOURCE_FOLDER}/logs"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/logs-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/logs/"

		fi

		if [[ -d "${FOLDER}/models" ]]; then

			# wget -c https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2 -O "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2"
			# tar xvf "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2" -C "${SOURCE_FOLDER}/models"
			# rm "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2"

			# wget -c https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2 -O "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2"
			# tar xvf "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2" -C "${SOURCE_FOLDER}/models"
			# rm "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2"

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/models/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}" "${SOURCE_FOLDER}/models"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/models/"

		fi

		if [[ -d "${FOLDER}/prompts" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/prompts/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}" "${SOURCE_FOLDER}/prompts"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/prompts/"

		fi

		if [[ -d "${FOLDER}/scripts" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/scripts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/scripts/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/scripts-${SERVICE_NAME}" "${SOURCE_FOLDER}/scripts"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/scripts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/scripts/"

		fi

	fi

	if [[ ${SERVICE_NAME} == "openllm-vtuber-webtop" ]]; then
		SERVICE_NAME="openllm-vtuber"

		# FOLDERS=(
		# 	"avatars"
		# 	"backgrounds"
		# 	"characters"
		# 	"chat_history"
		# 	"live2d-models"
		# 	"logs"
		# 	"models"
		# 	"prompts"
		# )
		# CREATE_FOLDERS

		SOURCE_FOLDER="${STACK_BASEPATH}/DATA/${STACK_NAME}-stack/${SERVICE_NAME}" || exit 1

		cp -rf "${STACK_BASEPATH}/SCRIPTS/Dockerfile-${SERVICE_NAME}-webtop" "${SOURCE_FOLDER}/Dockerfile-webtop"

		# if [[ ! -f "${FOLDER}/conf.yaml" ]]; then

		if [[ ${USER} == "hans" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-hans-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-hans-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
		elif [[ ${USER} == "rizzo" ]]; then
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
		else
			cp -rf "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/conf-base-${SERVICE_NAME}.yaml" "${SOURCE_FOLDER}/conf.yaml"
		fi

		# fi

		# if [[ ! -f "${FOLDER}/mcp_servers.json" ]]; then

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/mcp_servers-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/mcp_servers.json"

		# fi

		# if [[ ! -f "${FOLDER}/model_dict.json" ]]; then

		rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/model_dict-${SERVICE_NAME}.json" "${SOURCE_FOLDER}/model_dict.json"

		# fi

		if [[ -d "${FOLDER}/avatars" ]]; then

			rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/avatars-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/avatars/"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/avatars-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/avatars/"
			# # unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/avatars-${SERVICE_NAME}" "${SOURCE_FOLDER}/avatars"
		fi

		if [[ -d "${FOLDER}/backgrounds" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/backgrounds-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/backgrounds/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/backgrounds-${SERVICE_NAME}" "${SOURCE_FOLDER}/backgrounds"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/backgrounds-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/backgrounds/"
		fi

		if [[ -d "${FOLDER}/characters" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/characters/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}" "${SOURCE_FOLDER}/characters"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/characters-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/characters/"

		fi

		if [[ -d "${FOLDER}/chat_history" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/chat_history-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/chat_history/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/chat_history-${SERVICE_NAME}" "${SOURCE_FOLDER}/chat_history"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/chat_history-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/chat_history/"

		fi

		if [[ -d "${FOLDER}/live2d-models" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/live2d-models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/live2d-models/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/live2d-models-${SERVICE_NAME}" "${SOURCE_FOLDER}/live2d-models"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/live2d-models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/live2d-models/"

		fi

		if [[ -d "${FOLDER}/logs" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/logs-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/logs/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/logs-${SERVICE_NAME}" "${SOURCE_FOLDER}/logs"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/logs-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/logs/"

		fi

		if [[ -d "${FOLDER}/models" ]]; then

			# wget -c https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2 -O "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2"
			# tar xvf "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2" -C "${SOURCE_FOLDER}/models"
			# rm "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2"

			# wget -c https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2 -O "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2"
			# tar xvf "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2" -C "${SOURCE_FOLDER}/models"
			# rm "${SOURCE_FOLDER}/models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2025-09-09.tar.bz2"

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/models/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}" "${SOURCE_FOLDER}/models"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/models-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/models/"

		fi

		if [[ -d "${FOLDER}/prompts" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/prompts/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}" "${SOURCE_FOLDER}/prompts"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/prompts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/prompts/"

		fi

		if [[ -d "${FOLDER}/scripts" ]]; then

			# rsync -aHAX "${STACK_BASEPATH}/SCRIPTS/scripts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/scripts/"
			# unison -batch -auto "${STACK_BASEPATH}/SCRIPTS/scripts-${SERVICE_NAME}" "${SOURCE_FOLDER}/scripts"
			cp -rf "${STACK_BASEPATH}/SCRIPTS/scripts-${SERVICE_NAME}"/* "${SOURCE_FOLDER}/scripts/"

		fi

	fi

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
