#!/bin/bash

models=(
	'codellama:latest'
	'deepseek-r1:latest'
	'embeddinggemma:latest'
	'gemma3:latest'
	'llama3.2:latest'
	'mxbai-embed-large:latest'
	'nomic-embed-text:latest'
	'qwen2.5:latest'
)

# container_name to check if ollama docker service is running:
container_name="ollama"

PULL_MODELS() {
	for model in "${models[@]}"; do
		echo "Pulling model: ${model}"
		if command -v ollama >/dev/null 2>&1; then
			ollama pull "${model}" # >/dev/null 2>&1
		fi

		if docker inspect "${container_name}" >/dev/null 2>&1; then
			echo "The container ${container_name} exists."
			if docker inspect -f '{{.State.Status}}' "${container_name}" | grep -q "running" || true; then
				docker exec -it "${container_name}" sh -c "ollama pull ${model}"
			else
				echo "The container ${container_name} is not running."
				docker start "${container_name}"
			fi
		else
			echo "The container ${container_name} does not exist."
			# source ai-stack/ai-services/ollama/.env
			# Create and start the container if it does not exist

			# docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

			# docker compose -f ai-stack/ai-services/base.docker-compose.yaml -f ai-stack/ai-services/ollama/docker-compose.yaml
		fi
	done
}

PULL_MODELS
