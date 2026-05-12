# RPi Zero 2 W Setup - VLC Signage + FileBrowser + Tailscale + WiFi Fallback

Repository di installazione e configurazione da zero per Raspberry Pi Zero 2 W su Raspberry Pi OS Lite Bookworm.

## Componenti

- **VLC Autoplay**: Riproduzione in fullscreen dei video dalla cartella `/home/rpi02w/autoplay/`
- **FileBrowser**: Interfaccia web per gestire i file di riproduzione
- **Tailscale**: VPN per accesso remoto sicuro
- **Time Scheduler**: Script cron per spegnimento/accensione display e reboot automatico
- **WiFi Fallback**: Hotspot di emergenza con interfaccia web per riconnessione

## Quick Start

```bash
# Clone il repository
git clone https://github.com/gaiasignage-sketch/signage_vlc_filebrowser_tailscale_timeschedule_wififallback.git
cd signage_vlc_filebrowser_tailscale_timeschedule_wififallback

# Esegui gli script di installazione in ordine
bash installation/01-vlc-setup.sh
bash installation/02-filebrowser-setup.sh
bash installation/03-tailscale-setup.sh
bash installation/04-scheduler-setup.sh
bash installation/05-wifi-fallback-setup.sh
```

## Struttura

```
├── installation/          # Script di installazione
│   ├── 01-vlc-setup.sh
│   ├── 02-filebrowser-setup.sh
│   ├── 03-tailscale-setup.sh
│   ├── 04-scheduler-setup.sh
│   └── 05-wifi-fallback-setup.sh
├── systemd/              # Unit file systemd
│   ├── vlc-autoplay.service
│   ├── filebrowser.service
│   └── autohotspot.service
├── scripts/              # Script ausiliari
│   ├── safe-display-scheduler.sh
│   └── autohotspot.sh
├── web/                  # Interfaccia web hotspot
│   └── scan_networks.py
└── docs/                 # Documentazione
    └── SETUP_GUIDE.md
```

## Configurazione Manuale

Il setup può essere fatto anche manualmente eseguendo i comandi nei file di installazione.
Vedi la cartella `docs/` per i dettagli.

## Note Importanti

- L'utente di default è `rpi02w`
- La password FileBrowser di default è `gaia12345678` - **CAMBIALA!**
- La password WiFi di default è `gaia1234` - **CAMBIALA!**
- I file systemd devono essere copiati in `/etc/systemd/system/`
- I script ausiliari devono avere permessi di esecuzione

## Licenza

MIT
