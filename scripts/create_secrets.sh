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
    touch "${WD}/secrets/nginx-proxy-manager_username"
    touch "${WD}/secrets/nginx-proxy-manager_password"
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
    if [[ -d "${WD}/DATA/management-stack/dashy/data/conf.yml" ]]; then
        sudo rm -rf "${WD}/DATA/management-stack/dashy/data/conf.yml"
    fi
    if [[ ! -f "${WD}/DATA/management-stack/dashy/data/conf.yml" ]]; then
        sudo wget "https://gist.githubusercontent.com/Lissy93/000f712a5ce98f212817d20bc16bab10/raw/b08f2473610970c96d9bc273af7272173aa93ab1/Example%25201%2520-%2520Getting%2520Started%2520-%2520conf.yml" -O "${WD}/DATA/management-stack/dashy/data/conf.yml"
        sudo touch "${WD}/DATA/management-stack/dashy/data/conf.yml"
    fi
    
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