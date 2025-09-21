# VTuber TVS99 Manager

This folder provides tools for managing TVS99's `config.tvs.yml` for channel programming and scheduling, suitable for AI or automation.

## Features

- **Python CLI**: Add, remove, update, and list channels in the config file.
- **REST API**: Manage channels remotely via HTTP (FastAPI).
- **Scheduler**: Automatically update programming (titles, etc.) on a schedule.

## Usage

### 1. Python CLI

```bash
python config_manager.py --list
python config_manager.py --add 3 "VTuber Live" "/content/videos/vtuber.mp4"
python config_manager.py --remove 3
python config_manager.py --update 3 "Special Event"
```

### 2. REST API

```bash
pip install fastapi uvicorn pyyaml
uvicorn api:app --reload
```

- Endpoints:
  - `GET /channels` — List channels
  - `POST /channels` — Add channel
  - `PUT /channels/{number}` — Update channel
  - `DELETE /channels/{number}` — Remove channel

### 3. Scheduler

```bash
pip install schedule
python scheduler.py
```

- Edit `scheduler.py` to set your desired schedule and programming.

## Configuration

- By default, the config path is `../tvs99/config.tvs.yml` (set `TVS99_CONFIG` env var to override).

---

You can now:

- Integrate with your VTuber AI for dynamic programming
- Remotely manage TVS99 channels
- Automate show scheduling
