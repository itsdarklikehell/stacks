#!/bin/bash
set -e
echo "Install toolhive script started."

function INSTALL_toolhive() {

	if command -v toolhive &>/dev/null; then
		echo "toolhive is already installed"
	else
		curl -s https://api.github.com/repos/stacklok/toolhive-studio/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | wget -qi - || true
		sudo dpkg -i ./*.deb
		rm ./*.deb
		echo "toolhive installation completed."
	fi

}

INSTALL_toolhive >/dev/null 2>&1
