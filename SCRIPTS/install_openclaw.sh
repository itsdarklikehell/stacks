#!/bin/bash
# set -e

echo "Install openclaw script started."

function INSTALL_OPENCLAW() {
	curl -o- https://deb.nodesource.com/setup_25.x | bash
	sudo apt install nodejs

	# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
	source ~/.bashrc
	# nvm install node
	source ~/.bashrc
	
	if command -v openclaw &>/dev/null; then
		echo "openclaw is already installed"
		# openclaw security audit --deep
		# openclaw doctor --fix
	else
		curl -fsSL https://openclaw.ai/install.sh | bash
		echo "openclaw installation completed."
	fi

}

INSTALL_OPENCLAW
