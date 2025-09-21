
from fastapi import FastAPI, Request, Form, Response, Cookie, status
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import os
from config_manager import load_config, save_config, add_channel, update_channel, remove_channel
from hashlib import sha256

CONFIG_PATH = os.environ.get("TVS99_CONFIG", "../tvs99/config.tvs.yml")
ADMIN_USER = os.environ.get("DASHBOARD_USER", "admin")
ADMIN_PASS = os.environ.get("DASHBOARD_PASS", "changeme")
SESSION_SECRET = os.environ.get("DASHBOARD_SECRET", "changeme")

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
    config = load_config(CONFIG_PATH)
    channels = config.get('channels', [])
    return templates.TemplateResponse("dashboard.html", {"request": request, "channels": channels, "user": ADMIN_USER})

@app.post("/add")
def add(request: Request, number: int = Form(...), name: str = Form(...), title: str = Form(""), video: str = Form(""), session: str = Cookie(None)):
    if not check_auth(session):
        return RedirectResponse("/login", status_code=303)
    config = load_config(CONFIG_PATH)
    add_channel(config, {"number": number, "name": name, "title": title, "video": video})
    save_config(config, CONFIG_PATH)
    return RedirectResponse("/", status_code=303)

@app.post("/delete")
def delete(request: Request, number: int = Form(...), session: str = Cookie(None)):
    if not check_auth(session):
        return RedirectResponse("/login", status_code=303)
    config = load_config(CONFIG_PATH)
    remove_channel(config, number)
    save_config(config, CONFIG_PATH)
    return RedirectResponse("/", status_code=303)

@app.post("/update")
def update(request: Request, number: int = Form(...), title: str = Form(""), session: str = Cookie(None)):
    if not check_auth(session):
        return RedirectResponse("/login", status_code=303)
    config = load_config(CONFIG_PATH)
    update_channel(config, number, {"title": title})
    save_config(config, CONFIG_PATH)
    return RedirectResponse("/", status_code=303)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("webui.app:app", host="0.0.0.0", port=8088, reload=True)
