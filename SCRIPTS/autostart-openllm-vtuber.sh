#!/bin/bash
sleep 5
cd /app || exit 1
exec python3 run_server.py
