#!/bin/bash
# set -e

echo "Install uv script started."

function INSTALL_UV() {

	if command -v uv &>/dev/null; then
		echo "uv is already installed"
	else
		curl -LsSf https://astral.sh/uv/install.sh
		bash install.sh >/dev/null 2>&1
		rm install.sh >/dev/null 2>&1
		echo "uv installation completed."
	fi

}

INSTALL_UV >/dev/null 2>&1
