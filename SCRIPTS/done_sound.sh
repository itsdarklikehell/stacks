#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path

export STACK_BASEPATH="/media/rizzo/RAIDSTATION/stacks"

DONE_SOUND() {
	wavfile=https://www.winhistory.de/more/winstart/down/owin31.wav
	wget -q -c "${wavfile}" -O "${STACK_BASEPATH}/SCRIPTS/tadaa.wav"
	cvlc -q --play-and-exit "${STACK_BASEPATH}/SCRIPTS/tadaa.wav"
	rm "${STACK_BASEPATH}/SCRIPTS/tadaa.wav"
}

DONE_SOUND
