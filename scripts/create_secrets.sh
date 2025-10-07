#!/bin/bash
# Create Docker networks for the AI stack
function CREATE_SECRETS(){
    mkdir -p "${WD}/secrets"
    touch "${WD}/secrets/letta_pg_password"
    touch "${WD}/secrets/letta_password"
    touch "${WD}/secrets/mariadb_root_password"
    touch "${WD}/secrets/mariadb_password"
    touch "${WD}/secrets/gsdb_root_password"
    touch "${WD}/secrets/gsdb_password"
    touch "${WD}/secrets/romm_db_password"
    touch "${WD}/secrets/romm_auth_secret_key"
    touch "${WD}/secrets/screenscraper_password"
    touch "${WD}/secrets/retroachievements_api_key"
    touch "${WD}/secrets/steamgriddb_api_key"
    touch "${WD}/secrets/hardcover_auth"
    touch "${WD}/secrets/rreading_glasses_db_password"
    mkdir -p "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage"
    touch "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage/anythingllm.db"
    if [ -d "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage/.env" ]; then
        rm -rf "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage/.env"
    fi
    # if [ -f "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage/.env" ]; then
    #     sudo rm -rf "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage/.env"
    # fi
    if [ ! -f "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage/.env" ]; then
        mkdir -p "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage"
        cd "${WD}/ai-stack/DATA/anythingllm/anythingllm_storage" || exit 1
        sudo wget -c "https://raw.githubusercontent.com/Mintplex-Labs/anything-llm/refs/heads/master/server/.env.example" -O ".env"
    fi
}
CREATE_SECRETS