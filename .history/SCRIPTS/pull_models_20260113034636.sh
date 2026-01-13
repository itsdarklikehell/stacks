#!/bin/bash
# set -e

models=(
	'artifish/llama3.2-uncensored:latest'
	'deepseek-r1:latest'
	'dolphin-mistral:latest'
	'dolphin-mixtral:latest'
	'dolphin-phi:latest'
	'embeddinggemma:latest'
	'smallthinker:latest'
	'gpt-oss:latest'
	'huihui_ai/deepseek-r1-abliterated:latest'
	'huihui_ai/smallthinker-abliterated:latest'
	'huihui_ai/qwen3-abliterated:latest'
	'llama2-uncensored:latest'
	'llama3.2:latest'
	'llava-phi3:latest'
	'llava:latest'
	'moondream:latest'
	'qwen2.5:latest'
	'qwen3:latest'
	'smallthinker:latest'
	'smollm2:latest'
)

# ollama_container_name to check if ollama docker service is running:
ollama_container_name="ollama"
PULL_MODELS() {

	for model in "${models[@]}"; do
		echo "Pulling model: ${model}"

		if command -v ollama >/dev/null 2>&1; then
			ollama pull "${model}" # >/dev/null 2>&1
		elif docker inspect "${ollama_container_name}" >/dev/null 2>&1; then
			echo "The container ${ollama_container_name} exists."

			if docker inspect -f '{{.State.Status}}' "${ollama_container_name}" | grep -q "running" || true; then
				docker exec -i "${ollama_container_name}" sh -c "ollama pull ${model}"
			else
				echo "The container ${ollama_container_name} is not running."
				docker start "${ollama_container_name}"
			fi

		else
			echo "Neither command ollama nor the container for ollama exists."
		fi

	done

}

REMOVE_MODELS() {

	for model in "${models[@]}"; do
		echo "Removing model: ${model}"

		if command -v ollama >/dev/null 2>&1; then
			ollama rm "${model}" # >/dev/null 2>&1
		elif docker inspect "${ollama_container_name}" >/dev/null 2>&1; then
			echo "The container ${ollama_container_name} exists."

			if docker inspect -f '{{.State.Status}}' "${ollama_container_name}" | grep -q "running" || true; then
				docker exec -i "${ollama_container_name}" sh -c "ollama rm ${model}"
			else
				echo "The container ${ollama_container_name} is not running."
				docker start "${ollama_container_name}"
			fi

		else
			echo "The container ${ollama_container_name} does not exist."
		fi

	done

}

# REMOVE_MODELS

PULL_MODELS

