#!/bin/bash

# Time Scheduler Setup Script
# Configura spegnimento display e reboot automatico tramite cron

set -e

echo "Copying safe-display-scheduler.sh..."
sudo cp scripts/safe-display-scheduler.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/safe-display-scheduler.sh

echo "Scheduler setup complete!"
echo "Next: Add cron jobs for scheduling"
echo "  sudo crontab -e"
echo ""
echo "Add these lines:"
echo "59 23 * * * /usr/local/bin/safe-display-scheduler.sh off   # Spegni display a 23:59"
echo "00 05 * * * /usr/local/bin/safe-display-scheduler.sh on    # Accendi display a 05:00"
echo "10 05 * * * /sbin/reboot                                   # Reboot a 05:10"
