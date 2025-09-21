#!/bin/bash
# Install uv and related tools on Ubuntu
function INSTALL_UV(){
    # check if uv is installed and if not install it
    if command -v uv &> /dev/null
    then
        echo "uv is already installed"
    else
        eurl -LsSf https://astral.sh/uv/install.sh | sh

        echo "uv installation completed."
    fi
}
# Call the function to install uv
INSTALL_UV