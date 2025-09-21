import requests
import os

# Example: Use the REST API to add a channel and update programming from AI logic
API_URL = os.environ.get("TVS99_API_URL", "http://localhost:8000")

def add_channel(number, name, title, video):
    resp = requests.post(f"{API_URL}/channels", json={
        "number": number,
        "name": name,
        "title": title,
        "video": video
    })
    print("Add channel:", resp.status_code, resp.json())

def update_channel_title(number, title):
    resp = requests.put(f"{API_URL}/channels/{number}", json={
        "number": number,
        "name": "AI Channel",
        "title": title,
        "video": "/content/videos/ai.mp4"
    })
    print("Update channel:", resp.status_code, resp.json())

if __name__ == "__main__":
    # Example: Add a new channel from AI logic
    add_channel(99, "AI Channel", "AI Live Show", "/content/videos/ai.mp4")
    # Example: Update programming title
    update_channel_title(99, "AI Special Event")
