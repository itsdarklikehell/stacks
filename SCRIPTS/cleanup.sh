#!/bin/bash

export STACK_BASEPATH="/media/hans/4-T/stacks"

echo "Cleanup script started."
echo "CLEANUP is set to: ${CLEANUP}"

cd "${STACK_BASEPATH}" || exit

function CLEANUP_DATA() {
	FOLDERS=(
		"${STACK_BASEPATH}/DATA/airi-stack"
		"${STACK_BASEPATH}/DATA/ai-stack"
		"${STACK_BASEPATH}/DATA/aiwaifu-stack"
		"${STACK_BASEPATH}/DATA/arr-stack"
		"${STACK_BASEPATH}/DATA/essential-stack"
		"${STACK_BASEPATH}/DATA/jaison-stack"
		"${STACK_BASEPATH}/DATA/media-stack"
		"${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
		"${STACK_BASEPATH}/DATA/riko-stack"
		"${STACK_BASEPATH}/DATA"
	)
	for folder in "${FOLDERS[@]}"; do
		echo ""
		echo "Removing ${folder}"
		sudo rm -rf "${folder}"
	done
}
if [[ ${CLEANUP} == "true" ]]; then
	export BUILDING="recreate" # false, true, recreate
	CLEANUP_DATA
fi
