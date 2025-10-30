#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD                                        #
export LETTA_SANDBOX_MOUNT_PATH="${WD}/letta"    #
export UV_LINK_MODE=copy                         #
export OLLAMA="docker"                           # local, docker
export PERM_DATA="${WD}/DATA"                    #
export CLEANUP="false"                           # false, true
export PRUNE="normal"                            # false, true/normal, all
export BUILDING="true"                           # false, true, force_rebuild
export TWITCH_CLIENT_ID="your_client_id"         #
export TWITCH_CLIENT_SECRET="your_client_secret" #

echo "Working directory is set to ${WD}"
cd "${WD}" || exit
git pull origin main

function PULL_MODELS() {
	scripts/pull_models.sh
}
function PRUNING() {
	echo ""
	echo "Pruning is set to: ${PRUNE}"
	echo ""
	if [[ ${PRUNE} == "all" ]]; then
		docker system prune -af
	elif [[ ${PRUNE} == "true" ]] || [[ ${PRUNE} == "normal" ]]; then
		docker system prune -f
	elif [[ ${PRUNE} == "false" ]]; then
		echo "Skipping docker system prune"
	fi
	sleep 3
}
function CLEANUP_DATA() {
	if [[ ${CLEANUP} == "true" ]]; then
		# export PRUNE="normal"      # false, true/normal, all
		# export BUILDING="recreate" # false, true, recreate
		scripts/cleanup.sh
	fi
}
function INSTALL_DRIVERS() {
	scripts/install_drivers.sh
}
function INSTALL_DOCKER() {
	scripts/install_docker.sh
}
function CREATE_NETWORKS() {
	scripts/create_networks.sh
}
function CREATE_SECRETS() {
	scripts/create_secrets.sh
}
function CLONE_REPOS() {
	scripts/clone_repos.sh
}
function INSTALL_ESSENTIALS_STACK() {
	essential-stack/install-stack.sh
}
function INSTALL_MEDIA_STACK() {
	media-stack/install-stack.sh
}
function INSTALL_AI_STACK() {
	ai-stack/install-stack.sh
}
function INSTALL_JAISON_STACK() {
	jaison-stack/install-stack.sh
}
function INSTALL_VOICE_CHAT_AI_STACK() {
	voice-chat-ai-stack/install-stack.sh
}
function INSTALL_PROJECT_RIKO_STACK() {
	riko-stack/install-stack.sh
}
function INSTALL_OPENLLM_VTUBER_STACK() {
	openllm-vtuber-stack/install-stack.sh
}
function INSTALL_ARR_STACK() {
	arr-stack/install-stack.sh
}
function INSTALL_AIWAIFU_STACK() {
	aiwaifu-stack/install-stack.sh
}
function INSTALL_AIRI_STACK() {
	airi-stack/install-stack.sh
}
# Install essential dependencies
echo ""
echo "Installing Drivers"
echo ""
INSTALL_DRIVERS
echo ""
echo "Installing Docker"
echo ""
INSTALL_DOCKER

# echo ""
# echo "Cloning repos"
# echo ""
# CLONE_REPOS # >/dev/null 2>&1
# echo ""

## STACKS:
echo "Building is set to: ${BUILDING}"
# CLEANUP_DATA
# PRUNING
CREATE_NETWORKS
CREATE_SECRETS

echo ""
INSTALL_ESSENTIALS_STACK
echo ""

echo ""
INSTALL_AI_STACK
echo ""

echo ""
INSTALL_MEDIA_STACK
echo ""

# echo ""
# INSTALL_ARR_STACK
# echo ""

# echo ""
# INSTALL_AIWAIFU_STACK
# echo ""

# echo ""
# INSTALL_AIRI_STACK
# echo ""

# echo ""
# INSTALL_OPENLLM_VTUBER_STACK
# echo ""

# echo ""
# INSTALL_JAISON_STACK
# echo ""

# echo ""
# INSTALL_PROJECT_RIKO_STACK
# echo ""

PULL_MODELS

# dockly # lazydocker

echo "Installation complete.."

# if [[ -f "${HOME}/bin/start_ai.sh" ]]; then
# 	# gnome-terminal -- "${HOME}/bin/start_ai.sh"
# 	# xdg-open "http://localhost:8383/"
# fi

# sudo chown -R "${USER}":"${USER}" "${WD}"
# xdg-open "http://localhost:11434" >/dev/null 2>&1 &
# xdg-open "http://0.0.0.0:7801/Install" >/dev/null 2>&1 &
