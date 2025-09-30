# AI Stack Development Guidelines

## Project Architecture

This project is organized as a modular Docker-based stack system with four main components, each designed for specific functionality and scalability:

### Stack Overview

1. AI Stack (`ai-stack/`)
   - Purpose: AI and ML service orchestration
   - Key Services:
     - AnythingLLM: Document processing and LLM integration
     - Ollama: Local LLM hosting
     - Faster-Whisper: GPU-accelerated speech recognition
     - Home Assistant: IoT automation integration
     - LibreTranslate: Self-hosted translation services

2. Essentials Stack (`essentials-stack/`)
   - Purpose: Core infrastructure and shared services
   - Components:
     - Base networking configuration
     - Shared storage services
     - Authentication systems
     - Common utilities

3. Management Stack (`management-stack/`)
   - Purpose: System monitoring and operations
   - Features:
     - Service health monitoring
     - Resource usage tracking
     - Log aggregation
     - Backup management

4. Media Stack (`media-stack/`)
   - Purpose: Media processing and serving
   - Capabilities:
     - Media transcoding
     - Content delivery
     - Stream processing
     - Media storage management

### Development Environment

1. Prerequisites:
   ```bash
   # Required tools are installed via scripts:
   ./scripts/install_docker.sh     # Docker + lazydocker + dockly
   ./scripts/install_drivers.sh    # GPU and system drivers
   ./scripts/install_uv.sh        # Python package installer
   ```

2. Network Architecture:
   - Segmented Service Networks:
     - `ai-services`: AI and ML service communication
     - `media-services`: Media processing and streaming
     - `management-services`: Monitoring and admin tools
     - `essential-services`: Core infrastructure
   - Special Networks:
     - `iot_macvlan`: Direct IoT device communication (uses physical network)
   - Cross-Stack Communication:
     - Services can join multiple networks when needed
     - Use `networks:` directive in compose files
     - Reference `base.docker-compose.yaml` for default config

### Service Management

1. Service Structure:
   - Each service has its own directory with configuration files:
     ```
     service-name/
     ├── docker-compose.yaml   # Service-specific compose file
     ├── .env                 # Service-specific environment variables
     └── .env.example        # Template for environment variables
     ```
   - Reference `base.docker-compose.yaml` for shared configs
   - Service definitions follow pattern:
     ```yaml
     name: service-name
     networks:
       - stack-specific-network
     volumes:
       - ../../../DATA/service-name:/data
     env_file:
       - ./service-name/.env
     ```

2. Configuration:
   - Environment: `.env` in stack root and service-specific
   - Secrets: Store in `secrets/` as `{service}_{secret_name}`
   - Data: Persist in `DATA/{service}/` with consistent naming

### Common Operations

1. Service Deployment:
   ```bash
   # Deploy entire stack
   ./install-stack.sh
   
   # Deploy specific stack
   ./ai-stack/install-stack.sh
   ```

2. Service Management:
   ```bash
   # View service logs
   docker-compose -f service.docker-compose.yaml logs
   
   # Monitor resources
   docker stats
   # or use lazydocker/dockly for TUI monitoring
   ```

3. Troubleshooting:
   - Check service health: `docker ps -a`
   - Inspect networks: `docker network inspect ai-services`
   - Verify volumes: `docker volume ls`

## Best Practices

1. Service Modularity

   - Keep each service in its own docker-compose file
   - Use `base.docker-compose.yaml` for shared configurations

### Critical Patterns

1. Service Dependencies:
   - Define in compose files using `depends_on`
   - Implement health checks for critical services
   - Document external dependencies

2. Resource Management:
   - Set container limits in compose files
   - Configure GPU passthrough for AI services
   - Monitor via management stack tools

3. Data Management:
   - Use consistent volume naming: `{stack}_{service}_data`
   - Regular backup validation
   - Monitor disk usage and cleanup

### Development Tips

1. When adding services:
   - Place in appropriate directory
   - Update corresponding `compose-up.sh`
   - Create required data directories
   - Document dependencies and configuration

2. Networking:
   - Use appropriate network segmentation
   - Document required cross-service communication
   - Implement proper health checks

3. Configuration:
   - Follow established patterns for env vars and secrets
   - Document all required environment variables
   - Use templates and examples for new services