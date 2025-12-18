#!/bin/bash
WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path

export LETTA_SANDBOX_MOUNT_PATH="${STACK_BASEPATH}/DATA/ai-stack/letta/sandbox" # set letta sandbox mount point
export UV_LINK_MODE=copy                                                        # set uv link mode
export OLLAMA="docker"                                                          # local, docker
export SECRETS_DIR="${STACK_BASEPATH}/SECRETS"                                  # folder that store secrets
export PERM_DATA="${STACK_BASEPATH}/DATA"                                       # folders that store stack data
export CONFIGS_DIR="${STACK_BASEPATH}/STACKS"                                   # folders that store stack configs
export CLEANUP="false"                                                          # false, true
export PRUNE="false"                                                            # false, true/normal, all
export BUILDING="force_rebuild"                                                 # false, true, force_rebuild
export PULL_MODELS="true"                                                       # false, true
export START_OLLMVT="true"                                                      # false, true
export START_COMFYUI="true"                                                     # false, true
export START_CUSHYSTUDIO="true"                                                 # false, true
export START_BROWSER="true"                                                     # false, true
export TWITCH_CLIENT_ID="your_client_id"                                        # set twitch client id
export TWITCH_CLIENT_SECRET="your_client_secret"                                # set twitch client secret

# if [[ "$1" == "-i" ]] || [[ "$1" == "--interactive" ]]; then
# 	echo "Interactive mode enabled."
# 	export INTERACTIVE=true
# fi

