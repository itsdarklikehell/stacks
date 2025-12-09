#!/bin/bash
echo "Working directory is set to ${WD}"
cd "${WD}" || exit

models=(
	'all-minilm:latest'
	'bge-m3:latest'
	'codellama:latest'
	'deepseek-r1:latest'
	'dolphin3:latest'
	'embeddinggemma:latest'
	'falcon3:latest'
	'gemma3:latest'
	'llama3.2:latest'
	'mistral-small:latest'
	'mistral:latest'
	'mxbai-embed-large:latest'
	'nomic-embed-text:latest'
	'olamo2:latest'
	'phi3:latest'
	'qwen2.5:latest'
	'qwen3-vl:latest'
	'qwen3:4b'
	'qwen3:8b'
	'qwen3:latest'
	'smallthinker:latest'
	'smollm2:latest'
	'tinyllama:latest'
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
