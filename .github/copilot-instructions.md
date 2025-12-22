# AI Stack Development Guidelines

## Project Architecture

This project is a modular Docker-based stack system with three implemented stacks: AI Stack, Essentials Stack, and OpenLLM VTuber Stack. Management and Media stacks are planned but not yet implemented.

### Stack Overview

1. **AI Stack (`STACKS/ai-stack/`)**: Orchestrates AI/ML services. Key services include AnythingLLM, Ollama, Faster-Whisper, Home Assistant, LibreTranslate, and various UI tools like Open WebUI, SwarmUI.

2. **Essentials Stack (`STACKS/essential-stack/`)**: Provides foundational services and infrastructure.

3. **OpenLLM VTuber Stack (`STACKS/openllm-vtuber-stack/`)**: Integrates AI with VTuber/streaming applications.

Each stack contains a `*-services/` directory with individual service configurations and a `compose-up.sh` script that builds using `docker compose` with multiple YAML files.

### Key Developer Workflows

- **Builds:** Run `./install-stack.sh` from the root to build and start all stacks. Individual stacks can be built via `STACKS/<stack>/install-stack.sh`.

- **Testing:** No centralized integration tests; service-specific testing varies.

- **Debugging:** Use `docker compose logs -f <service>` in the respective stack's services directory (e.g., `STACKS/ai-stack/ai-services/`). Logs are not centralized in `/var/log/`.

- **Service Communication:** Services communicate via Docker networks (e.g., `ai-services` network). Some expose REST APIs or web UIs on host ports.

### Project Conventions

- **Docker Compose:** Each stack uses `docker compose` (v2 syntax) with a base YAML and service-specific overrides. No root-level `docker-compose.yml`.

- **Naming Conventions:** Service names use kebab-case (e.g., `anything-llm`), variables in snake_case.

- **Configuration:** Managed via environment variables and `.env` files in service directories. Secrets stored in `SECRETS/` folder.

- **Data Storage:** Persistent data in `DATA/` subdirectories per stack/service. PostgreSQL used by services like Letta (connection via `letta_pg_password`).

### Integration Points

- **AnythingLLM**: Integrates with external APIs; configure in `STACKS/ai-stack/ai-services/anything-llm/.env`.

- **Ollama**: Local LLM hosting; ensure accessible from other services.

- **APIs:** Many services expose REST APIs (e.g., Ollama on port 11434, Open WebUI on 3000).

- **Volumes:** Data bound via Docker volumes to `../../../DATA/` relative paths.
