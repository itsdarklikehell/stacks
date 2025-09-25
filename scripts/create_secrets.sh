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
    sudo touch ai-stack/DATA/anythingllm/.env
}
CREATE_SECRETS