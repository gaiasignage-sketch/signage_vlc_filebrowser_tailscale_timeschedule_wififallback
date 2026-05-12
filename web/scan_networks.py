#!/usr/bin/env python3

import http.server
import socketserver
import urllib.parse
import subprocess
import html

PORT = 80

def get_wifi_options():
    try:
        output = subprocess.check_output(
            ["nmcli", "-t", "-f", "SSID", "dev", "wifi", "list"],
            text=True
        )
        seen = set()
        options = []

        for line in output.splitlines():
            ssid = line.strip()
            if not ssid or ssid in seen:
                continue
            seen.add(ssid)
            esc = html.escape(ssid)
            options.append(f'<option value="{esc}">{esc}</option>')

        if not options:
            return '<option value="">Nessuna rete trovata</option>'

        return "".join(options)

    except Exception:
        return '<option value="">Nessuna rete trovata</option>'


class MyHandler(http.server.BaseHTTPRequestHandler):
    def send_html(self, content):
        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(content.encode("utf-8"))

    def do_GET(self):
        wifi_options = get_wifi_options()

        html_page = f"""<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Configurazione WiFi</title>
  <style>
    body {{
      font-family: sans-serif;
      text-align: center;
      padding: 20px;
      background: #f4f4f4;
    }}
    .box {{
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      display: inline-block;
      max-width: 380px;
      width: 100%;
    }}
    select, input {{
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 5px;
      box-sizing: border-box;
    }}
    input[type="submit"] {{
      background: #007bff;
      color: white;
      border: none;
      cursor: pointer;
      font-weight: bold;
    }}
    .small {{
      font-size: 0.9rem;
      color: #555;
    }}
  </style>
</head>
<body>
  <div class="box">
    <h2>Configurazione WiFi</h2>
    <form action="/save" method="POST">
      Seleziona rete:<br>
      <select name="ssid">{wifi_options}</select><br>

      <div class="small">Oppure scrivi SSID manualmente</div>
      <input type="text" name="ssid_manual" placeholder="Solo se non in lista"><br>

      Password:<br>
      <input type="password" name="psk"><br>

      <input type="submit" value="Connetti">
    </form>
  </div>
</body>
</html>"""
        self.send_html(html_page)

    def do_POST(self):
        if self.path != "/save":
            self.send_error(404)
            return

        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length).decode("utf-8")
        params = urllib.parse.parse_qs(body)

        ssid = params.get("ssid", [""])[0].strip()
        ssid_manual = params.get("ssid_manual", [""])[0].strip()
        psk = params.get("psk", [""])[0]

        final_ssid = ssid_manual if ssid_manual else ssid

        if not final_ssid:
            self.send_html("""
<html><body style="font-family:sans-serif;text-align:center;padding:20px;">
<h2>SSID mancante</h2>
<p>Torna indietro e seleziona o inserisci una rete.</p>
</body></html>
""")
            return

        cmd = ["nmcli", "dev", "wifi", "connect", final_ssid, "ifname", "wlan0"]
        if psk:
            cmd.extend(["password", psk])

        result = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=25
        )

        if result.returncode == 0:
            self.send_html(f"""
<html><body style="font-family:sans-serif;text-align:center;padding:20px;">
<h2>Connessione riuscita</h2>
<p>Il Raspberry Pi è collegato a <b>{html.escape(final_ssid)}</b>.</p>
<p>L'hotspot può essere spento.</p>
</body></html>
""")
        else:
            subprocess.run(
                ["/usr/bin/nmcli", "con", "up", "HotspotEmergenza"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )

            self.send_html(f"""
<html><body style="font-family:sans-serif;text-align:center;padding:20px;">
<h2>Connessione non riuscita</h2>
<p>Rete: <b>{html.escape(final_ssid)}</b></p>
<p>Password errata o rete non raggiungibile.</p>
<p>L'hotspot è stato riattivato automaticamente. Ricollegati a <b>RPi_Config</b> e riprova.</p>
<pre style="white-space:pre-wrap;text-align:left;max-width:520px;margin:20px auto;">{html.escape(result.stderr or result.stdout)}</pre>
</body></html>
""")


with socketserver.TCPServer(("0.0.0.0", PORT), MyHandler) as httpd:
    print("Server pronto su http://10.42.0.1")
    httpd.serve_forever()
