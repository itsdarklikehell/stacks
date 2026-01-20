#!/bin/bash
# set -e

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
export PRUNE="true"                                                             # false, true/normal, all
export BUILDING="force_rebuild"                                                 # false, true, force_rebuild
export PULL_MODELS="true"                                                       # false, true
export START_COMFYUI="true"                                                     # false, true
export START_CUSHYSTUDIO="true"                                                 # false, true
export START_BROWSER="true"                                                     # false, true
export TWITCH_CLIENT_ID="your_client_id"                                        # set twitch client id
export TWITCH_CLIENT_SECRET="your_client_secret"                                # set twitch client secret
export AUTOSTART="disabled"                                                     # disabled, enabled

function SETUP_ENV() {

	IP_ADDRESS=$(hostname -I | awk '{print $1}') || true # get machine IP address
	export IP_ADDRESS

	if [[ ${USER} == "hans" ]]; then
		export STACK_BASEPATH="/media/hans/4-T/stacks"
		export DOCKER_BASEPATH="/media/hans/4-T/docker"
		export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
	elif [[ ${USER} == "rizzo" ]]; then
		export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
		export DOCKER_BASEPATH="/media/rizzo/RAIDSTATION/docker"
		export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
	else
		export STACK_BASEPATH="/media/hans/4-T/stacks"
		export DOCKER_BASEPATH="/media/hans/4-T/docker"
		export COMFYUI_PATH="${STACK_BASEPATH}/DATA/ai-stack/ComfyUI"
	fi

	eval "$(resize)" || true
	DOCKER_BASEPATH=$(whiptail --inputbox "What is your docker folder?" "${LINES}" "${COLUMNS}" "${DOCKER_BASEPATH}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	eval "$(resize)" || true
	STACK_BASEPATH=$(whiptail --inputbox "What is your stack basepath?" "${LINES}" "${COLUMNS}" "${STACK_BASEPATH}" --title "Stack basepath Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
	eval "$(resize)" || true
	IP_ADDRESS=$(whiptail --inputbox "What is your hostname or ip address?" "${LINES}" "${COLUMNS}" "${IP_ADDRESS}" --title "Docker folder Dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?

	export DOCKER_BASEPATH
	export STACK_BASEPATH
	export IP_ADDRESS

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${DOCKER_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${STACK_BASEPATH}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	if [[ ${exitstatus} == 0 ]]; then
		echo "User selected Ok and entered " "${IP_ADDRESS}"
	else
		echo "User selected Cancel."
		exit 1
	fi

	# export COMFYUI_MODEL_PATH="${STACK_BASEPATH}/DATA/ai-models/comfyui_models"

	cd "${STACK_BASEPATH}" || exit 1

	echo ""
	START_CUSHYSTUDIO >/dev/null 2>&1 &
	echo "" || exit

	git pull # origin main
	chmod +x "install-stack.sh"

}

SETUP_ENV

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
		"${STACK_BASEPATH}"/SCRIPTS/cleanup.sh
	fi

}

function INSTALL_DRIVERS() {

	"${STACK_BASEPATH}"/SCRIPTS/install_drivers.sh

}

function INSTALL_DOCKER() {

	"${STACK_BASEPATH}"/SCRIPTS/install_docker.sh

}

function CREATE_SECRETS() {

	"${STACK_BASEPATH}"/SCRIPTS/create_secrets.sh

}

function CLONE_REPOS() {

	"${STACK_BASEPATH}"/SCRIPTS/clone_repos.sh

}

function SETUP_AUTOSTART() {

	bin_scripts=(
		install-stack.sh
		pull_models.sh
		start_browser.sh
		start_browser_games.sh
		start_comfy-cli.sh
		start_comfyui-mini.sh
		start_comfyui.sh
		start_cushystudio.sh
		start_deduper.sh
		folder_linker.sh
	)

	autostart_desktop_scripts=(
		start_comfyui.desktop
	)

	if [[ ! -d "/home/${USER}/bin" ]]; then
		mkdir /home/${USER}/bin
	fi

	for SCRIPT in "${bin_scripts[@]}"; do
		if [[ ${SCRIPT} == "install-stack.sh" ]]; then
			if [[ -f "/home/${USER}/bin/${SCRIPT}" ]]; then
				rm "/home/${USER}/bin/${SCRIPT}" >/dev/null 2>&1 &
			fi
			ln -sf "${STACK_BASEPATH}/${SCRIPT}" "/home/${USER}/bin/${SCRIPT}"
			chmod +x "${STACK_BASEPATH}/${SCRIPT}"
		else
			if [[ -f "/home/${USER}/bin/${SCRIPT}" ]]; then
				rm "/home/${USER}/bin/${SCRIPT}" >/dev/null 2>&1 &
			fi
			ln -sf "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}" "/home/${USER}/bin/${SCRIPT}"
			chmod +x "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}"
		fi
		chmod +x "/home/${USER}/bin/${SCRIPT}"
	done

	if [[ ${AUTOSTART} == "enabled" ]]; then
		echo "autostart: ${AUTOSTART}"
		for SCRIPT in "${autostart_desktop_scripts[@]}"; do
			if [[ -f "/home/${USER}/.config/autostart/${SCRIPT}" ]]; then
				rm "/home/${USER}/.config/autostart/${SCRIPT}" >/dev/null 2>&1 &
			fi
			ln -sf "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}" "/home/${USER}/.config/autostart/${SCRIPT}"
			sudo ln -sf "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}" "/usr/share/applications/${SCRIPT}"

			chmod +x "${STACK_BASEPATH}/SCRIPTS/${SCRIPT}"
			sudo chmod +x "/usr/share/applications/${SCRIPT}"
		done
	elif [[ ${AUTOSTART} == "disabled" ]]; then
		echo "autostart: ${AUTOSTART}"
		for SCRIPT in "${autostart_desktop_scripts[@]}"; do
			if [[ -f "/home/${USER}/.config/autostart/${SCRIPT}" ]]; then
				sudo unlink "/home/${USER}/.config/autostart/${SCRIPT}" >/dev/null 2>&1 &
				sudo rm "/home/${USER}/.config/autostart/${SCRIPT}" >/dev/null 2>&1 &
			fi
		done
	else
		echo "AUTOSTART=VAR NOT SET, skipping."
	fi

	# #write out current crontab
	# crontab -l >deduper
	# #echo new cron into cron file
	# echo "@daily /home/${USER}/bin/start_deduper.sh" >>deduper
	# #install new cron file
	# crontab deduper
	# rm deduper

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

	if [[ ${PULL_MODELS} == "true" ]]; then
		"${STACK_BASEPATH}"/SCRIPTS/pull_models.sh
	elif [[ ${PULL_MODELS} == "false" ]]; then
		echo "Skipping model pulling"
	fi

}

function START_BROWSER() {

	if [[ ${START_BROWSER} == "true" ]]; then
		"${STACK_BASEPATH}"/SCRIPTS/start_browser.sh
	fi

}

function SETUP_ESSENTIALS_STACK() {

	export STACK_NAME="essential"
	INSTALL_STACK

}

function SETUP_AI_STACK() {

	export STACK_NAME="ai"
	INSTALL_STACK

	# alias ollama='docker exec -it ollama ollama'
	alias ollama='docker exec -it ${ollama_container_name} ollama'

	if command -v ollama >/dev/null 2>&1; then
		echo ""
		PULL_MODELS # >/dev/null 2>&1 &
		echo ""
	elif docker inspect "${ollama_container_name}" >/dev/null 2>&1; then
		if docker inspect -f '{{.State.Status}}' "${ollama_container_name}" | grep -q "running" || true; then
			echo ""
			PULL_MODELS # >/dev/null 2>&1 &
			echo ""
		fi
	else
		echo "Neither command ollama nor the container for ollama exists."
	fi
}

function SETUP_BOOKS_STACK() {

	export STACK_NAME="books"
	INSTALL_STACK

}

function SETUP_MEDIA_STACK() {

	export STACK_NAME="media"
	INSTALL_STACK

}

function SETUP_TESTING_STACK() {

	export STACK_NAME="testing"
	INSTALL_STACK

}

function SETUP_BACKUPS_STACK() {

	export STACK_NAME="backups"
	INSTALL_STACK

}

function SETUP_CHAT_STACK() {

	export STACK_NAME="chat"
	INSTALL_STACK

}

function SETUP_OPENLLM_VTUBER_STACK() {

	export STACK_NAME="openllm-vtuber"
	INSTALL_STACK

}

function SETUP_SDR_STACK() {

	export STACK_NAME="sdr"
	INSTALL_STACK

}

function SETUP_DOWNLOADER_STACK() {

	export STACK_NAME="downloader"
	INSTALL_STACK

}

function SETUP_DESKTOP_STACK() {

	export STACK_NAME="desktop"
	INSTALL_STACK

}

function SETUP_GAMESERVER_STACK() {

	export STACK_NAME="gameserver"
	INSTALL_STACK

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
CREATE_SECRETS

if [[ ${USER} == "hans" ]]; then
	# echo ""
	# SETUP_AUTOSTART
	# echo ""

	echo ""
	SETUP_DOWNLOADER_STACK
	echo ""

	echo ""
	SETUP_AI_STACK
	echo ""

	echo ""
	SETUP_OPENLLM_VTUBER_STACK
	echo ""

	echo ""
	SETUP_ESSENTIALS_STACK
	echo ""

	echo ""
	SETUP_BACKUPS_STACK
	echo ""

	echo ""
	SETUP_CHAT_STACK
	echo ""

	echo ""
	SETUP_BOOKS_STACK
	echo ""

	echo ""
	SETUP_GAMESERVER_STACK
	# # docker compose exec pterodactyl-panel php artisan p:user:make
	echo ""

	echo ""
	SETUP_MEDIA_STACK
	echo ""

	# echo ""
	# SETUP_SDR_STACK
	# echo ""

	########################

	# echo ""
	# SETUP_DESKTOP_STACK
	# echo ""

	# echo ""
	# SETUP_TESTING_STACK
	# echo ""

elif [[ ${USER} == "rizzo" ]]; then
	# echo ""
	# SETUP_AUTOSTART
	# echo ""

	# echo ""
	# SETUP_DOWNLOADER_STACK
	# echo ""

	# echo ""
	# SETUP_AI_STACK
	# echo ""

	echo ""
	SETUP_OPENLLM_VTUBER_STACK
	echo ""

	# echo ""
	# SETUP_ESSENTIALS_STACK
	# echo ""

	# echo ""
	# SETUP_BACKUPS_STACK
	# echo ""

	# echo ""
	# SETUP_CHAT_STACK
	# echo ""

	# echo ""
	# SETUP_BOOKS_STACK
	# echo ""

	# echo ""
	# SETUP_SDR_STACK
	# echo ""

	# echo ""
	# SETUP_GAMESERVER_STACK
	# # # docker compose exec pterodactyl-panel php artisan p:user:make
	# echo ""

	# echo ""
	# SETUP_MEDIA_STACK
	# echo ""

	########################

	# echo ""
	# SETUP_DESKTOP_STACK
	# echo ""

	# echo ""
	# SETUP_TESTING_STACK
	# echo ""

else
	# echo ""
	# SETUP_AUTOSTART
	# echo ""

	echo ""
	SETUP_DOWNLOADER_STACK
	echo ""

	echo ""
	SETUP_AI_STACK
	echo ""

	echo ""
	SETUP_ESSENTIALS_STACK
	echo ""

	echo ""
	SETUP_BACKUPS_STACK
	echo ""

	echo ""
	SETUP_CHAT_STACK
	echo ""

	echo ""
	SETUP_BOOKS_STACK
	echo ""

	echo ""
	SETUP_SDR_STACK
	echo ""

	echo ""
	SETUP_GAMESERVER_STACK
	# # docker compose exec pterodactyl-panel php artisan p:user:make
	echo ""

	echo ""
	SETUP_MEDIA_STACK
	echo ""

	########################

	# echo ""
	# SETUP_DESKTOP_STACK
	# echo ""

	# echo ""
	# SETUP_TESTING_STACK
	# echo ""

	# echo ""
	# SETUP_OPENLLM_VTUBER_STACK
	# echo ""

fi

export HISHTORY_SERVER=http://${IP_ADDRESS}:5632

export ollama_container_name="ollama"

# alias ollama='docker exec -it ollama ollama'
alias ollama='docker exec -it ${ollama_container_name} ollama'

# if command -v ollama >/dev/null 2>&1; then
# 	echo ""
# 	PULL_MODELS >/dev/null # 2>&1 &
# 	echo ""
# elif docker inspect "${ollama_container_name}" >/dev/null 2>&1; then
# 	if docker inspect -f '{{.State.Status}}' "${ollama_container_name}" | grep -q "running" || true; then
# 		echo ""
# 		PULL_MODELS >/dev/null # 2>&1 &
# 		echo ""
# 	fi
# else
# 	echo "Neither command ollama nor the container for ollama exists."
# fi

# echo "Installation should be complete now.."
# echo ""
# echo "To start a browser opening tabs with all of the stacks services:"
# echo "run: 'start_browser.sh'"
# echo ""
# echo "to start ComfyUI's service:"
# echo "run: 'start_comfyui.sh'"
# echo ""
# echo "to start ComfyUIMini's service:"
# echo "run: 'start_comfyui-mini.sh'"
# echo ""
# echo "to start CushyStudio's service:"
# echo "run: 'start_cushystudio.sh'"
# echo ""
# echo "to pull the default set of models into ollama:"
# echo "run: 'pull_models.sh'"
# echo ""
# echo "If you have a lot of lint/old-files/duplicates and want to clean/deduplicate your DATA folders."
# echo "run: 'start_deduper.sh'"
# echo ""
# echo "Alternatively, you should now be able to use the ollama cli run/pull your own models as normal i.e."
# echo "run: 'ollama pull llama3.2:latest'"
# echo "or: 'ollama run llama3.2:latest --verbose' etc."
# echo ""
# echo "To make this alias permanent you can add:"
# echo "alias ollama='docker exec -it ollama ollama'"
# echo "to your ~/.bashrc and/or ~/.bash_aliases and source those files like so:"
# echo ""
# echo ""
# echo "echo \"alias ollama='docker exec -it ollama ollama'\" >> ~/.bash_aliases"
# echo "source ~/.bash_aliases"
# echo "echo \"alias ollama='docker exec -it ollama ollama'\" >> ~/.bashrc"
# echo "source ~/.bashrc"
# echo ""
# echo ""
# echo "Have fun (de)generating those lovely stories, chats, coding projects, images and (ahem) other media and such..."

# # echo ""
# # START_BROWSER >/dev/null 2>&1 &
# # echo ""

# # "${STACK_BASEPATH}"/SCRIPTS/done_sound.sh
