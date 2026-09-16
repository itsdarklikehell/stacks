# Stacks — README

Overview

- **Purpose**: This repository contains a modular, Docker-based stack system for AI, Essentials, Management, and Media services.
- **Main Components**: AI Stack, Essentials Stack, Management Stack, Media Stack.

**Quick Start**

- **Build & start**: Use `docker-compose up --build` to build and start the stacks.
- **Stop**: Use `docker-compose down`.
- **Logs**: Check runtime logs via Docker or in `/var/log/ai-stack/` for AI-stack logs.

**Stacks**

- **AI Stack**: [STACKS/ai-stack/](STACKS/ai-stack/) — Orchestrates AI/ML services including:
  - **AnythingLLM**: Document processing and LLM integration.
  - **Ollama**: Local LLM hosting.
  - **Faster-Whisper**: GPU-accelerated speech recognition.
  - **Home Assistant**: IoT automation.
  - **LibreTranslate**: Self-hosted translation.
- **Essentials Stack**: [STACKS/essential-stack/](STACKS/essential-stack/) — Foundational services and infrastructure.

**Key Commands**

- Build and start all services:

```bash
docker-compose up --build
```

- Run integration tests for the AI Stack:

```bash
docker-compose run --service ai-stack integration-tests
```

**Configuration**

- **Env vars**: Configuration is managed via environment variables.
- **Datastores**: PostgreSQL is used for persistent storage; connection settings live in each stack's compose files under `STACKS/<stack>/ai-services/<service>/docker-compose.yaml`.
- **Networking**: Services communicate via gRPC where applicable.

**Conventions**

- **Naming**: Use snake_case for service names and variables.
- **Files**: Each stack's services and volumes are defined via Docker Compose files under `STACKS/<stack-name>/`.
- **Code style**: Follow existing project conventions per stack.

**Integration Points**

- **AnythingLLM**: Integrates with external APIs for document processing (check service definition in [STACKS/ai-stack/](STACKS/ai-stack/)).
- **Ollama**: Requires an accessible Ollama server.
- **gRPC**: Multiple services use gRPC; use `grpcurl` for service inspection and debugging.

**Debugging & Logging**

- **Docker logs**: `docker-compose logs -f <service>`
- **Local logs**: Check `/var/log/ai-stack/` for AI-stack-specific logs.
- **gRPC debug**: Use `grpcurl` for schema inspection and call testing.

**Testing**

- **Integration tests**: In the `ai-stack` directory; run them with the `docker-compose run` command mentioned above.
- **Test location**: [STACKS/ai-stack/](STACKS/ai-stack/) contains test configuration and scripts.

**Contributing**

- **Workflow**: Fork, create a feature branch, open a PR with clear description and relevant tests.
- **Code review**: Add commit and PR descriptions with reproducible steps.

**License**

- **Status**: No license file mentioned in this README — add a `LICENSE` file if you want to publish under a specific license.

**Dutch Version**

- A Dutch translation is not yet available in this repository.


---

## 🎥 Gource Visualization

De ontwikkelhistorie van dit project in een film:

<video src="https://raw.githubusercontent.com/itsdarklikehell/stacks/main/gource.mp4" controls width="100%"></video>

*De video wordt automatisch gegenereerd door de [Gource workflow](.github/workflows/gource.yml) bij elke push.*

Lokale video genereren:
```bash
gource --max-files 1000 --key -800x600 \
  --highlight-users --filename-time 3 --output-framerate 25 \
  -s 0.6 --multi-sampling --auto-skip-seconds 0.1 \
  --stop-at-end --hide mouse,progress -o gource.ppm

ffmpeg -y -r 15 -f image2pipe -vcodec ppm -i gource.ppm \
  -vcodec libx264 -preset medium -pix_fmt yuv420p \
  -crf 1 -threads 0 -bf 0 gource.mp4
```
