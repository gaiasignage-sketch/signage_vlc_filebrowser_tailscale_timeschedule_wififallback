#!/bin/bash

# Tailscale Setup Script
# Installa Tailscale VPN

set -e

echo "Installing Tailscale dependencies..."
sudo apt update
sudo apt install -y curl lsb-release

echo "Adding Tailscale repository..."
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

echo "Installing Tailscale..."
sudo apt update
sudo apt install -y tailscale

echo "Enabling Tailscale daemon..."
sudo systemctl enable tailscaled
sudo systemctl is-enabled tailscaled

echo "Tailscale setup complete!"
echo "Next: Authenticate with Tailscale"
echo "  sudo tailscale up"
echo "Visit the provided link to authenticate"
