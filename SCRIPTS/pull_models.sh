#!/bin/bash
# set -e

models=(
	'aya-expanse:latest'
	'cogito:latest'
	'devstral-small-2:latest'
	'functiongemma:latest'
	'glm-4.7-flash:latest'
	'glm-ocr:latest'
	'gpt-oss:latest'
	'granite3-moe:latest'
	'granite3.2-vision:latest'
	'granite3.2:latest'
	'granite4:latest'
	'lfm2:latest'
	'lfm2.5-thinking:latest'
	'llama3-groq-tool-use:latest'
	'llama3:latest'
	'llama3.1:latest'
	'llama3.2:latest'
	'llava-phi3:latest'
	'llava:latest'
	'magistral:latest'
	'ministral-3:latest'
	'mistral-small:latest'
	'mistral-small3.2:latest'
	'mistral:latest'
	'moondream:latest'
	'nemotron-3-nano:30b'
	'nemotron-mini:latest'
	'odendaalkappie/weskus:latest'
	'paraphrase-multilingual:latest'
	'phi4-mini:latest'
	'phi4:latest'
	'qwen2.5-coder:7b'
	'qwen2.5:latest'
	'qwen3-coder:latest'
	'qwen3-vl:latest'
	'qwen3:latest'
	'qwen3.5:latest'
	'qwq:latest'
	'rnj-1:latest'
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
add_fallbacks.sh