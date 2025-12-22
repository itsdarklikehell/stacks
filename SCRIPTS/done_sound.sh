#!/bin/bash
# set -e

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path

DONE_SOUND() {

	wavfile=https://www.winhistory.de/more/winstart/down/owin31.wav
	wget -q -c "${wavfile}" -O "/tmp/tadaa.wav"
	cvlc -q --play-and-exit "/tmp/tadaa.wav"
	rm "/tmp/tadaa.wav"

}

DONE_SOUND >/dev/null 2>&1 &
