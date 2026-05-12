#!/bin/bash

sleep 30

if ! /usr/bin/nmcli -t -f DEVICE,STATE dev status | grep -q '^wlan0:connected$'; then
    echo "Wi-Fi non connesso. Avvio Hotspot ed interfaccia web..."

    /usr/bin/nmcli con up HotspotEmergenza

    /usr/bin/python3 /home/rpi02w/hotspot-web/scan_networks.py &
    SERVER_PID=$!

    echo "$SERVER_PID" > /tmp/hotspot-web.pid

    sleep 600

    if kill -0 "$SERVER_PID" 2>/dev/null; then
        /bin/kill "$SERVER_PID"
    fi

    /usr/bin/nmcli con down HotspotEmergenza
fi
