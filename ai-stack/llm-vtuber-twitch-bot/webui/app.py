
from fastapi import FastAPI, Request, Form, Cookie
from fastapi.responses import HTMLResponse, RedirectResponse, PlainTextResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import os
from hashlib import sha256

BOT_CONFIG_PATH = os.environ.get("BOT_CONFIG", "../llm-vtuber-twitch-bot/bot.env")
ADMIN_USER = os.environ.get("BOT_DASHBOARD_USER", "admin")
ADMIN_PASS = os.environ.get("BOT_DASHBOARD_PASS", "changeme")
SESSION_SECRET = os.environ.get("BOT_DASHBOARD_SECRET", "changeme")

app = FastAPI()
app.mount("/static", StaticFiles(directory="webui/static"), name="static")
templates = Jinja2Templates(directory="webui/templates")

def check_auth(session: str = None):
    if not session:
        return False
    try:
        user, token = session.split(":", 1)
        expected = sha256((user + ADMIN_PASS + SESSION_SECRET).encode()).hexdigest()
        return user == ADMIN_USER and token == expected
    except Exception:
        return False

@app.get("/login", response_class=HTMLResponse)
def login_page(request: Request):
    return templates.TemplateResponse("login.html", {"request": request, "error": False})

@app.post("/login")
def login(request: Request, username: str = Form(...), password: str = Form(...)):
    if username == ADMIN_USER and password == ADMIN_PASS:
        token = sha256((username + password + SESSION_SECRET).encode()).hexdigest()
        resp = RedirectResponse("/", status_code=303)
        resp.set_cookie("session", f"{username}:{token}", httponly=True, max_age=86400)
        return resp
    return templates.TemplateResponse("login.html", {"request": request, "error": True})

@app.get("/logout")
def logout():
    resp = RedirectResponse("/login", status_code=303)
    resp.delete_cookie("session")
    return resp

@app.get("/", response_class=HTMLResponse)
def dashboard(request: Request, session: str = Cookie(None)):
    if not check_auth(session):
        return RedirectResponse("/login", status_code=303)
    # Read bot config (env file)
    config = {}
    if os.path.exists(BOT_CONFIG_PATH):
        with open(BOT_CONFIG_PATH) as f:
            for line in f:
                if '=' in line:
                    k, v = line.strip().split('=', 1)
                    config[k] = v
    return templates.TemplateResponse("dashboard.html", {"request": request, "config": config, "user": ADMIN_USER})

@app.post("/update")
def update(request: Request, TWITCH_CHANNEL: str = Form(...), TWITCH_BOT_OAUTH: str = Form(...), session: str = Cookie(None)):
    if not check_auth(session):
        return RedirectResponse("/login", status_code=303)
    # Update bot config
    config = {
        'TWITCH_CHANNEL': TWITCH_CHANNEL,
        'TWITCH_BOT_OAUTH': TWITCH_BOT_OAUTH
    }
    with open(BOT_CONFIG_PATH, 'w') as f:
        for k, v in config.items():
            f.write(f"{k}={v}\n")
    return RedirectResponse("/", status_code=303)

# --- API endpoints for dashboard ---

# Simple in-memory log and chat buffers (for demo; replace with persistent/log file in prod)
BOT_LOG_PATH = os.environ.get("BOT_LOG_PATH", "../llm-vtuber-twitch-bot/bot.log")
BOT_CHAT_PATH = os.environ.get("BOT_CHAT_PATH", "../llm-vtuber-twitch-bot/chat.log")

@app.get("/api/bot-status", response_class=PlainTextResponse)
def api_bot_status(session: str = Cookie(None)):
    if not check_auth(session):
        return PlainTextResponse("Unauthorized", status_code=401)
    # Demo: check if bot process is running (by pid file or process name)
    import psutil
    for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
        try:
            if 'bot.py' in ' '.join(proc.info.get('cmdline', [])):
                return "Bot is running (PID: %d)" % proc.info['pid']
        except Exception:
            continue
    return "Bot is not running"

@app.get("/api/bot-logs", response_class=PlainTextResponse)
def api_bot_logs(session: str = Cookie(None)):
    if not check_auth(session):
        return PlainTextResponse("Unauthorized", status_code=401)
    # Tail last 50 lines of log file
    if os.path.exists(BOT_LOG_PATH):
        with open(BOT_LOG_PATH, 'r') as f:
            lines = f.readlines()[-50:]
        return ''.join(lines)
    return "No logs found."

@app.get("/api/bot-chat", response_class=PlainTextResponse)
def api_bot_chat(session: str = Cookie(None)):
    if not check_auth(session):
        return PlainTextResponse("Unauthorized", status_code=401)
    # Tail last 20 chat messages
    if os.path.exists(BOT_CHAT_PATH):
        with open(BOT_CHAT_PATH, 'r') as f:
            lines = f.readlines()[-20:]
        return ''.join(lines)
    return "No chat messages yet."

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("webui.app:app", host="0.0.0.0", port=8090, reload=True)
