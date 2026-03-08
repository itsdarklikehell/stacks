#!/bin/bash
# set -e

export HOMEBREW_NO_ENV_HINTS=1

echo "Install openclaw script started."

function UNINSTALL_OPENCLAW() {
	systemctl --user stop openclaw-gateway.service
	systemctl --user disable openclaw-gateway.service
	rm -f ~/.config/systemd/user/openclaw-gateway.service
	systemctl --user daemon-reload

	if command -v openclaw &>/dev/null; then
		openclaw gateway stop
		openclaw uninstall --all --yes --non-interactive
	fi

	npx -y openclaw uninstall --all --yes --non-interactive
	npm rm -g openclaw
	pnpm remove -g openclaw
	bun remove -g openclaw

	cp -rf "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}" "$HOME/.openclaw_bkp"
	sudo rm -rf "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}"
	sudo rm -rf ~/.openclaw/workspace
	sudo rm -rf ~/.openclaw-*

	cp -rf "$HOME/openclaw" "$HOME/openclaw_bkp"
	sudo rm -rf ~/openclaw

}

function INSTALL_OPENCLAW() {
	curl -o- https://deb.nodesource.com/setup_25.x | bash
	sudo apt install -y nodejs openjdk-25-jdk

	# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
	source ~/.bashrc
	# nvm install node
	source ~/.bashrc

	# if [[ ! -d ~/openclaw ]]; then
	# 	git clone --recursive https://github.com/openclaw/openclaw.git -o ~/openclaw
	# fi

	if [[ ! -d /home/linuxbrew ]]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
		brew doctor
	fi
	
	if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
	
	if command -v openclaw &>/dev/null; then
		echo "openclaw is already installed"
		openclaw security audit --fix
		openclaw doctor --fix
		openclaw gateway status
		openclaw dashboard
	else
		curl -fsSL https://openclaw.ai/install.sh | bash
		# curl -fsSL https://openclaw.ai/install.sh | bash -s -- --install-method git
		openclaw security audit --fix
		openclaw doctor --fix
		openclaw gateway status
		openclaw dashboard
		echo "openclaw installation completed."
	fi

}


# UNINSTALL_OPENCLAW
INSTALL_OPENCLAW
