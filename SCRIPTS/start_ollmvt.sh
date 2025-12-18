#!/bin/bash
echo "Start ollmvt script started."

export UV_LINK_MODE=copy

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"
export OLLMVT_PATH="${STACK_BASEPATH}/DATA/ai-stack/openllm-vtuber-stack/Open-LLM-VTuber"

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

function RUN_OLLMVTUBER() {
	# sudo chown -R ${USER}:${USER} ${BASEPATH}/DATA/openllm-vtuber-stack/Open-LLM-VTuber

	cd "${OLLMVT_PATH}" || exit 1

	if [[ -f .venv/bin/activate ]]; then
		# shellcheck source=/dev/null
		source .venv/bin/activate
	else
		uv venv --clear --seed
		# shellcheck source=/dev/null
		source .venv/bin/activate
		uv pip install --upgrade pip
		uv sync --all-extras

		uv pip install -r requirements.txt
		uv pip install -r requirements-bilibili.txt

		uv pip install py3-tts sherpa-onnx fish-audio-sdk unidic-lite mecab-python3

		uv add git+https://github.com/myshell-ai/MeloTTS.git
		uv pip install git+https://github.com/myshell-ai/MeloTTS.git

		uv add git+https://github.com/suno-ai/bark.git
		uv pip install git+https://github.com/suno-ai/bark.git

		uv pip install unidic
		python -m unidic download
		python - <<PYCODE
import nltk
nltk.download('averaged_perceptron_tagger_eng')
PYCODE

	fi

	uv run run_server.py

}

RUN_OLLMVTUBER
