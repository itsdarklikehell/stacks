#!/bin/bash
echo "Start ollmvt script started."

export UV_LINK_MODE=copy

RUN_OLLMVTUBER() {
	# sudo chown -R rizzo:rizzo ${BASEPATH}/DATA/openllm-vtuber-stack/Open-LLM-VTuber

	cd ${BASEPATH}/DATA/openllm-vtuber-stack/Open-LLM-VTuber || exit 1

	if [[ -f .venv/bin/activate ]]; then
		source .venv/bin/activate
	else
		uv venv --clear --seed
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
