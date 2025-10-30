#!/bin/bash
echo "Cleanup script started."
echo "CLEANUP is set to: ${CLEANUP}"

echo "Working directory is set to ${WD}"
cd "${WD}" || exit


function CLEANUP_DATA() {
	FOLDERS=(
		"${PERM_DATA}/airi-stack"
		"${PERM_DATA}/ai-stack"
		"${PERM_DATA}/aiwaifu-stack"
		"${PERM_DATA}/arr-stack"
		"${PERM_DATA}/essential-stack"
		"${PERM_DATA}/jaison-stack"
		"${PERM_DATA}/media-stack"
		"${PERM_DATA}/openllm-vtuber-stack"
		"${PERM_DATA}/riko-stack"
		"${PERM_DATA}"
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
