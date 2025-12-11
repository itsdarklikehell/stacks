#!/bin/bash

models=(
	'aeline/Omega:latest'
	'orca-mini:latest'
	'codellama:latest'
	'deepseek-r1:latest'
	'dolphin-mistral:latest'
	'dolphin-mixtral:latest'
	'dolphin-phi:latest'
	'dolphincoder:latest'
	'embeddinggemma:latest'
	'everythinglm:latest'
	'gemma3:latest'
	'goonsai/qwen2.5-3b-goonsai-nsfw-100k:latest'
	'gurubot/llama3-alpha-centauri-uncensored:latest'
	'huihui_ai/deepseek-r1-abliterated:latest'
	'huihui_ai/gemma3-abliterated:latest'
	'huihui_ai/huihui-moe-abliterated:latest'
	'huihui_ai/jan-nano-abliterated:latest'
	'huihui_ai/mirothinker1-abliterated:8b'
	'huihui_ai/orchestrator-abliterated:latest'
	'huihui_ai/qwen3-abliterated:latest'
	'jaahas/gemma-2-9b-it-abliterated:latest'
	'jimscard/adult-film-screenwriter-nsfw:latest'
	'llama3.2:latest'
	'mdq100/Gemma3-Instruct-Abliterated:12b'
	'mdq100/Gemma3-Instruct-Abliterated:12b'
	'MrTails/Tails-assistant-ai-v3.0.0:latest'
	'mxbai-embed-large:latest'
	'nomic-embed-text:latest'
	'openchat:latest'
	'qwen2.5:latest'
	'redule26/huihui_ai_qwen2.5-vl-7b-abliterated:latest'
	'smallthinker:latest'
	'wizard-vicuna-uncensored:latest'
)
# 'huihui_ai/qwq-abliterated:latest'
# 'huihui_ai/tongyi-deepresearch-abliterated:latest'

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
