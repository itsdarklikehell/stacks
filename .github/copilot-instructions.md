# AI Stack Development Guidelines

## Project Architecture

This project is a modular Docker-based stack system with four main components: AI Stack, Essentials Stack, Management Stack, and Media Stack. Understanding the interconnections is key.

### Stack Overview

1.  **AI Stack (`ai-stack/`)**: Orchestrates AI/ML services. Key services:
    *   `AnythingLLM`: Document processing & LLM integration.
    *   `Ollama`: Local LLM hosting.
    *   `Faster-Whisper`: GPU-accelerated speech recognition.
    *   `Home Assistant`: IoT automation.
    *   `LibreTranslate`: Self-hosted translation.

2.  **Essentials Stack (`essentials-stack/`)**: Provides foundational services.

3.  **Management Stack**: Monitoring and control.

4.  **Media Stack**: Handling media assets.

### Key Developer Workflows

*   **Builds:** Use `docker-compose up --build` to build and start the stack.
*   **Testing:**  The `ai-stack` directory contains integration tests. Run them with `docker-compose run --service ai-stack integration-tests`.
*   **Debugging:** Utilize Docker's logging capabilities.  Logs are typically found in `/var/log/ai-stack/`.
*   **Service Communication:** Services primarily communicate via gRPC.  Inspect service definitions in the `ai-stack/` directory.

### Project Conventions

*   **Docker Compose:**  The `docker-compose.yml` file in the root directory defines the stack's services and their configurations.
*   **Naming Conventions:** Use snake\_case for all service names and variable names.
*   **Configuration:**  Configuration is primarily managed through environment variables.
*   **Data Storage:**  Data is stored in PostgreSQL databases.  Connection details are in the `docker-compose.yml` file.

### Integration Points

*   **AnythingLLM** integrates with external APIs for document processing. Refer to the `AnythingLLM` service definition for API keys and endpoints.
*   **Ollama** relies on a running Ollama instance. Ensure the Ollama server is accessible from the stack.
*   **gRPC:** Most services communicate via gRPC.  Use `grpcurl` to inspect gRPC calls.