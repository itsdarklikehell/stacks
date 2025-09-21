# Unified Dashboard for Twitch Bot & TVS99

A single web dashboard to manage both your Twitch streaming/chat bot and TVS99 (virtual TV station) config, programming, and media.

## Features
- Twitch bot status, logs, and live chat monitoring
- TVS99 config and programming browser
- Media discovery and management
- Unified authentication and web UI

## Setup

### Prerequisites
- Python 3.9+
- Node.js (for bot/streaming, if required)
- Docker (optional, for containerized deployment)

### Install dependencies
```bash
cd ai-stack/unified-dashboard
pip install fastapi uvicorn pyyaml
# For TVS99 integration:
pip install pydantic
# For bot process status:
pip install psutil
```

### Directory structure
```
ai-stack/unified-dashboard/
  app.py              # FastAPI backend
  templates/
    dashboard.html    # Main dashboard UI
    login.html        # Login page
  static/
    style.css         # CSS
    app.js            # JS for dashboard
```

### Running the dashboard
```bash
cd ai-stack/unified-dashboard
uvicorn app:app --reload --host 0.0.0.0 --port 8100
```
Visit [http://localhost:8100](http://localhost:8100) in your browser.

### Environment variables
- `TVS99_CONFIG`: Path to TVS99 config YAML (default: `../tvs99/config.tvs.yml`)
- `BOT_CONFIG`, `BOT_LOG_PATH`, `BOT_CHAT_PATH`: For bot integration (if needed)

## Usage
- Log in with the default credentials (`admin`/`changeme`)
- Use the tabs to view Twitch bot status, logs, chat, TVS99 config/programming, and media
- All data is live and updates automatically

## Automated Testing

### Manual test checklist
- [ ] Dashboard loads and login works
- [ ] Twitch bot status, logs, and chat display correctly
- [ ] TVS99 config and programming load and are formatted
- [ ] Media list loads and is categorized
- [ ] Tab switching works

### Example pytest for API endpoints
Create `test_app.py` in this directory:
```python
from fastapi.testclient import TestClient
from app import app

def test_dashboard_login():
    client = TestClient(app)
    resp = client.get("/login")
    assert resp.status_code == 200
    assert "Login" in resp.text

def test_api_tvs99_config():
    client = TestClient(app)
    resp = client.get("/api/tvs99-config")
    assert resp.status_code == 200
    assert resp.headers["content-type"].startswith("application/json")

def test_api_media():
    client = TestClient(app)
    resp = client.get("/api/media")
    assert resp.status_code == 200
    assert resp.headers["content-type"].startswith("application/json")
```
Run with:
```bash
pip install pytest
pytest test_app.py
```

## Deployment
- For production, use a process manager (systemd, Docker, etc.)
- Set strong admin credentials and secrets
- Use HTTPS in production

## License
MIT
