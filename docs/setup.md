# Raspberry Pi Eurowings Flug-Checker – Handbuch

Dieses Dokument beschreibt den kompletten Aufbau und Betrieb des Eurowings-Flug-Checkers.  
Es dient als Backup-Dokumentation, falls der Raspberry Pi neu installiert werden muss.  
Das System kombiniert Kalenderdaten, OpenSky API (früher AirLabs), ADS-B Rohdaten (dump1090), Sonos Audio und eine HomePilot Lampe.

---

## Hardware

- Raspberry Pi (z.B. Raspberry Pi 3)
- RTL-SDR USB Stick mit 1090 MHz Antenne
- Sonos Lautsprecher im Netzwerk
- Rademacher / HomePilot Lampe

---

## Wichtige Dateien

```bash
/home/pi/flug_checker.py          (Hauptscript)
/home/pi/overflight_alert.mp3     (Überflug Alarm)
/home/pi/landing_day.mp3          (Letzte Landung Alarm - Tag)
/home/pi/landing_night.mp3        (Letzte Landung Alarm - Nacht)
/home/pi/flug_checker.log         (Logdatei)
/home/pi/.flugchecker_config      (Passwörter)
```

---

## ADS-B Radar Installation

```bash
sudo apt update
sudo apt install dump1090-mutability
```

ADS-B Daten liegen danach in:

```bash
/run/dump1090-mutability/aircraft.json
```

---

## Python Umgebung

```bash
cd /home/pi
python3 -m venv flug_env
source flug_env/bin/activate
pip install requests pytz ics soco
```

---

## PDF2Image

```bash
sudo apt update
sudo apt install tesseract-ocr -y
sudo apt install poppler-utils -y
source /home/pi/flug_env/bin/activate
pip install pdf2image pytesseract pillow
```

Test:

```bash
/home/pi/flug_env/bin/python -c "import pdf2image, pytesseract"
```

---

## Passwortdatei erstellen

```bash
nano /home/pi/.flugchecker_config
```

Inhalt:

```ini
# === API / Accounts ===
ICS_URL=dein_kalender_link
MAIL_USER=deine_mail
MAIL_PASSWORD=dein_mail_passwort
OPENSKY_USER=
OPENSKY_PASS=dein_passwort
AIRLABS_KEY=dein_api_key

# === Netzwerk ===
SONOS_IP=
PI_IP=
HOMEPILOT_URL=DEINE_HOMEPILOT_IP/devices/DEIN_DEVICE
HTTP_PORT=8000

# === Standort ===
HOME_LAT=
HOME_LON=
RADIUS_KM=25
INFO_RADIUS_KM=50

# === Mail ===
MY_MAIL=
WIFE_MAIL=
```

Dann:

```bash
chmod 600 /home/pi/.flugchecker_config
```

---

## Flugchecker Service

```bash
sudo nano /etc/systemd/system/flugchecker.service
```

Service aktivieren:

```bash
sudo systemctl daemon-reload
sudo systemctl enable flugchecker
sudo systemctl start flugchecker
```

---

## HTTP Server für Sonos

```bash
sudo nano /etc/systemd/system/flug-http.service
```

HTTP Service aktivieren:

```bash
sudo systemctl daemon-reload
sudo systemctl enable flug-http
sudo systemctl start flug-http
```

---

## Wichtige Terminal Befehle

Script bearbeiten:

```bash
nano /home/pi/flug_checker.py
```

Service neu starten:

```bash
sudo systemctl restart flugchecker
```

Service Status:

```bash
sudo systemctl status flugchecker
```

Live Log anzeigen:

```bash
tail -f /home/pi/flug_checker.log
```

Letzte Logs anzeigen:

```bash
tail -n 50 /home/pi/flug_checker.log
```

Nach Änderung einer Service Datei:

```bash
sudo systemctl daemon-reload
sudo systemctl restart flugchecker
```

---

## Testmodus

Virtuelle Umgebung aktivieren:

```bash
source /home/pi/flug_env/bin/activate
```

Dann Testmodus starten:

```bash
python3 /home/pi/flug_checker.py --test
```

---

## Nützliche grep Befehle

```bash
grep EW /home/pi/flug_checker.log
grep LANDUNG /home/pi/flug_checker.log
grep ÜBERFLUG /home/pi/flug_checker.log
cat /run/dump1090-mutability/aircraft.json | grep EWG
ps aux | grep flugchecker
journalctl -u flugchecker
```

---

## MP3 Lautstärke anpassen

```bash
ffmpeg -i /home/pi/xxx.mp3 -filter:a "volume=3" /home/pi/xxx_loud.mp3
mv /home/pi/xxx_loud.mp3 /home/pi/xxx.mp3
```

---

## Callsing.json

Schnell erstellen:

```bash
echo '["EWG7H","EWG72E"]' > /home/pi/callsigns.json
```

Löschen:

```bash
rm -f /home/pi/callsigns.json
```

---

## Systemdiagramm

- Kalender → letzter Flug (Zeit, Routing)
- Mail → Betreff: Daily, mit Document.pdf für Callsigns
- Callsigns kommen aus Daily Mail (OCR)
- dump1090 → Flugzeugposition
- OpenSky → Tracking + Landung
- Flugchecker → Logik & Distanzberechnung
- Sonos → Audio Alarm
- HomePilot → Magenta Lampe
