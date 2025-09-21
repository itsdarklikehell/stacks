#!/bin/bash
# Create Docker networks for the AI stack
function CREATE_SECRETS(){
    mkdir -p "${WD}/secrets"
    touch "${WD}/secrets/letta_pg_password.txt"
    touch "${WD}/secrets/letta_password.txt"
    touch "${WD}/secrets/mariadb_root_password.txt"
    touch "${WD}/secrets/mariadb_password.txt"
    touch "${WD}/secrets/gsdb_root_password.txt"
    touch "${WD}/secrets/gsdb_password.txt"
    touch "${WD}/secrets/romm_db_password.txt"
    touch "${WD}/secrets/romm_auth_secret_key.txt"
    touch "${WD}/secrets/screenscraper_password.txt"
    touch "${WD}/secrets/retroachievements_api_key.txt"
    touch "${WD}/secrets/steamgriddb_api_key.txt"
    touch "${WD}/secrets/hardcover_auth.txt"
    touch "${WD}/secrets/rreading_glasses_db_password.txt"
}
CREATE_SECRETS 