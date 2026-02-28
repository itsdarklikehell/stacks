#!/bin/bash
# set -e

echo "Install openclaw script started."

function INSTALL_OPENCLAW() {

	if command -v openclaw &>/dev/null; then
		echo "openclaw is already installed"
	else
		curl -fsSL https://openclaw.ai/install.sh | bash
		echo "openclaw installation completed."
	fi

}

INSTALL_OPENCLAW
