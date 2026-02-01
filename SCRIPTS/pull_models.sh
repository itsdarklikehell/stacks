#!/bin/bash
# set -e

models=(
	# --- Coding Kampioenen (Chat & Autocomplete) ---
	'qwen2.5-coder:latest'
	'qwen2.5-coder:32b'
	'qwen2.5-coder:14b'
	'qwen2.5-coder:7b'
	'qwen2.5-coder:1.5b-base'
	'qwen3-coder:latest'
	'codestral:latest'
	'deepseek-coder-v2:16b-lite-instruct'
	'deepseek-coder:1.3b-base'
	'yi-coder:latest'
	'codegemma:latest'
	'granite-code:latest'
	'starcoder2:latest'
	'codellama:latest'

	# --- Reasoning & Logic (Deep Thinking) ---
	'deepseek-r1:latest'
	'deepseek-v3:latest'
	'smallthinker:latest'
	'marco-o1:latest'
	'opencoder:latest'

	# --- Uncensored & Abliterated (Vrije output) ---
	'artifish/llama3.2-uncensored:latest'
	'huihui_ai/deepseek-r1-abliterated:latest'
	'huihui_ai/qwen3-abliterated:latest'
	'huihui_ai/smallthinker-abliterated:latest'
	'llama2-uncensored:latest'
	'dolphin-mistral:latest'
	'dolphin-mixtral:latest'
	'dolphin-phi:latest'

	# --- General Purpose & Vision ---
	'llama3.3:latest'
	'gemma3:latest'
	'qwen3:latest'
	'smollm2:latest'
	'llava:latest'
	'llava-phi3:latest'
	'moondream:latest'

	# --- Embeddings & Utilities ---
	'nomic-embed-text:latest'
	'mxbai-embed-large:latest'
	'embeddinggemma:latest'

	# --- Long Context & Full Repository Analysis ---
	'phi4:latest'
	'command-r:latest'
	'command-r7b:latest'

	# --- Tool Use & Function Calling Specialists ---
	'mistral-small:latest'
	'hermes3:latest'

	# --- Cutting Edge (New Releases 2025/2026) ---
	'exaone:latest'
	'athene-v2:latest'
	'nemotron:latest'

	# --- Ultra-Lightweight & Specialised ---
	'llama3.2:1b'
	'stable-code:latest'
	'sqlcoder:latest'
	'phind-codellama:latest'

	# --- Security, DevOps & Data ---
	'hubert234/llama3-70b-instruct-scan:latest'
	'ops-pilot:latest'
	'duckdb-nsql:latest'
	'open-interpreter:latest'

	# --- Architectuur & Reasoning Varianten ---
	'architect:latest'
	'merit/code-explainer:latest'
	'bespoke-minerva:latest'
	'reflection:latest'
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
