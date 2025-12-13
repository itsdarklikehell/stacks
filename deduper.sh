#!/bin/bash

WD="$(dirname "$(realpath "$0")")" || true
export WD                     # set working dir
export STACK_BASEPATH="${WD}" # set base path

sudo apt install rmlint rmlint-gui

# rmlint -g "${STACK_BASEPATH}/DATA/ai-models"
folders=(
	"${STACK_BASEPATH}/DATA/ai-models"
	"${STACK_BASEPATH}/DATA/ai-inputs"
	"${STACK_BASEPATH}/DATA/ai-outputs"
	"${STACK_BASEPATH}/DATA/ai-workflows"
)
for folder in "${folders[@]}"; do
	echo "Deduping ${folder}"
	rmlint -g -o sh:rmlint.sh -c sh:symlink "${folder}"
	./rmlint.sh -dpc
	export DO_REMOVE=true
	if [[ -z "${DO_REMOVE}" ]]; then
		rm -f 'rmlint.sh'
		rm -f 'rmlint.json'
	fi
done
