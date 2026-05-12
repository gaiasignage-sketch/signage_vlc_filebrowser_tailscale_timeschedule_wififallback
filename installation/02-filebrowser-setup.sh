#!/bin/bash

# FileBrowser Setup Script
# Installa FileBrowser e configura i permessi

set -e

echo "Installing curl..."
sudo apt install -y curl

echo "Installing FileBrowser..."
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

echo "Creating FileBrowser directory..."
mkdir -p /home/rpi02w/filebrowser
touch /home/rpi02w/filebrowser/filebrowser.db

echo "FileBrowser setup complete!"
echo "Next: Copy systemd/filebrowser.service to /etc/systemd/system/"
echo "  sudo cp systemd/filebrowser.service /etc/systemd/system/"
echo "  sudo systemctl daemon-reload"
echo "  sudo systemctl enable filebrowser.service"
echo "  sudo systemctl start filebrowser.service"
echo ""
echo "Access FileBrowser at: http://<rpi-ip>:8080"
echo "Default password: gaia12345678"
echo "IMPORTANTE: Cambia la password!"
