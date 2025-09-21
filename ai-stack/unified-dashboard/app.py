
from fastapi import FastAPI, Request, Form, Cookie, Depends
from fastapi.responses import HTMLResponse, RedirectResponse, PlainTextResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
import os
# --- TVS99 imports ---
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../vtuber-tvs99-manager')))
from config_manager import load_config, save_config, list_channels, add_channel, update_channel, remove_channel
from media.scan import scan_media

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

# --- Auth/session (placeholder) ---
@app.get("/login", response_class=HTMLResponse)
def login_page(request: Request):
    return templates.TemplateResponse("login.html", {"request": request, "error": False})

@app.post("/login")
def login(request: Request, username: str = Form(...), password: str = Form(...)):
    # TODO: Implement real auth
    if username == "admin" and password == "changeme":
        resp = RedirectResponse("/", status_code=303)
        resp.set_cookie("session", f"{username}:token", httponly=True, max_age=86400)
        return resp
    return templates.TemplateResponse("login.html", {"request": request, "error": True})

@app.get("/logout")
def logout():
    resp = RedirectResponse("/login", status_code=303)
    resp.delete_cookie("session")
    return resp

# --- Main dashboard ---
@app.get("/", response_class=HTMLResponse)
def dashboard(request: Request, session: str = Cookie(None)):
    # TODO: Auth check
    return templates.TemplateResponse("dashboard.html", {"request": request, "user": "admin"})

# --- API endpoints (stubs) ---
@app.get("/api/bot-status", response_class=PlainTextResponse)
def api_bot_status():
    return "Bot status: (stub)"

@app.get("/api/bot-logs", response_class=PlainTextResponse)
def api_bot_logs():
    return "Bot logs: (stub)"

@app.get("/api/bot-chat", response_class=PlainTextResponse)
def api_bot_chat():
    return "Bot chat: (stub)"


# TVS99 config endpoints
TVS99_CONFIG_PATH = os.environ.get("TVS99_CONFIG", "../tvs99/config.tvs.yml")

@app.get("/api/tvs99-config", response_class=JSONResponse)
def api_tvs99_config():
    config = load_config(TVS99_CONFIG_PATH)
    return config


# TVS99 programming/guide endpoint
@app.get("/api/tvs99-programming", response_class=JSONResponse)
def api_tvs99_programming():
    config = load_config(TVS99_CONFIG_PATH)
    guide = []
    for ch in config.get('channels', []):
        guide.append({
            'number': ch.get('number'),
            'name': ch.get('name'),
            'title': ch.get('title', ''),
            'video': ch.get('video', '')
        })
    return guide


# Media scan endpoint
@app.get("/api/media", response_class=JSONResponse)
def api_media():
    return scan_media()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8100, reload=True)
