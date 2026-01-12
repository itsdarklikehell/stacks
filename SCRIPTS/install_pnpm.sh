#!/bin/bash
# set -e

echo "Install pnpm script started."

function INSTALL_PNPM() {

	if command -v pnpm &>/dev/null; then
		echo "pnpm is already installed"
	else
		curl -fsSL https://get.pnpm.io/install.sh | sh - || true
		echo "pnpm installation completed."
	fi

}

INSTALL_PNPM >/dev/null 2>&1

