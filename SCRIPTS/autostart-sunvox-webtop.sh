#!/with-contenv bash

# Wacht tot de grafische interface (X-server) up is
sleep 5

# Start SunVox als de gebruiker 'abc'
# We sturen de output naar /dev/null om logs schoon te houden
sudo -u abc DISPLAY=:1 sunvox &
