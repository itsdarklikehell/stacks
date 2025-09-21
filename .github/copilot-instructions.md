# Copilot Instructions for the Stacks Monorepo

## Big Picture Architecture

- The monorepo is a modular, locally hosted platform for AI-driven media creation, management, automation, and entertainment. AI agents (Letta, Open-WebUI, Ollama, MCP tools) autonomously manage and stream content (e.g., Twitch, YouTube), interact with live chat, and schedule programming (TVS99).
- Major stacks:
  - `ai-stack`: AI agents, LLMs, agent orchestration, MCP tools, VTuber/TVS99 management
  - `media-stack`: Media servers (Plex, Jellyfin, etc.), streaming, library management
  - `management-stack`: Monitoring, dashboards, reverse proxy, infrastructure
- All stacks use their own `compose.yaml` and `.env` files, and communicate via shared Docker networks (`ai-stack`, `management-stack`, `kuma_network`, `cloud`).
- Unified dashboards (`ai-stack/unified-dashboard/`) provide web UIs for managing bots, TVS99, and media.

## Developer Workflows

- **Setup:**
  - Copy `.env.example` to `.env` in each stack and fill in secrets/paths.
  - Run `./install-stack.sh` in the stack root to build and start all services.
  - Ensure required Docker networks exist (see stack README for commands to create them).
- **Testing:**
  - Manual: Use checklists in each stack's `README.md` (e.g., dashboard loads, bot connects, media streams).
  - Automated: Some FastAPI endpoints and bots have test scripts or checklists in their README.
- **Debugging:**
  - Use Portainer, Dockge, or `docker compose logs` for troubleshooting.
  - Persistent data is in named volumes; see `volumes:` in each `compose.yaml`.

## Project-Specific Conventions

- All secrets and config values are managed via `.env` (see `# SECRETS` block at the top).
- Docker Compose files use variable substitution for all configurable values; never hardcode secrets.
- Resource limits are set via `deploy.resources` (not `mem_limit`).
- Healthchecks are defined for most services; add if missing.
- Each service in `compose.yaml` has a comment block describing its purpose and best practices.
- For agent/AI integration, see `.continue/agents/*.yaml` and MCP tool configs.
- For TVS99/VTuber management, see `ai-stack/vtuber-tvs99-manager/` and `ai-stack/unified-dashboard/`.

## Integration Points & Patterns

- AI agents interact with media and automation services via REST APIs, WebSockets, and shared Docker networks.
- MCP tools (Discord, OpenWeather, Wolfram Alpha, etc.) are pluggable and configured via YAML and `.env`.
- Unified dashboards aggregate status, logs, and controls for bots and TVS99.
- Media stack services (Plex, Jellyfin, etc.) are controlled by agents via API/webhooks.
- Management stack provides monitoring, dashboards, and reverse proxy for all stacks.

## Key Files & Directories

- `ai-stack/compose.yaml`, `media-stack/compose.yaml`, `management-stack/compose.yaml`: Main orchestration files for each stack.
- `ai-stack/unified-dashboard/`: FastAPI web UI for bot/TVS99/media management.
- `ai-stack/vtuber-tvs99-manager/`: Tools for TVS99 config/programming.
- `.env` in each stack: All secrets and config values.
- `install-stack.sh`: Main entry point for setup and orchestration.
- `README.md` in each stack: Service overviews, usage, and troubleshooting.

## Example Patterns

- To add a new service: Copy an existing service block in `compose.yaml`, follow the comment template, and update variables.
- To add a new agent: Define in `.continue/agents/*.yaml` and connect to MCP tools as needed.
- To extend dashboards: Add endpoints/UI to `unified-dashboard/app.py` and `templates/`.

---

For more details, see the stack-specific `README.md` files and comments in each `compose.yaml`.
