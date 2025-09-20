# Management Stack

This stack provides core infrastructure, monitoring, and management tools for your AI and media services. It is designed to be modular and integrates with other stacks (AI, media) via shared Docker networks.

## Services Overview

- **autoheal**: Monitors and automatically restarts unhealthy containers.
- **uptime-kuma**: Uptime monitoring and status page for all services.
- **netdata**: Real-time performance and health monitoring dashboard.
- **n8n**: Workflow automation and integration platform.
- **dashy**: Customizable dashboard for quick access to services.
- **dockge**: Web UI for managing Docker Compose stacks.
- **portainer**: Web UI for managing Docker containers and images.
- **nginx-proxy-manager**: Reverse proxy with SSL support for exposing services.
- **grafana**: Visualization and analytics for metrics (integrates with Netdata, Uptime Kuma, etc.).
- **docker-proxy**: Secure proxy for Docker socket, used by monitoring tools.
- **portracker**: Tracks and visualizes open ports and services.
- **nextcloud**: Self-hosted file sharing and collaboration platform.
- **nextclouddb**: MariaDB database for Nextcloud.
- **collabora**: Online office suite, integrates with Nextcloud.
- **redis**: In-memory data store, used by Nextcloud and other services.
- **wg-easy**: Simple WireGuard VPN server for secure remote access.
- **watchtower**: Automated updates for running containers.

## Configuration & Integration

- All services are orchestrated via `docker compose` and share networks (`ai-stack`, `management-stack`, `kuma_network`, `cloud`) for seamless communication.
- Environment variables are set in `.env` files; adjust these for passwords, domains, and user IDs.
- Persistent data is stored in local volumes (see `volumes:` section in `compose.yaml`).
- Reverse proxy (nginx-proxy-manager) exposes web UIs securely.
- Monitoring tools (Netdata, Grafana, Uptime Kuma) are pre-integrated for unified observability.
- Nextcloud and Collabora are linked for document editing; Nextcloud uses Redis and MariaDB for performance and storage.
- Dockge and Portainer provide web-based Docker management.

## Usage

1. Copy and edit `.env` as needed.
2. Run `./install-stack.sh` to set up and start all services.
3. Access dashboards via the exposed ports (see `compose.yaml` for mappings).
4. Integrate with other stacks by ensuring shared networks are present.
