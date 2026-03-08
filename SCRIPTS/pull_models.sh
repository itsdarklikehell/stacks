#!/bin/bash
# set -e

models=(
	'glm-5:cloud'
	'kimi-k2.5:cloud'
	'minimax-m2.5:cloud'
	'glm-4.7-flash:latest'
	'glm-ocr:latest'
	'qwen3:latest'
	'qwen3:8b'
	'qwen3:4b'
	'qwen2.5:7b'
	'qwen3-coder:latest'
	'qwen2.5-coder:7b'
	'qwen3-vl:latest'
	'llama3.2:latest'
	'llama3.2:3b'
	'llama3.2:8b'
	'llama3.2-vision:latest'
	'nemotron-mini:4b'
	'glm4:9b'
	'gpt-oss:latest'
	'mistral-nemo:latest'
	'ministral-3:latest'
	'mistral-small3.2:latest'
	'granite4:latest'
	'magistral:latest'
	# 'artifish/llama3.2-uncensored:latest'
	# 'huihui_ai/smallthinker-abliterated:latest'
	# 'huihui_ai/qwen3-abliterated:latest'
	# 'huihui_ai/deepseek-r1-abliterated:latest'
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
