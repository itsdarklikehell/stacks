#!/bin/bash
export DISPLAY=:1

sleep 5
cd /app || exit 1
exec python3 run_server.py &

TIMEOUT=60
COUNT=0
until curl -s http://localhost:12393 >/dev/null || [ "${COUNT}" -eq "${TIMEOUT}" ]; do
    echo 'Wachten op VTuber server API...'
    sleep 1
    ((COUNT++))
done
echo 'Server is up!'
sudo -u abc chromium --no-sandbox --no-first-run \
    --use-fake-ui-for-media-stream \
    --autoplay-policy=no-user-gesture-required \
    --unsafely-treat-insecure-origin-as-secure=http://localhost:12393 \
    --user-data-dir=/config/.config/chromium \
    --password-store=basic http://localhost:12393
