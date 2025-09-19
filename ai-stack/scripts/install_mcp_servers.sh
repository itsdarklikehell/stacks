#!/bin/bash
# Install additional MCP servers for the AI stack
function INSTALL_ADDITIONAL_MCP_SERVERS(){
    sudo apt update && sudo apt install -y pipx python3-venv 
    pipx ensurepath --force 
    pipx install argcomplete --force 
    
    echo "Installing Wikipedia MCP server..."
    pipx install wikipedia-mcp --force
    
    echo "Installing mcp-server-git..."
    pipx install mcp-server-git --force
    
    # echo "Installing mcp-server-memory..."
    # npx -y @modelcontextprotocol/server-memory
    
    # echo "Installing DuckDuckGo MCP server with Claude client..."
    # npx -y @smithery/cli install @nickclyde/duckduckgo-mcp-server
    
    echo "Installing Exa MCP server..."
    npm install -g exa-mcp-server
    
    echo "Installing MCP Discord bot..."
    npm install -g mcp-discord
    
    # echo "Installing MCP OpenWeather server..."
    # go build -o mcp-weather
    
    # echo "Installing ScrapeGraphAI MCP server with Claude client..."
    # npx -y @smithery/cli install @ScrapeGraphAI/scrapegraph-mcp
    
    # echo "Installing Wolfram Alpha MCP server..."
    # npx @wong2/mcp-cli -c "${WD}/MCP-wolfram-alpha/config.json"
    
    # echo "Installing Notion MCP server with Claude client..."
    # npx -y @smithery/cli install @makenotion/notion-mcp-server
    
    # echo "Installing Markdownify MCP server with Claude client..."
    # npx -y @smithery/cli install zcaceres/markdownify-mcp
    
    # echo "Installing YouTube Transcript MCP server with Claude client..."
    # npx -y @smithery/cli install @jkawamoto/mcp-youtube-transcript
    
    # echo "Installing dart-mcp-server..."
    # npx install -g dart-mcp-server
    
    # echo "Installing mcp-server-everything..."
    # npx install -g @modelcontextprotocol/server-everything
    
    # echo "Installing mcp-server-fetch..."
    # npx install -g @modelcontextprotocol/server-fetch
    
    # echo "Installing mcp-server-filesystem..."
    # npx install -g @modelcontextprotocol/server-filesystem
    
    # echo "Installing mcp-server-git..."
    # npx install -g @modelcontextprotocol/server-git
    
    # echo "Installing mcp-server-memory..."
    # npx install -g @modelcontextprotocol/server-memory
    
    # echo "Installing mcp-server-sequentialthinking..."
    # npx install -g @modelcontextprotocol/server-sequentialthinking
    
    
    # echo "Installing mcp-server-time..."
    # npx install -g @modelcontextprotocol/server-time
}
INSTALL_ADDITIONAL_MCP_SERVERS # 