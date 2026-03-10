#!/bin/bash
# set -e

models=(
	'all-minilm:latest'
	'aya-expanse:latest'
	'bakllava:latest'
	'bge-large:latest'
	'bge-m3:latest'
	'cogito-2.1:671b-cloud'
	'cogito:latest'
	'command-r7b:latest'
	'deepseek-coder-v2:16b'
	'deepseek-ocr:latest'
	'deepseek-r1:1.5b'
	'deepseek-r1:7b'
	'deepseek-r1:8b'
	'deepseek-v3.1:671b-cloud'
	'deepseek-v3.2:cloud'
	'devstral-2:123b-cloud'
	'devstral-small-2:24b-cloud'
	'devstral-small-2:latest'
	'dolphin-llama3:8b'
	'embeddinggemma:latest'
	'erukude/multiagent-orchestrator:3b'
	'exaone-deep:latest'
	'exaone3.5:latest'
	'falcon3:7b'
	'functiongemma:latest'
	'gemini-3-flash-preview:cloud'
	'gemma2:9b'
	'gemma3:4b-cloud'
	'gemma3:4b'
	'gemma3:latest'
	'glm-4.6:cloud'
	'glm-4.7-flash:latest'
	'glm-4.7:cloud'
	'glm-5:cloud'
	'glm-ocr:latest'
	'glm4:9b'
	'gpt-oss:20b-cloud'
	'gpt-oss:latest'
	'granite-code:8b'
	'granite-embedding:latest'
	'granite3-dense:latest'
	'granite3-moe:latest'
	'granite3.2-vision:latest'
	'granite3.2:latest'
	'granite4:latest'
	'hermes3:latest'
	'huggingface.co/adamo1139/Danube3-4b-4chan-HESOYAM-2510-GGUF:latest'
	'huggingface.co/bartowski/DeepSeek-R1-Distill-Llama-8B-GGUF:Q4_K_M'
	'huggingface.co/bartowski/L3-8B-Niitama-v1-GGUF:Q4_K_M'
	'huggingface.co/bartowski/Llama-3.1-8B-Instruct-Abliterated-GGUF:Q4_K_M'
	'huggingface.co/bartowski/Ministral-8B-Instruct-2410-GGUF:Q4_K_M'
	'huggingface.co/bartowski/Mistral-Nemo-12B-v1-GGUF:Q4_K_S'
	'huggingface.co/bartowski/MN-3B-Translate-v1-GGUF:Q8_0'
	'huggingface.co/bartowski/OpenHermes-2.5-Mistral-7B-GGUF:Q5_K_M'
	'huggingface.co/mdq100/Gemma3-Instruct-Abliterated:12b-Q4_K_M'
	'huggingface.co/mradermacher/GPT4chan-8B-GGUF:latest'
	'huggingface.co/SicariusSicariiStuff/Assistant_Pepe_8B_GGUF:latest'
	'jaahas/crow:latest'
	'kimi-k2-thinking:cloud'
	'kimi-k2:1t-cloud'
	'kimi-k2.5:cloud'
	'lfm2:latest'
	'lfm2.5-thinking:latest'
	'llama3-groq-tool-use:latest'
	'llama3.1:8b'
	'llama3.1:latest'
	'llama3.2-vision:latest'
	'llama3.2:1b'
	'llama3.2:3b'
	'llama3.2:8b'
	'llama3.2:latest'
	'llama3.3:latest'
	'llava-phi3:latest'
	'llava:latest'
	'magistral:latest'
	'minimax-m2:cloud'
	'minimax-m2.1:cloud'
	'minimax-m2.5:cloud'
	'ministral-3:8b-cloud'
	'ministral-3:latest'
	'mistral-large-3:675b-cloud'
	'mistral-nemo:12b'
	'mistral-nemo:latest'
	'mistral-small:22b'
	'mistral-small:24b'
	'mistral-small:latest'
	'mistral-small3.2:latest'
	'mistral:7b'
	'mistral:latest'
	'moondream:latest'
	'mxbai-embed-large:latest'
	'nemotron-3-nano:30b-cloud'
	'nemotron-3-nano:30b'
	'nemotron-mini:4b'
	'nemotron-mini:latest'
	'nomic-embed-text-v2-moe:latest'
	'nomic-embed-text:latest'
	'odendaalkappie/weskus'
	'paraphrase-multilingual:latest'
	'phi3.5:latest'
	'phi4-mini:latest'
	'phi4:latest'
	'qwen2.5-coder:7b'
	'qwen2.5:3b'
	'qwen2.5:7b'
	'qwen2.5:latest'
	'qwen3-coder-next:cloud'
	'qwen3-coder:480b-cloud'
	'qwen3-coder:latest'
	'qwen3-embedding:latest'
	'qwen3-next:80b-cloud'
	'qwen3-vl:latest'
	'qwen3:30b'
	'qwen3:4b'
	'qwen3:8b'
	'qwen3:latest'
	'qwen3.5:27b'
	'qwen3.5:cloud'
	'qwq:latest'
	'rnj-1:8b-cloud'
	'rnj-1:latest'
	'smollm2:latest'
	'snowflake-arctic-embed:latest'
	'snowflake-arctic-embed2:latest'
	'sqlcoder:latest'
	'stable-code:latest'
	'stablelm2:1.6b'
	'starcoder2:7b'
	'translategemma:latest'
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
