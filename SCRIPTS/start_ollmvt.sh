#!/bin/bash
echo "Start ollmvt script started."

export UV_LINK_MODE=copy

RUN_OLLMVTUBER() {
	# sudo chown -R rizzo:rizzo /media/rizzo/RAIDSTATION/stacks/DATA/openllm-vtuber-stack/openllm-vtuber

	cd /media/rizzo/RAIDSTATION/stacks/DATA/openllm-vtuber-stack/openllm-vtuber || exit 1

	if [[ -f .venv/bin/activate ]]; then
		source .venv/bin/activate
	else
		uv venv
		source .venv/bin/activate
	fi

	uv sync
	uv pip install -r requirements.txt
	uv run run_server.py
}

RUN_OLLMVTUBER
