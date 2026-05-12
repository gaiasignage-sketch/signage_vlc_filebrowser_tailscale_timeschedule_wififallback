#!/bin/bash

# VLC Autoplay Setup Script
# Installa VLC e crea la cartella di autoplay

set -e

echo "Installing VLC..."
sudo apt update && sudo apt install -y vlc

echo "Creating autoplay directory..."
sudo mkdir -p /home/rpi02w/autoplay

echo "Setting permissions..."
sudo chown -R rpi02w:rpi02w /home/rpi02w/autoplay
sudo chmod -R 755 /home/rpi02w/autoplay

echo "VLC setup complete!"
echo "Next: Copy systemd/vlc-autoplay.service to /etc/systemd/system/"
sudo cp systemd/vlc-autoplay.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable vlc-autoplay.service
sudo systemctl start vlc-autoplay.service
