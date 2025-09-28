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

### Key Components

1. Stack Structure

   - Each stack has its own `install-stack.sh` and service definitions
   - Services are defined in individual docker-compose files under `{stack}/services/`
   - Persistent data is stored in `{stack}/DATA/` directories

2. Network Architecture
   - Segregated Service Networks:
     - `ai-services`: AI and ML service communication
     - `media-services`: Media processing and streaming
     - `management-services`: Monitoring and admin tools
     - `essential-services`: Core infrastructure
   - Special Networks:
     - `iot_macvlan`: Direct IoT device communication (uses physical network)
   - Cross-Stack Communication:
     - Services can join multiple networks when needed
     - Use `networks:` directive in compose files
     - Reference `base.docker-compose.yaml` for default network config

## Development Workflows

### Installation

1. Initial Setup:

   ```bash
   ./scripts/install_drivers.sh    # Install required drivers
   ./scripts/install_docker.sh     # Setup Docker environment
   ./scripts/create_networks.sh    # Create Docker networks
   ./scripts/create_secrets.sh     # Configure secrets
   ```

2. Stack Deployment:
   ```bash
   ./install-stack.sh             # Install all stacks
   # Or individual stacks:
   ./ai-stack/install-stack.sh
   ```

### Service Management

#### Service Organization

- Each service has a dedicated compose file: `{service-name}.docker-compose.yaml`
- Enable/disable services by commenting entries in `compose-up.sh`
- Services are organized by function into appropriate stacks

#### Configuration Management

1. Environment Variables

   - Stack-level: `.env` in stack root
   - Service-level: `{service}/.env` for service-specific config
   - Use `.env.example` files as templates

2. Secrets Management

   - Sensitive data stored in `secrets/` directory
   - Reference secrets in compose files using `secrets:` directive
   - Follow pattern: `{service}_{secret_name}`

3. Volume Management

   - Persistent data under `DATA/{service}/`
   - Backup volumes: `DATA/backups/{service}/`
   - Config volumes: `DATA/config/{service}/`

4. Resource Allocation
   - CPU/Memory limits in compose files
   - GPU passthrough for AI services
   - Network resource management

## Best Practices

1. Service Modularity

   - Keep each service in its own docker-compose file
   - Use `base.docker-compose.yaml` for shared configurations
   - Follow the naming pattern: `{service-name}.docker-compose.yaml`

2. Configuration

   - Store sensitive data in `secrets/` directory
   - Use environment files for service configuration
   - Follow the network segregation pattern for service isolation

3. Data Management
   - Store persistent data under `DATA/` directories
   - Use consistent volume naming: `{stack}_{service}_data`

## Development Operations

### Service Deployment

1. Adding a New Service

   - Create `{service-name}.docker-compose.yaml` in appropriate stack
   - Add service entry to stack's `compose-up.sh`
   - Create necessary data directories in `DATA/`
   - Configure networks and dependencies
   - Add any required secrets to `secrets/`

2. Service Dependencies

   - Use `depends_on` in compose files for startup order
   - Implement health checks for critical services
   - Consider shared resources (databases, caches)
   - Document external dependencies

3. Resource Management
   - Configure resource limits in compose files
   - Monitor resource usage with management stack
   - Scale services based on workload
   - Manage GPU allocation for AI services

### Troubleshooting Guide

1. Service Issues

   - Check logs: `docker-compose logs {service-name}`
   - Verify container status: `docker ps -a`
   - Review resource usage: `docker stats`
   - Check volume mounts: `docker inspect {container}`

2. Network Troubleshooting

   - Test connectivity: `docker network inspect`
   - Verify DNS resolution between services
   - Check network isolation
   - Monitor network resource usage

3. Data Management
   - Verify volume permissions
   - Check backup status
   - Monitor disk usage
   - Validate data persistence
