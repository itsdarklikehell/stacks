#!/bin/bash
# Create Docker networks for the AI stack
function CREATE_NETWORKS(){
    # docker network rm ai-stack management-stack kuma_network iot_macvlan

    docker network create management-stack
    docker network create kuma_network
    docker network create ai-stack
    docker network create wg
    docker network create cloud
    
    docker network create -d macvlan \
    --subnet=192.168.1.0/24 \
    --gateway=192.168.1.1 \
    -o parent=enp2s0 \
    iot_macvlan
}

CREATE_NETWORKS 