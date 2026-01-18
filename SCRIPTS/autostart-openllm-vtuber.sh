#!/usr/bin/with-contenv bash

# Start de VTuber backend op de achtergrond
cd /app/openllm-vtuber || exit 1

uv run run_server.py
# python3 server.py &

# Wacht tot de desktop interface (KDE) geladen is
sleep 10

# Open de browser (KDE gebruikt vaak Falkon of Firefox afhankelijk van de build)
# We sturen dit naar display :1 (de standaard voor Webtop)
# DISPLAY=:1 falkon http://0.0.0.0:12393 &
DISPLAY=:1 xdg-open http://0.0.0.0:12393 >/dev/null 2>&1 &
