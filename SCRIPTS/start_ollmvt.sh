#!/bin/bash
echo "Start ollmvt script started."

export UV_LINK_MODE=copy

RUN_OLLMVTUBER() {
	sudo chown -R rizzo:rizzo /media/rizzo/RAIDSTATION/stacks/DATA/openllm-vtuber-stack/openllm-vtuber

	cd /media/rizzo/RAIDSTATION/stacks/DATA/openllm-vtuber-stack/openllm-vtuber || exit 1
	source .venv/bin/activate
	uv run run_server.py
}

RUN_OLLMVTUBER
