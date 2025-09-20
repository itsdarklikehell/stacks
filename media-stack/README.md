# Media Stack

This stack provides all services for managing, serving, and streaming local media content. It is designed to be controlled by AI agents from the AI stack, enabling automated media requests, library management, and live streaming.

## Services Overview

- **plex**: Media server for movies, TV, and music.
- **jellyseerr** / **overseerr**: Media request management and approval.
- **calibre-web**: E-book library and server.
- **mylar3**: Comic book management and automation.
- **organizr**: Unified web dashboard for accessing all media services.
- **requestrr**: Chat-based media request bot (Discord, etc.).
- **retroarch** / **webrcade**: Game streaming and emulation.
- **whisparr**: Audiobook management.
- **tvs99**: Simulated TV station scheduling and channel management.
- **jellyseerr**: Alternative to Overseerr for media requests.
- **other directories**: Each corresponds to a specific media service or tool.

## Configuration & Integration

- All services are orchestrated via `docker compose` and share networks with the AI stack for agent control.
- Persistent data is stored in local volumes (see `compose.yaml`).
- Media libraries should be mounted into the relevant containers (e.g., Plex, Calibre-Web).
- Agents from the AI stack can interact with these services via APIs or direct integration (e.g., requesting media, updating TV schedules, managing streams).
- Organizr provides a single dashboard for accessing all media services.

## Usage

1. Edit `.env` and `compose.yaml` to set up paths, credentials, and network settings.
2. Run `./install-stack.sh` to start all media services.
3. Access the web UIs for each service via the ports defined in `compose.yaml`.
4. Integrate with the AI stack to enable agent-driven media management and streaming.

## Note

- The `.continue/agents` directory is not used in this project and can be removed.
- For agent integration, focus on API endpoints and service webhooks provided by each media service.

---

Let me know if you want further detail on any service, or if you’d like a similar update for other stack READMEs!# Media Stack

This stack provides all services for managing, serving, and streaming local media content. It is designed to be controlled by AI agents from the AI stack, enabling automated media requests, library management, and live streaming.

## Services Overview

- **plex**: Media server for movies, TV, and music.
- **jellyseerr** / **overseerr**: Media request management and approval.
- **calibre-web**: E-book library and server.
- **mylar3**: Comic book management and automation.
- **organizr**: Unified web dashboard for accessing all media services.
- **requestrr**: Chat-based media request bot (Discord, etc.).
- **retroarch** / **webrcade**: Game streaming and emulation.
- **whisparr**: Audiobook management.
- **tvs99**: Simulated TV station scheduling and channel management.
- **jellyseerr**: Alternative to Overseerr for media requests.
- **other directories**: Each corresponds to a specific media service or tool.

## Configuration & Integration

- All services are orchestrated via `docker compose` and share networks with the AI stack for agent control.
- Persistent data is stored in local volumes (see `compose.yaml`).
- Media libraries should be mounted into the relevant containers (e.g., Plex, Calibre-Web).
- Agents from the AI stack can interact with these services via APIs or direct integration (e.g., requesting media, updating TV schedules, managing streams).
- Organizr provides a single dashboard for accessing all media services.

## Usage

1. Edit `.env` and `compose.yaml` to set up paths, credentials, and network settings.
2. Run `./install-stack.sh` to start all media services.
3. Access the web UIs for each service via the ports defined in `compose.yaml`.
4. Integrate with the AI stack to enable agent-driven media management and streaming.
