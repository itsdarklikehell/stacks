#!/bin/bash
echo "Working directory is set to ${WD}"
cd "${WD}" || exit

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

for model in "${models[@]}"; do
	echo "Pulling model: ${model}"
	if command -v ollama >/dev/null 2>&1; then
		ollama pull "${model}" # >/dev/null 2>&1
	fi
	if docker inspect "ollama" >/dev/null 2>&1; then
		if docker inspect -f '{{.State.Status}}' "ollama" | grep -q "running" || true; then
			docker exec -it ollama sh -c "ollama pull ${model}"
		else
			echo "The container ollama is not running."
			docker start "ollama"
		fi
	else
		echo "The container ollama does not exist."
		# source ai-stack/ai-services/ollama/.env
		# Create and start the container if it does not exist

		# docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

		# docker compose -f ai-stack/ai-services/base.docker-compose.yaml -f ai-stack/ai-services/ollama/docker-compose.yaml
	fi
done
