#!/bin/bash

export DEVICE=$(ip -oneline -4 addr show scope global | tr -s ' ' | tr '/' ' ' | cut -f 2,4 -d ' ' | head -n 1 | awk '{ print $1 }')
export IPGATEWAY=$(ip -oneline -4 addr show scope global | tr -s ' ' | tr '/' ' ' | cut -f 2,4 -d ' ' | head -n 1 | awk '{ print $2 }' | cut -f 1-3 -d '.')

# Create Docker networks for the AI stack
function CREATE_NETWORKS(){
    # docker network rm ai-stack management-stack kuma_network macvlan

    docker network create management-services
    docker network create media-services
    docker network create essential-services
    docker network create ai-services
    docker network create jaison-services
    docker network create openllm-vtuber-services

    docker network create -d macvlan \
    --subnet="${IPGATEWAY}.0/24" \
    --gateway="$(ip route show 0.0.0.0/0 dev "${DEVICE}" | cut -d\  -f3)" \
    -o parent="${DEVICE}" \
    macvlan
}

CREATE_NETWORKS