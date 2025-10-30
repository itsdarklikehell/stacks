#!/bin/bash
echo "Install uv script started."

# Install uv and related tools on Ubuntu
function INSTALL_UV(){
    # check if uv is installed and if not install it
    if command -v uv &> /dev/null
    then
        echo "uv is already installed"
    else
        eurl -LsSf https://astral.sh/uv/install.sh
        bash install.sh >/dev/null 2>&1
        rm install.sh >/dev/null 2>&1

        echo "uv installation completed."
    fi
}
# Call the function to install uv
INSTALL_UV >/dev/null 2>&1