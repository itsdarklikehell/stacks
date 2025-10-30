#!/bin/bash
echo "Working directory is set to ${WD}"
cd "${WD}" || exit
models=(
	'embeddinggemma:latest'
	'gemma3:latest'
	'llama3.2:latest'
	'nomic-embed-text:latest'
	'smallthinker:latest'
	# 'adi0adi/ollama_stheno-8b_v3.1_q6k:latest'
	# 'aiden_lu/peach-9b-8k-roleplay:latest'
	# 'ALIENTELLIGENCE/roleplaymaster:latest'
	# 'antonos9/roleplay:latest'
	# 'BlackDream/blue-orchid-2x7b:latest'
	# 'codellama:latest'
	# 'deepseek-coder'
	# 'deepseek-r1'
	# 'gpt-oss:120b'
	# 'gpt-oss:20b'
	# 'granite:latest'
	# 'gurubot/pivot-roleplay-v0.2:latest'
	# 'jimscard/adult-film-screenwriter-nsfw:latest'
	# 'kingzeus/llama-3.1-8b-darkidol:latest'
	# 'kubernetes_bad/chargen-v2:latest'
	# 'leeplenty/ellaria:latest'
	# 'llama3.2-coder:latest'
	# 'magistral:latest'
	# 'mgistral:latest'
	# 'mistral:7b-instruct'
	# 'mistral:latest'
	# 'mxbai-embed-large'
	# 'nchapman/mn-12b-inferor-v0.0:latest'
	# 'nchapman/mn-12b-mag-mell-r1:latest'
	# 'nemotron-mini:latest'
	# 'Plexi09/SentientAI:latest'
	# 'qwen2.5-coder:32b'
	# 'qwen2.5:latest'
	# 'qwen3:4b'
	# 'qwen3:8b'
	# 'qwen3:latest'
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
