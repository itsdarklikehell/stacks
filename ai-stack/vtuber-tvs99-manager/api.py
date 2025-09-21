
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import os
from config_manager import load_config, save_config, list_channels, add_channel, update_channel, remove_channel
from media.scan import scan_media

CONFIG_PATH = os.environ.get("TVS99_CONFIG", "../tvs99/config.tvs.yml")

app = FastAPI()

class Channel(BaseModel):
    number: int
    name: str
    title: str = ""
    video: str = ""

@app.get("/channels")
def get_channels():
    config = load_config(CONFIG_PATH)
    return list_channels(config)

@app.post("/channels")
def post_channel(channel: Channel):
    config = load_config(CONFIG_PATH)
    add_channel(config, channel.dict())
    save_config(config, CONFIG_PATH)
    return {"status": "ok"}

@app.put("/channels/{number}")
def put_channel(number: int, channel: Channel):
    config = load_config(CONFIG_PATH)
    update_channel(config, number, channel.dict())
    save_config(config, CONFIG_PATH)
    return {"status": "ok"}

@app.delete("/channels/{number}")
def delete_channel(number: int):
    config = load_config(CONFIG_PATH)
    remove_channel(config, number)
    save_config(config, CONFIG_PATH)
    return {"status": "ok"}

# New: List available media files
# New: List available media files
@app.get("/media")
def get_media():
    return scan_media()

# New: Get TVS99 program guide (channels with title/description)
@app.get("/program-guide")
def get_program_guide():
    config = load_config(CONFIG_PATH)
    guide = []
    for ch in config.get('channels', []):
        guide.append({
            'number': ch.get('number'),
            'name': ch.get('name'),
            'title': ch.get('title', ''),
            'description': ch.get('description', ''),
            'video': ch.get('video', ''),
        })
    return guide

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
