#!/bin/bash
export DEVICE="enp2s0"
# Create Docker networks for the AI stack
function CREATE_NETWORKS(){
    # docker network rm ai-stack management-stack kuma_network iot_macvlan

    docker network create management-services
    docker network create media-services
    docker network create essential-services
    docker network create ai-services

    docker network create -d iot_macvlan \
    --subnet=192.168.1.0/24 \
    --gateway="$(ip route show 0.0.0.0/0 dev "${DEVICE}" | cut -d\  -f3)" \
    -o parent="${DEVICE}" \
    iot_macvlan
}

CREATE_NETWORKS