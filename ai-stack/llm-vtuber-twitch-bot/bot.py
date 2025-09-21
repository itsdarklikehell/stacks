import os
import asyncio
from twitchio.ext import commands
import websockets
import json

TWITCH_CHANNEL = os.environ.get("TWITCH_CHANNEL")
TWITCH_BOT_OAUTH = os.environ.get("TWITCH_BOT_OAUTH")
VTUBER_API_URL = os.environ.get("VTUBER_API_URL", "ws://open-llm-vtuber:3000/api/ws")

class Bot(commands.Bot):
    def __init__(self):
        super().__init__(
            token=TWITCH_BOT_OAUTH,
            prefix="!",
            initial_channels=[TWITCH_CHANNEL]
        )

    async def event_ready(self):
        print(f"Logged in as | {self.nick}")

    async def event_message(self, message):
        if message.echo:
            return
        print(f"Message from {message.author.name}: {message.content}")
        # Forward message to VTuber API
        await send_to_vtuber(message.content, message.author.name)

async def send_to_vtuber(text, username):
    try:
        async with websockets.connect(VTUBER_API_URL) as ws:
            payload = json.dumps({"username": username, "message": text})
            await ws.send(payload)
    except Exception as e:
        print(f"Error sending to VTuber: {e}")

if __name__ == "__main__":
    bot = Bot()
    bot.run()
