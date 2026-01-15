# Stacks — README

Overview

- **Purpose**: This repository contains a modular, Docker-based stack system for AI, Essentials, Management, and Media services.
- **Main Components**: AI Stack, Essentials Stack, Management Stack, Media Stack.

**Quick Start**

- **Build & start**: Use `docker-compose up --build` to build and start the stacks.
- **Stop**: Use `docker-compose down`.
- **Logs**: Check runtime logs via Docker or in `/var/log/ai-stack/` for AI-stack logs.

**Stacks**

- **AI Stack**: [ai-stack/](ai-stack/) — Orchestrates AI/ML services including:
  - **AnythingLLM**: Document processing and LLM integration.
  - **Ollama**: Local LLM hosting.
  - **Faster-Whisper**: GPU-accelerated speech recognition.
  - **Home Assistant**: IoT automation.
  - **LibreTranslate**: Self-hosted translation.
- **Essentials Stack**: [essential-stack/](essential-stack/) — Foundational services and infrastructure.

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
- **Datastores**: PostgreSQL is used for persistent storage; connection settings are in the compose configuration ([docker-compose.yml](docker-compose.yml) if present).
- **Networking**: Services communicate via gRPC where applicable.

**Conventions**

- **Naming**: Use snake_case for service names and variables.
- **Files**: Docker Compose at the root level defines services and volumes.
- **Code style**: Follow existing project conventions per stack.

**Integration Points**

- **AnythingLLM**: Integrates with external APIs for document processing (check service definition in [ai-stack/](ai-stack/)).
- **Ollama**: Requires an accessible Ollama server.
- **gRPC**: Multiple services use gRPC; use `grpcurl` for service inspection and debugging.

**Debugging & Logging**

- **Docker logs**: `docker-compose logs -f <service>`
- **Local logs**: Check `/var/log/ai-stack/` for AI-stack-specific logs.
- **gRPC debug**: Use `grpcurl` for schema inspection and call testing.

**Testing**

- **Integration tests**: In the `ai-stack` directory; run them with the `docker-compose run` command mentioned above.
- **Test location**: [ai-stack/](ai-stack/) contains test configuration and scripts.

**Contributing**

- **Workflow**: Fork, create a feature branch, open a PR with clear description and relevant tests.
- **Code review**: Add commit and PR descriptions with reproducible steps.

**License**

- **Status**: No license file mentioned in this README — add a `LICENSE` file if you want to publish under a specific license.

**Dutch Version**

For documentation in Dutch, see [LEESMIJ.md](LEESMIJ.md).

