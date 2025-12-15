#!/bin/bash
echo "Create secrets script started."

export STACK_BASEPATH="/media/hans/4-T/stacks"

# Create Docker networks for the AI stack
function CREATE_SECRETS() {
	mkdir -p "${STACK_BASEPATH}/SECRETS"
	touch "${STACK_BASEPATH}/SECRETS/letta_pg_password"
	touch "${STACK_BASEPATH}/SECRETS/letta_password"
	touch "${STACK_BASEPATH}/SECRETS/mariadb_root_password"
	touch "${STACK_BASEPATH}/SECRETS/mariadb_password"
	touch "${STACK_BASEPATH}/SECRETS/gaseous-server_mariadb_root_password"
	touch "${STACK_BASEPATH}/SECRETS/gaseous-server_mariadb_password"
	touch "${STACK_BASEPATH}/SECRETS/nginx-proxy-manager_username"
	touch "${STACK_BASEPATH}/SECRETS/nginx-proxy-manager_password"
	touch "${STACK_BASEPATH}/SECRETS/romm_mariadb_password"
	touch "${STACK_BASEPATH}/SECRETS/romm_mariadb_root_password"
	touch "${STACK_BASEPATH}/SECRETS/romm_auth_secret_key"
	touch "${STACK_BASEPATH}/SECRETS/screenscraper_password"
	touch "${STACK_BASEPATH}/SECRETS/retroachievements_api_key"
	touch "${STACK_BASEPATH}/SECRETS/steamgriddb_api_key"
	touch "${STACK_BASEPATH}/SECRETS/hardcover_auth"
	touch "${STACK_BASEPATH}/SECRETS/rreading_glasses_db_password"
	touch "${STACK_BASEPATH}/SECRETS/code_server_password"
	touch "${STACK_BASEPATH}/SECRETS/code_server_sudo_password"
}
CREATE_SECRETS
