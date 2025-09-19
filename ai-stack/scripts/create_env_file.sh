#!/bin/bash
# Create .env file for AI stack
function CREATE_ENV_FILE(){
cat << EOF > "${WD}/.env"
# LETTA_DB_HOST="http://host.docker.internal:5432"
# LETTA_PG_DB="letta"
# LETTA_PG_PASSWORD="letta"
# LETTA_PG_URI="http://host.docker.internal:5432"
# LETTA_PG_USER="letta"
# LETTA_SERVER_PASSWORD="letta"
# SECURE=true
ANTHROPIC_API_KEY=
AZURE_API_KEY=
AZURE_API_VERSION=
AZURE_BASE_URL=
CLICKHOUSE_DATABASE=
CLICKHOUSE_ENDPOINT="http://localhost:8123"
CLICKHOUSE_PASSWORD=
CLICKHOUSE_USERNAME=
COMFYUI_PORT=
DB_PASS=
DB_USER=
GEMINI_API_KEY=
GROQ_API_KEY=
LETTA_BASE_URL="http://host.docker.internal:8283"
LETTA_DEBUG="True"
LETTA_MCP_PORT=
LETTA_OTEL_EXPORTER_OTLP_ENDPOINT="./letta"
LETTA_PASSWORD=
# LETTA_SANDBOX_MOUNT_PATH="./letta"
LIBRETRANSLATE_PORT=
MONGODB_PORT=
NODE_ENV=production
OLLAMA_API_CREDENTIALS=
# OLLAMA_BASE_URL="http://host.docker.internal:11434"
# OLLAMA_BASE_URL="http://localhost:11434"
OLLAMA_BASE_URL="http://ollama:11434"
OLLAMA_PORT=
OPEN_WEBUI_PORT=
OPENAI_API_KEY=
OPENLLM_API_KEY=
OPENLLM_AUTH_TYPE=
PGID=1000
PIPER_PORT=
PUID=1000
SEARXNG_PORT=
SKIP_INIT_DB="True"
TVS99_PORT=
VLLM_API_BASE="http://host.docker.internal:8000"
WATCHTOWER_HTTP_API_TOKEN=
WATCHTOWER_PORT=
WHISHPER_HOST="https://whisper.local.example.com"
WHISPER_MODELS="tiny,small"
WHISPER_PORT=8038
# NGINX_PROXY_MANAGER_USERNAME="bauke.molenaar@gmail.com"
# NGINX_PROXY_MANAGER_PASSWORD="Crims0nDynam0!"
EOF
}
if [ ! -f "${WD}/.env" ]; then
    echo "Creating .env file..."
    CREATE_ENV_FILE
else
    echo ".env file already exists. Skipping creation."
fi