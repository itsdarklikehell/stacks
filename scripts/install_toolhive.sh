#!/bin/bash
# Install toolhive and related tools on Ubuntu
function INSTALL_toolhive(){
    # check if toolhive is installed and if not install it
    if command -v toolhive &> /dev/null
    then
        echo "toolhive is already installed"
    else
        curl -s https://api.github.com/repos/stacklok/toolhive-studio/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | wget -qi - || true
        sudo dpkg -i ./*.deb
        rm *.deb
        echo "toolhive installation completed."
    fi
}
# Call the function to install toolhive
INSTALL_toolhive >/dev/null 2>&1