import yaml
import schedule
import time
import os
from config_manager import load_config, save_config, update_channel

CONFIG_PATH = os.environ.get("TVS99_CONFIG", "../tvs99/config.tvs.yml")

# Example schedule: {channel_number: [("08:00", "Morning Show"), ("20:00", "Evening Show")], ...}
CHANNEL_SCHEDULE = {
    1: [("08:00", "Morning News"), ("20:00", "Night News")],
    2: [("09:00", "Music Hour"), ("21:00", "Chill Beats")],
}

def set_channel_title(number, title):
    config = load_config(CONFIG_PATH)
    update_channel(config, number, {"title": title})
    save_config(config, CONFIG_PATH)
    print(f"Set channel {number} title to {title}")

def schedule_jobs():
    for ch, slots in CHANNEL_SCHEDULE.items():
        for t, title in slots:
            schedule.every().day.at(t).do(set_channel_title, ch, title)

if __name__ == "__main__":
    schedule_jobs()
    print("Scheduler started. Press Ctrl+C to exit.")
    while True:
        schedule.run_pending()
        time.sleep(10)
