#!/bin/bash

# Wacht tot de grafische interface (X-server) up is
sleep 5

# Start rtl_tcp als de gebruiker 'abc'
# We sturen de output naar /dev/null om logs schoon te houden
sudo -u abc DISPLAY=:1 rtl_tcp >/dev/null 2>&1 &
