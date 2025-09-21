
# VTuber Twitch Bot & Streaming Checklist

This bot connects to Twitch chat and forwards messages to the Open-LLM-VTuber web app via WebSocket. This README also includes a step-by-step checklist for streaming Open-LLM-VTuber to Twitch and automation tips.

---

## Step-by-Step Checklist: Streaming Open-LLM-VTuber to Twitch

### 1. Prerequisites

- [ ] Docker and Docker Compose installed
- [ ] Twitch account and access to your Stream Key
- [ ] (Optional) Twitch bot OAuth token and channel name for chat integration

### 2. Configure Environment Variables

- [ ] Copy `.env.example` to `.env` in the `ai-stack` directory (if not already present)
- [ ] Set your Twitch stream key:

  ```env
  TWITCH_STREAM_KEY=your_twitch_stream_key_here
  ```

- [ ] (Optional) Set chat bot variables:

  ```env
  TWITCH_CHANNEL=your_channel_name
  TWITCH_BOT_OAUTH=oauth:your_oauth_token
  ```

### 3. Build and Start the Stack

- [ ] From the `ai-stack` directory, run:

  ```bash
  docker compose -f compose.llm-vtuber-twitch.yaml up --build
  ```

- [ ] Wait for all containers to start. The streamer will launch Chromium and ffmpeg automatically.

### 4. Go Live

- [ ] Visit your Twitch channel dashboard. You should see the Open-LLM-VTuber web app streaming live.

### 5. (Optional) Chat Bot Integration

- [ ] The `vtuber-twitch-bot` container will connect to your channel and interact with chat if configured.

### 6. Troubleshooting

- [ ] Check logs for errors:

  ```bash
  docker compose -f compose.llm-vtuber-twitch.yaml logs vtuber-streamer
  ```

- [ ] Ensure your stream key is correct and not expired.
- [ ] Adjust resolution or ffmpeg parameters in the compose file if needed.

---

## Further Automation Ideas

- **CI/CD Integration:**
  - Add a GitHub Actions workflow to build and test the stack on push.
  - Example: Lint Dockerfiles, validate compose YAML, and optionally run headless tests.
- **Healthchecks:**
  - Add healthchecks to all services in `compose.llm-vtuber-twitch.yaml` for robust orchestration.
- **Secrets Management:**
  - Use Docker secrets for sensitive values (stream key, bot OAuth) in production.
- **Auto-Restart:**
  - Ensure `restart: unless-stopped` is set for all critical services.
- **Monitoring:**
  - Integrate with Prometheus/Grafana or use Docker monitoring tools for uptime and resource usage.
- **Automated Redeploy:**
  - Use webhooks or CI to auto-redeploy on code changes.

---

For more details, see the main project README and Docker Compose file comments.

---


## Usage


1. Set the following environment variables (in your `.env` or Compose file):


- `TWITCH_CHANNEL`: Your Twitch channel name (without #)
- `TWITCH_BOT_OAUTH`: Your Twitch OAuth token (get from [TwitchApps TMI][tmi-link])
- `VTUBER_API_URL`: WebSocket URL for Open-LLM-VTuber (default: `ws://open-llm-vtuber:3000/api/ws`)

1. Build and run with Docker Compose (see parent stack).


## How it works


- Listens to all chat messages in your channel.
- Forwards each message (with username) to the VTuber app via WebSocket.
- The VTuber app can use this to trigger TTS, animations, or other actions.

---


### Connecting the Bot to Open-LLM-VTuber

1. **Start Open-LLM-VTuber**

- Make sure the web app is running and accessible at `http://open-llm-vtuber:3000` (or update the bot’s `VTUBER_API_URL`).

2. **Build and Start the Bot**

- The provided Dockerfile and Compose service will build and run the bot automatically.
- The bot will connect to Twitch chat and the VTuber WebSocket API.

3. **Configure Open-LLM-VTuber to Accept WebSocket Messages**

- By default, the bot sends messages to `/api/ws`.
- Ensure your Open-LLM-VTuber instance is configured to accept and process chat messages from this endpoint.
- You may need to enable or configure chat triggers in the Open-LLM-VTuber web UI or config.

4. **Test the Integration**

- Send a message in your Twitch chat.
- The bot should log the message and forward it to the VTuber app.
- The VTuber app should react (e.g., TTS, animation, etc.).

---

## Troubleshooting

- Check logs for connection errors (Twitch or WebSocket).
- Make sure all environment variables are set correctly.
- Ensure network connectivity between the bot and the VTuber container.

[tmi-link]: https://twitchapps.com/tmi/

## Usage

1. Set the following environment variables (in your `.env` or Compose file):
   - `TWITCH_CHANNEL`: Your Twitch channel name (without #)
   - `TWITCH_BOT_OAUTH`: Your Twitch OAuth token (get from https://twitchapps.com/tmi/)
   - `VTUBER_API_URL`: WebSocket URL for Open-LLM-VTuber (default: `ws://open-llm-vtuber:3000/api/ws`)

2. Build and run with Docker Compose (see parent stack).

## How it works
- Listens to all chat messages in your channel.
- Forwards each message (with username) to the VTuber app via WebSocket.
- The VTuber app can use this to trigger TTS, animations, or other actions.

---

# Step-by-Step: Connecting the Bot to Open-LLM-VTuber

1. **Start Open-LLM-VTuber**
   - Make sure the web app is running and accessible at `http://open-llm-vtuber:3000` (or update the bot’s `VTUBER_API_URL`).

2. **Build and Start the Bot**
   - The provided Dockerfile and Compose service will build and run the bot automatically.
   - The bot will connect to Twitch chat and the VTuber WebSocket API.

3. **Configure Open-LLM-VTuber to Accept WebSocket Messages**
   - By default, the bot sends messages to `/api/ws`.
   - Ensure your Open-LLM-VTuber instance is configured to accept and process chat messages from this endpoint.
   - You may need to enable or configure chat triggers in the Open-LLM-VTuber web UI or config.

4. **Test the Integration**
   - Send a message in your Twitch chat.
   - The bot should log the message and forward it to the VTuber app.
   - The VTuber app should react (e.g., TTS, animation, etc.).

---

## Troubleshooting
- Check logs for connection errors (Twitch or WebSocket).
- Make sure all environment variables are set correctly.
- Ensure network connectivity between the bot and the VTuber container.