function SETUP_ENV() {

	IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
	export IP_ADDRESS

	export DOCKER_BASEPATH="/media/rizzo/RAIDSTATION/docker"
	export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
	export COMFYUI_PATH="/media/rizzo/RAIDSTATION/stacks/DATA/ai-stack/ComfyUI"

	eval "$(resize)" || true
	DOCKER_BASEPATH=$(whiptail --inputbox "What is your docker folder?" "${LINES}" "${COLUMNS}" "${DOCKER_BASEPATH}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ "${exitstatus}" = 0 ]]; then
		echo "User selected Ok and entered " "${DOCKER_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export DOCKER_BASEPATH

	eval "$(resize)" || true
	STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ "${exitstatus}" = 0 ]]; then
		echo "User selected Ok and entered " "${STACK_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export STACK_BASEPATH

	eval "$(resize)" || true
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip adress?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [[ "${exitstatus}" = 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi
	export IP_ADDRESS

	cd "${STACK_BASEPATH}" || exit
	git pull # origin main
	chmod +x "install-stack.sh"

}
SETUP_ENV

function PRUNING() {
	echo ""
	echo "Pruning is set to: ${PRUNE}"
	echo ""
	if [[ "${PRUNE}" == "all" ]]; then
		docker system prune -af
	elif [[ "${PRUNE}" == "true" ]] || [[ "${PRUNE}" == "normal" ]]; then
		docker system prune -f
	elif [[ "${PRUNE}" == "false" ]]; then
		echo "Skipping docker system prune"
	fi
	sleep 3
}

function CLEANUP_DATA() {
	if [[ "${CLEANUP}" == "true" ]]; then
		SCRIPTS/cleanup.sh
	fi
}

function INSTALL_DRIVERS() {
	SCRIPTS/install_drivers.sh
}

function INSTALL_DOCKER() {
	SCRIPTS/install_docker.sh
}

function CREATE_NETWORKS() {
	SCRIPTS/create_networks.sh
}

function CREATE_SECRETS() {
	SCRIPTS/create_secrets.sh
}

function CLONE_REPOS() {
	SCRIPTS/clone_repos.sh
}

function SETUP_AUTOSTART() {
	scripts=(
		start_browser.sh
		start_comfyui.sh
		start_comfyui-mini.sh
		start_cushystudio.sh
		start_ollmvt.sh
		pull_models.sh
		install-stack.sh
	)
	desktop_scripts=(
		start_browser.desktop
		start_comfyui.desktop
		start_comfyui-mini.desktop
		start_cushystudio.desktop
		start_ollmvt.desktop
	)
	for SCRIPT in "${scripts[@]}"; do
		if [[ "${SCRIPT}" == "install-stack.sh" ]]; then
			rm "/home/${USER}/bin/${SCRIPT}"
			ln -s "${STACK_BASEPATH}/${SCRIPT}" "/home/${USER}/bin/${SCRIPT}"
			chmod +x "${STACK_BASEPATH}/${SCRIPT}"
		else
			rm "/home/${USER}/bin/${SCRIPT}"
			ln -s "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}" "/home/${USER}/bin/${SCRIPT}"
			chmod +x "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}"
		fi
		chmod +x "/home/${USER}/bin/${SCRIPT}"

	done
	for SCRIPT in "${desktop_scripts[@]}"; do
		rm "/home/${USER}/.config/autostart/${SCRIPT}"
		ln -s "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}" "/home/${USER}/.config/autostart/${SCRIPT}"
		sudo ln -s "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}" "/usr/share/applications/${SCRIPT}"

		chmod +x "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}"
		sudo chmod +x "/usr/share/applications/${SCRIPT}"
	done
}

function INSTALL_STACK() {
	export STACK_DIR="${CONFIGS_DIR}/${STACK_NAME}-stack"

	echo "Building is set to: ${BUILDING}"
	echo "Working directory is set to ${STACK_BASEPATH}"
	echo "Configs directory is set to ${CONFIGS_DIR}"
	echo "Data directory is set to ${PERM_DATA}"
	echo "Secrets directory is set to ${SECRETS_DIR}"
	echo "Stacks directory is set to ${STACK_DIR}"

	"${STACK_DIR}"/install-stack.sh
}

function PULL_MODELS() {
	if [[ "${PULL_MODELS}" == "true" ]]; then
		SCRIPTS/pull_models.sh
	elif [[ "${PULL_MODELS}" == "false" ]]; then
		echo "Skipping model pulling"
	fi
}

function START_OLLMVT() {
	if [[ "${START_OLLMVT}" == "true" ]]; then
		SCRIPTS/start_ollmvt.sh
	fi
}

function START_COMFYUI() {
	if [[ "${START_COMFYUI}" == "true" ]]; then
		SCRIPTS/start_comfyui.sh
	fi
}

function START_CUSHYSTUDIO() {
	if [[ "${START_CUSHYSTUDIO}" == "true" ]]; then
		SCRIPTS/start_cushystudio.sh
	fi
}

function START_BROWSER() {
	if [[ "${START_BROWSER}" == "true" ]]; then
		SCRIPTS/start_browser.sh
	fi
}

function START_DEDUPER() {
	SCRIPTS/start_deduper.sh
}

function SETUP_ESSENTIALS_STACK() {
	export STACK_NAME="essential"
	INSTALL_STACK
}

function SETUP_AI_STACK() {
	export STACK_NAME="ai"
	INSTALL_STACK
}

function SETUP_OPENLLM_VTUBER_STACK() {
	export STACK_NAME="openllm-vtuber"
	"${STACK_NAME}"-vtuber-stack/install-stack.sh
}

echo "" # Install essential dependencies
echo "Installing Drivers"
echo ""
INSTALL_DRIVERS
echo ""
echo "Installing Docker"
echo ""
INSTALL_DOCKER

CLEANUP_DATA
PRUNING

# echo ""
# echo "Cloning repos"
# echo ""
# CLONE_REPOS # >/dev/null 2>&1
# echo ""

### STACKS:
CREATE_NETWORKS
CREATE_SECRETS

echo ""
SETUP_AUTOSTART
echo ""

echo ""
SETUP_ESSENTIALS_STACK
echo ""

echo ""
SETUP_AI_STACK
echo ""

# echo ""
# PULL_MODELS # >/dev/null 2>&1 &
# echo ""

# echo ""
# START_COMFYUI # >/dev/null 2>&1 &
# echo ""

# echo ""
# START_CUSHYSTUDIO >/dev/null 2>&1 &
# echo ""

# echo ""
# START_OLLMVT # >/dev/null 2>&1 &
# echo ""

# echo ""
# START_BROWSER >/dev/null 2>&1 &
# echo ""

# echo ""
# START_DEDUPER # >/dev/null 2>&1 &
# echo ""

"${STACK_BASEPATH}"/SCRIPTS/done_sound.sh

echo "Installation complete.."

# sudo chown -R "${USER}":"${USER}" "${STACK_BASEPATH}/DATA"
