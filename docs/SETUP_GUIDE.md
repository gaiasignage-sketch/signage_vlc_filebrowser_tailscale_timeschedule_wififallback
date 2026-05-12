# Guida di Installazione Completa

## Prerequisiti

- Raspberry Pi Zero 2 W
- Raspberry Pi OS Lite Bookworm (ARM64)
- Connessione internet iniziale
- Accesso SSH o terminale locale

## Installazione Automatica

Clona il repository e esegui gli script in ordine:

```bash
git clone https://github.com/gaiasignage-sketch/signage_vlc_filebrowser_tailscale_timeschedule_wififallback.git
cd signage_vlc_filebrowser_tailscale_timeschedule_wififallback

bash installation/01-vlc-setup.sh
bash installation/02-filebrowser-setup.sh
bash installation/03-tailscale-setup.sh
bash installation/04-scheduler-setup.sh
bash installation/05-wifi-fallback-setup.sh
```

## Installazione Manuale

### 1. VLC Autoplay

```bash
sudo apt update && sudo apt install -y vlc
sudo mkdir -p /home/rpi02w/autoplay
sudo chown -R rpi02w:rpi02w /home/rpi02w/autoplay
sudo chmod -R 755 /home/rpi02w/autoplay

# Copia il file systemd
sudo cp systemd/vlc-autoplay.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable vlc-autoplay.service
sudo systemctl start vlc-autoplay.service
```

### 2. FileBrowser

```bash
sudo apt install -y curl
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

mkdir -p /home/rpi02w/filebrowser
touch /home/rpi02w/filebrowser/filebrowser.db

# Copia il file systemd
sudo cp systemd/filebrowser.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable filebrowser.service
sudo systemctl start filebrowser.service
```

Accedi a `http://<rpi-ip>:8080` - Password default: `gaia12345678` (CAMBIALA!)

### 3. Tailscale VPN

```bash
sudo apt update
sudo apt install -y curl lsb-release

curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo apt update
sudo apt install -y tailscale

sudo systemctl enable tailscaled
sudo tailscale up
```

Visita il link fornito per autenticarti.

### 4. Time Scheduler

```bash
sudo cp scripts/safe-display-scheduler.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/safe-display-scheduler.sh

sudo crontab -e
```

Aggiungi le seguenti righe:

```
59 23 * * * /usr/local/bin/safe-display-scheduler.sh off   # Spegni display a 23:59
00 05 * * * /usr/local/bin/safe-display-scheduler.sh on    # Accendi display a 05:00
10 05 * * * /sbin/reboot                                   # Reboot a 05:10
```

### 5. WiFi Fallback con Hotspot

```bash
sudo mkdir -p /home/rpi02w/hotspot-web
sudo cp web/scan_networks.py /home/rpi02w/hotspot-web/
sudo chmod +x /home/rpi02w/hotspot-web/scan_networks.py

sudo cp scripts/autohotspot.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/autohotspot.sh

# Configura hotspot di emergenza
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

# Copia il file systemd
sudo cp systemd/autohotspot.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable autohotspot.service
sudo systemctl start autohotspot.service
```

## Configurazione WiFi Principale

```bash
sudo nmcli connection add \
  type wifi \
  con-name "Damiano" \
  ifname wlan0 \
  ssid "AndroidAPpa"

sudo nmcli connection modify "Damiano" \
  wifi-sec.key-mgmt wpa-psk \
  wifi-sec.psk "gaia1234"

sudo nmcli connection modify "Damiano" connection.autoconnect yes
```

## Verifica dello Status

```bash
# VLC
sudo systemctl status vlc-autoplay

# FileBrowser
sudo systemctl status filebrowser

# Tailscale
tailscale status

# Hotspot
sudo systemctl status autohotspot
```

## Troubleshooting

### VLC non riproduce
- Controlla che i video siano in `/home/rpi02w/autoplay/`
- Verifica che l'ambiente grafico sia disponibile (`DISPLAY=:0`)
- Controlla i log: `journalctl -u vlc-autoplay -f`

### FileBrowser non raggiungibile
- Verifica che il servizio sia attivo: `sudo systemctl status filebrowser`
- Controlla la porta 8080: `sudo netstat -tlnp | grep 8080`
- Controlla i permessi di `/home/rpi02w/autoplay`

### Hotspot non si attiva
- Controlla che NetworkManager sia installato e attivo
- Verifica la connessione WiFi: `nmcli device show wlan0`
- Controlla i log: `journalctl -u autohotspot -f`

### Clock non sincronizzato
- Se il clock non è sincronizzato, lo scheduler non funziona (per sicurezza)
- Attendi la sincronizzazione NTP oppure sincronizza manualmente:
  ```bash
  sudo timedatectl set-ntp true
  timedatectl
  ```

## Sicurezza

⚠️ **IMPORTANTE**: Cambia le password di default!

1. **FileBrowser password**: Cambia da `gaia12345678`
   ```bash
   sudo filebrowser users update admin --password "nuova_password"
   ```

2. **WiFi password**: Cambia da `gaia1234`
   ```bash
   sudo nmcli con modify HotspotEmergenza wifi-sec.psk "nuova_password"
   sudo nmcli con modify "Damiano" wifi-sec.psk "nuova_password"
   ```

3. **SSH**: Cambia la password dell'utente `rpi02w`
   ```bash
   passwd
   ```
