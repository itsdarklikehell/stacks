#!/bin/bash
# Create necessary folders for AI stack
function CLONE_REPOS(){
    # Clone or pull latest changes for each repository
    declare -A repos=(
        ["dart-mcp-server"]="https://github.com/its-dart/dart-mcp-server.git"
        ["letta"]="https://github.com/letta-ai/letta.git"
        ["markdownify-mcp"]="https://github.com/zcaceres/markdownify-mcp.git"
        ["mcp-discord"]="https://github.com/barryyip0625/mcp-discord.git"
        ["mcp-openweather"]="https://github.com/mschneider82/mcp-openweather.git"
        ["mcp-servers"]="https://github.com/modelcontextprotocol/servers.git"
        ["mcp-wolfram-alpha"]="https://github.com/SecretiveShell/MCP-wolfram-alpha.git"
        ["open-llm-vtuber"]="https://github.com/Open-LLM-VTuber/Open-LLM-VTuber.git"
        ["stable-diffusion-webui-docker"]="https://github.com/AbdBarho/stable-diffusion-webui-docker.git"
        ["swarmui"]="https://github.com/mcmonkeyprojects/SwarmUI.git"
        ["comfyUI-manager"]="https://github.com/Comfy-Org/ComfyUI-Manager.git"
    )
    for repo in "${!repos[@]}"; do
        if [ -d "${WD}/${repo}" ]; then
            echo "Repository ${repo} already exists, pulling latest changes..."
            git -C "${WD}/${repo}" pull
        else
            echo "Cloning repository ${repo}..."
            git clone --recursive --quiet "${repos[$repo]}" "${WD}/${repo}"
        fi
    done
    
    ln -sf "${WD}/ComfyUI-Manager" "${WD}/swarmui/dlbackend/ComfyUI/custom_nodes" &>/dev/null

}
CLONE_REPOS 