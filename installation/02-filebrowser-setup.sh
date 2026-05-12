#!/bin/bash

# FileBrowser Setup Script
# Installa FileBrowser e configura i permessi

set -e

echo "Installing curl..."
sudo apt install -y curl

echo "Installing FileBrowser..."
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

echo "Creating FileBrowser directory..."
sudo touch /home/rpi02w/filebrowser.db
sudo filebrowser config init -d /home/rpi02w/filebrowser.db -r /home/rpi02w/autoplay
sudo filebrowser --password gaia12345678 -d /home/rpi02w/filebrowser.db   -r /home/rpi02w/autoplay   -a 0.0.0.0   -p 8080 
echo "FileBrowser setup complete!"
echo "Next: Copy systemd/filebrowser.service to /etc/systemd/system/"
sudo cp systemd/filebrowser.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable filebrowser.service
sudo systemctl start filebrowser.service
echo "Access FileBrowser at: http://<rpi-ip>:8080"
echo "Default password: gaia12345678"

