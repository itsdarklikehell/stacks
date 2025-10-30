#!/bin/bash
echo "Create networks script started."

DEVICE=$(ip -oneline -4 addr show scope global | tr -s ' ' | tr '/' ' ' | cut -f 2,4 -d ' ' | head -n 1 | awk '{ print $1 }' || true)
IPGATEWAY=$(ip -oneline -4 addr show scope global | tr -s ' ' | tr '/' ' ' | cut -f 2,4 -d ' ' | head -n 1 | awk '{ print $2 }' | cut -f 1-3 -d '.' || true)

export DEVICE
export IPGATEWAY

# Create Docker networks for the AI stack
function CREATE_NETWORKS() {
	docker network create -d macvlan \
		--subnet="${IPGATEWAY}.0/24" \
		--gateway="$(ip route show 0.0.0.0/0 dev "${DEVICE}" | cut -d\  -f3 || true)" \
		-o parent="${DEVICE}" \
		macvlan
}

CREATE_NETWORKS
