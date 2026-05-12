#!/bin/bash

# Time Scheduler Setup Script
# Configura spegnimento display e reboot automatico tramite cron

set -e

echo "Copying safe-display-scheduler.sh..."
sudo cp scripts/safe-display-scheduler.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/safe-display-scheduler.sh

echo "Scheduler setup complete!"
echo "Next: Add cron jobs for scheduling"
sudo crontab -e
echo "Add these lines:"
59 23 * * * /usr/local/bin/safe-display-scheduler.sh off
00 05 * * * /usr/local/bin/safe-display-scheduler.sh on
10 05 * * * /sbin/reboot
