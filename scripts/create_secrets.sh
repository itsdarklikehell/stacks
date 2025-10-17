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
    touch "${WD}/secrets/grafana_username"
    touch "${WD}/secrets/grafana_password"
    touch "${WD}/secrets/grafana_google_client_secret"
    touch "${WD}/secrets/rreading_glasses_db_password"
    # mkdir -p "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage"
    # touch "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage/anythingllm.db"
    if [[ -d "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage/.env" ]]; then
        rm -rf "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage/.env"
    fi
    # if [ -f "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage/.env" ]; then
    #     sudo rm -rf "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage/.env"
    # fi
    if [[ ! -f "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage/.env" ]]; then
        mkdir -p "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage"
        cd "${WD}/DATA/ai-stack/anythingllm/anythingllm_storage" || exit 1
        if [[ ! -f ".env" ]]; then
            sudo wget -c "https://raw.githubusercontent.com/Mintplex-Labs/anything-llm/refs/heads/master/server/.env.example" -O ".env"
        fi
    fi
}
CREATE_SECRETS