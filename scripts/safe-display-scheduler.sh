#!/bin/bash

ACTION="$1"
SYNC=$(/usr/bin/timedatectl show -p NTPSynchronized --value 2>/dev/null)
SYNC_ALT=$(/usr/bin/timedatectl show -p SystemClockSynchronized --value 2>/dev/null)

if [ "$SYNC" != "yes" ] && [ "$SYNC_ALT" != "yes" ]; then
  logger -t safe-display-scheduler "Bloccato: clock non sincronizzato, action=$ACTION"
  exit 0
fi

case "$ACTION" in
  off)
    echo off > /sys/class/drm/card0-HDMI-A-1/status
    ;;
  on)
    echo on > /sys/class/drm/card0-HDMI-A-1/status
    ;;
  reboot)
    /sbin/reboot
    ;;
  *)
    logger -t safe-display-scheduler "Azione non valida: $ACTION"
    exit 1
    ;;
esac
