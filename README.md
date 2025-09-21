# Project Goal

This project aims to create a modular, locally hosted platform for AI-driven media creation, management, automation, interaction and entertainment. The ultimate vision is to enable advanced AI agents—powered by Letta and localy hosted LLMs (or online, if you want to connect) using Ollama, Open-WebUI, Letta and MCP tools—to autonomously manage, curate, and stream content across platforms like Twitch and YouTube.

Key objectives include:
- Provide seamless integration of AI agents with media server management, dashboards, and automation tools.
- Automated handling of live-chat interaction, handling media requests, scheduling broadcasting, and live streaming.
- Interactive audience engagement via Twitch-chat with VTuber Live2D avatars using Open-LLM-VTuber, and simulated TV station management with Letta.
- Extensible architecture for adding new services, agent capabilities, and integration points.

The stack is designed for privacy, flexibility, and full local control, making it ideal for experimentation, self-hosted entertainment, and research into AI-driven content creation.

## Usage

1. Copy and edit the `.env` file as needed for your environment (set passwords, domains, user IDs, etc).
2. Run `./install-stack.sh` to set up and start all services in this stack.
3. Access dashboards and web UIs via the ports defined in `compose.yaml` (e.g., Netdata, Grafana, Portainer, Nextcloud).
4. Ensure required Docker networks (`ai-stack`, `management-stack`, `kuma_network`, `cloud`) exist and are set as `external: true` in all relevant `compose.yaml` files.  
   - If missing, create them with:

     ```bash
     docker network create ai-stack
     docker network create management-stack
     docker network create kuma_network
     docker network create cloud
     ```

5. To integrate with other stacks (AI, media), simply bring up those stacks, services should auto-discover each other via the shared networks.
6. For troubleshooting, use Portainer or Dockge to inspect containers, logs, and network connections.
7. To update services, rerun `./install-stack.sh` or use Watchtower for automated updates.
8. For backup and recovery, ensure persistent volumes are included in your backup routine (see `volumes:` in `compose.yaml`).

---

**Tip:**  
If you add new stacks or services, always connect them to the appropriate shared networks for seamless integration and agent control.