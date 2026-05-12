#!/bin/bash

# WiFi Fallback Setup Script
# Configura hotspot di emergenza e interfaccia web

set -e

echo "Creating hotspot web directory..."
sudo mkdir -p /home/rpi02w/hotspot-web

echo "Copying web interface script..."
sudo cp web/scan_networks.py /home/rpi02w/hotspot-web/
sudo chmod +x /home/rpi02w/hotspot-web/scan_networks.py

echo "Copying autohotspot script..."
sudo cp scripts/autohotspot.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/autohotspot.sh

echo "Setting up emergency hotspot connection..."
sudo nmcli con add \
  type wifi \
  ifname wlan0 \
  con-name HotspotEmergenza \
  ssid RPi_Config \
  autoconnect no

sudo nmcli con modify HotspotEmergenza \
  802-11-wireless.mode ap \
  802-11-wireless.band bg \
  ipv4.method shared

sudo nmcli con modify HotspotEmergenza \
  wifi-sec.key-mgmt wpa-psk \
  wifi-sec.psk "gaia1234"

echo "WiFi Fallback setup complete!"
echo "Next: Copy systemd/autohotspot.service to /etc/systemd/system/"
sudo cp systemd/autohotspot.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable autohotspot.service
echo "IMPORTANTE:"
echo "- Hotspot SSID: RPi_Config"
echo "- Hotspot password: gaia1234"
echo "- Accesso web: http://10.42.0.1"
