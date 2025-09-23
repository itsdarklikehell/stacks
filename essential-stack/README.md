# AI Stack

This stack hosts AI models, agent management, and related tools. It is designed to support locally hosted AI agents (Ollama, Open-WebUI) and enable integration with chat, streaming, and automation platforms.

## Services Overview

- **Ollama**: Local LLM model server for running AI agents.
- **Open-WebUI**: Web interface for interacting with LLMs (Ollama, others).
- **comfyUI-manager**: Manages ComfyUI nodes and extensions for AI workflows.
- **basic-memory**: Knowledge and memory storage for agents.
- **dart-mcp-server**: MCP (Multi-Channel Platform) server for agent communication.
- **letta**: ADE (Agent Development Environment) for building and running advanced agents.
- **home-assistant**: Home automation integration (optional).
- **faster-whisper**: Fast speech-to-text for voice agent input.
- **open-llm-vtuber**: AI VTuber streaming and interaction platform.
- **mcp-discord**, **mcp-openweather**, **mcp-servers**, **mcp-wolfram-alpha**: MCP tools for external integrations (Discord, weather, server control, Wolfram Alpha).
- **tvs99**: Simulated TV station configuration and scheduling.

## Configuration & Integration

- All services are connected via shared Docker networks for agent communication.
- AI agents are defined in `.continue/agents/*.yaml` (see example configs).
- Ollama provides LLMs to Open-WebUI and agent backends.
- Open-WebUI is the main user interface for interacting with agents.
- MCP tools enable agents to perform actions (e.g., play games, fetch news, manage TV schedules).
- Letta ADE and open-llm-vtuber enable streaming and audience interaction (Twitch, YouTube).
- TVS99 manages TV channel and show scheduling; agents can update its config for dynamic programming.

## Usage

1. Edit `.continue/agents/*.yaml` to define your agents and connect them to MCP tools.
2. Run [install-stack.sh](http://_vscodecontentref_/2) to start all AI services.
3. Access Open-WebUI for chat and agent management.
4. Integrate with Twitch/YouTube by configuring open-llm-vtuber and Letta ADE.
5. Use MCP tools to extend agent capabilities (see each tool's README for setup).

---

## Vision

The goal is to create a locally hosted, AI-managed simulated TV station that streams to Twitch/YouTube, interacts with audiences, and autonomously manages programming, news, and entertainment using advanced AI agents and MCP tools.

---
