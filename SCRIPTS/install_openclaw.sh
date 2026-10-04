#!/bin/bash
set -euo pipefail
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

	npm rm -g openclaw
	pnpm rm -g openclaw
	bun rm -g openclaw

	# if [[ ! -d "${HOME}/.openclaw_bkp" ]]; then
	# 	mkdir "${HOME}/.openclaw_bkp"
	# fi

	# if [[ ! -d "${HOME}/openclaw_bkp" ]]; then
	# 	mkdir "${HOME}/openclaw_bkp"
	# fi

	# cp -rf "${OPENCLAW_STATE_DIR:-${HOME}/.openclaw/*}" "${HOME}/.openclaw_bkp/*"
	# mv -f "${OPENCLAW_STATE_DIR:-${HOME}/.openclaw}" "${HOME}/.openclaw_bkp"
	# cp -rf "${HOME}/openclaw" "${HOME}/openclaw_bkp"
	# mv -f "${HOME}/openclaw" "${HOME}/openclaw_bkp"

	if [ -d "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}" ]; then sudo rm -rf "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}"; fi
	if [ -d ~/.openclaw/workspace ]; then sudo rm -rf ~/.openclaw/workspace; fi
	for dir in ~/.openclaw-*; do [ -d "$dir" ] && sudo rm -rf "$dir"; done
	if [ -d ~/openclaw ]; then sudo rm -rf ~/openclaw; fi
	if [ -f ~/.local/bin/openclaw ]; then sudo rm -f ~/.local/bin/openclaw; fi

}

function INSTALL_OPENCLAW() {

	curl -fsSL https://deb.nodesource.com/setup_25.x -o /tmp/nodesource-setup.sh && sudo bash /tmp/nodesource-setup.sh && rm -f /tmp/nodesource-setup.sh
	sudo apt upgrade -y
	sudo apt install -y nodejs openjdk-25-jdk

	# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
	source ~/.bashrc
	# nvm install node
	source ~/.bashrc

	if [[ ! -d ~/openclaw ]]; then
		git clone --recursive https://github.com/openclaw/openclaw.git ~/openclaw
		# curl -fsSL https://openclaw.ai/install.sh | bash -s -- --install-method git
	fi

	# if [[ ! -d /home/linuxbrew ]]; then
	# 	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# 	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
	# 	brew doctor
	# fi

	# if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	# 	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	# fi

	if [[ -d ~/openclaw ]]; then

		cd ~/openclaw || exit 1

		# pnpm install
		# # pnpm approve-builds
		# pnpm build
		# pnpm link --global

		curl -fsSL https://openclaw.ai/install.sh -o /tmp/openclaw-install.sh && bash /tmp/openclaw-install.sh -s -- --install-method git && rm -f /tmp/openclaw-install.sh

		openclaw completion --write-state && openclaw completion -i
		source ~/.bashrc

		openclaw onboard --install-daemon

	fi

}

source ~/.bashrc
UNINSTALL_OPENCLAW

source ~/.bashrc
INSTALL_OPENCLAW
