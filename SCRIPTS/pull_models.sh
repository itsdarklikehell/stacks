#!/bin/bash
# set -e

models=(
	'artifish/llama3.2-uncensored:latest'
	'deepseek-r1:latest'
	'dolphin-mistral:latest'
	'dolphin-mixtral:latest'
	'dolphin-phi:latest'
	'embeddinggemma:latest'
	'gemma3:latest'
	'gpt-oss:latest'
	'huihui_ai/deepseek-r1-abliterated:latest'
	'huihui_ai/gemma3-abliterated:latest'
	'huihui_ai/qwen3-abliterated:latest'
	'llama2-uncensored:latest'
	'llama3.2:latest'
	'llava-phi3:latest'
	'llava:latest'
	'moondream:latest'
	'qwen3:latest'
	'smallthinker:latest'
	'smollm2:latest'
)

# container_name to check if ollama docker service is running:
container_name="ollama"
PULL_MODELS() {

	for model in "${models[@]}"; do
		echo "Pulling model: ${model}"

		if command -v ollama >/dev/null 2>&1; then
			ollama pull "${model}" # >/dev/null 2>&1
		elif docker inspect "${container_name}" >/dev/null 2>&1; then
			echo "The container ${container_name} exists."

			if docker inspect -f '{{.State.Status}}' "${container_name}" | grep -q "running" || true; then
				docker exec -i "${container_name}" sh -c "ollama pull ${model}"
			else
				echo "The container ${container_name} is not running."
				docker start "${container_name}"
			fi

		else
			echo "The container ${container_name} does not exist."
		fi

	done

}

REMOVE_MODELS() {

	for model in "${models[@]}"; do
		echo "Removing model: ${model}"

		if command -v ollama >/dev/null 2>&1; then
			ollama rm "${model}" # >/dev/null 2>&1
		elif docker inspect "${container_name}" >/dev/null 2>&1; then
			echo "The container ${container_name} exists."

			if docker inspect -f '{{.State.Status}}' "${container_name}" | grep -q "running" || true; then
				docker exec -i "${container_name}" sh -c "ollama rm ${model}"
			else
				echo "The container ${container_name} is not running."
				docker start "${container_name}"
			fi

		else
			echo "The container ${container_name} does not exist."
		fi

	done

}

# REMOVE_MODELS

PULL_MODELS
