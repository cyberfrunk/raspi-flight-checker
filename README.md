# ✈️ Flight Checker (Raspberry Pi)

Automated tracking of flights using ADS-B, calendar data and OpenSky.

### How it works

- Daily email → contains PDF with flight plan
- OCR extracts callsigns
- Callsigns are tracked via ADS-B / OpenSky

## Features

- ADS-B tracking (dump1090)
- Flight matching via callsigns
- Overflight detection
- Landing detection (OpenSky)
- Sonos audio alerts
- Smart light integration
- Mail parsing (PDF + OCR)

## Setup

1. Clone repository

2. Create config:
   cp .flugchecker_config.example .flugchecker_config

3. Edit config and fill in your values

4. Install dependencies:
   pip install -r requirements.txt

5. Start:
   python3 flug_checker.py

## Audio Setup

This project does not include any audio files.

Please create your own MP3 files and place them in `/home/pi/`:

- overflight_alert.mp3
- landing_day.mp3
- landing_night.mp3

## Daily Mail Requirement

This project relies on a daily email containing flight information.

The system extracts callsigns from a PDF attachment "Document.pdf" using OCR.

⚠️ Important:
- The email must be sent at check-in
- It must contain a PDF attachment with flight data
- The subject should be  "Daily"

Without this email, no callsigns will be detected and flight tracking will not work.

## Documentation

Full setup guide:

- docs/setup.md

## Notes

- Audio files are excluded due to copyright reasons
- Configuration file is not included for security reasons
