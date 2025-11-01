#!/bin/bash
echo "Create secrets script started."

# Create Docker networks for the AI stack
function CREATE_SECRETS() {
	mkdir -p "${WD}/SECRETS"
	touch "${WD}/SECRETS/letta_pg_password"
	touch "${WD}/SECRETS/letta_password"
	touch "${WD}/SECRETS/mariadb_root_password"
	touch "${WD}/SECRETS/mariadb_password"
	touch "${WD}/SECRETS/gaseous-server_mariadb_root_password"
	touch "${WD}/SECRETS/gaseous-server_mariadb_password"
	touch "${WD}/SECRETS/nginx-proxy-manager_username"
	touch "${WD}/SECRETS/nginx-proxy-manager_password"
	touch "${WD}/SECRETS/romm_mariadb_password"
	touch "${WD}/SECRETS/romm_mariadb_root_password"
	touch "${WD}/SECRETS/romm_auth_secret_key"
	touch "${WD}/SECRETS/screenscraper_password"
	touch "${WD}/SECRETS/retroachievements_api_key"
	touch "${WD}/SECRETS/steamgriddb_api_key"
	touch "${WD}/SECRETS/hardcover_auth"
	touch "${WD}/SECRETS/grafana_username"
	touch "${WD}/SECRETS/grafana_password"
	touch "${WD}/SECRETS/grafana_google_client_secret"
	touch "${WD}/SECRETS/rreading_glasses_db_password"
	touch "${WD}/SECRETS/code_server_password"
	touch "${WD}/SECRETS/code_server_sudo_password"
}
CREATE_SECRETS
