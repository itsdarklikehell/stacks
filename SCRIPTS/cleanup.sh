#!/bin/bash

echo "Cleanup script started."
echo "CLEANUP is set to: ${CLEANUP}"

cd "${STACK_BASEPATH}" || exit

function CLEANUP_DATA() {
	FOLDERS=(
		"${STACK_BASEPATH}/DATA/ai-stack"
		"${STACK_BASEPATH}/DATA/essential-stack"
		"${STACK_BASEPATH}/DATA/openllm-vtuber-stack"
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
