#!/bin/bash
# Install swarmui
function INSTALL_SWARMUI(){

    docker volume create swarmdata
    docker volume create swarmbackend
    docker volume create swarmdlnodes
    docker volume create swarmextensions

    # Check if the container exists
    if docker inspect swarmui > /dev/null 2>&1; then
        echo "The container swarmui exists."
        # Check if the container is running
        if $(docker inspect -f '{{.State.Status}}' "swarmui" | grep -q "running"); then
            echo "The container swarmui is running."
        else
            echo "The container swarmui is not running."
            # Start the container if it is not running
            docker start swarmui
        fi
    else
        echo "The container swarmui does not exist."
        # Create and start the container if it does not exist
        cd "${WD}/swarmui/launchtools" || exit 1
        cp "${WD}/scripts/custom-launch-docker.sh" "${WD}/swarmui/launchtools"
        ./launch-standard-docker.sh fixch
        ./custom-launch-docker.sh
        # docker run -d --name swarmui your_image_name
        echo "swarmui installation completed."
    fi
    ln -sf "${WD}/ComfyUI-Manager" "${WD}/swarmui/dlbackend/ComfyUI/custom_nodes" &>/dev/null
}
INSTALL_SWARMUI 