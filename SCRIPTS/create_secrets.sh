#!/bin/bash
echo "Create secrets script started."

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

# Create Docker networks for the AI stack
function CREATE_SECRETS() {
	mkdir -p "${STACK_BASEPATH}/SECRETS"
	touch "${STACK_BASEPATH}/SECRETS/letta_pg_password"
	touch "${STACK_BASEPATH}/SECRETS/letta_password"
	touch "${STACK_BASEPATH}/SECRETS/nginx-proxy-manager_username"
	touch "${STACK_BASEPATH}/SECRETS/nginx-proxy-manager_password"
}
CREATE_SECRETS
