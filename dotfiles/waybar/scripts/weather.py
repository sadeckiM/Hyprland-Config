#!/usr/bin/env python3
import json
import requests
import sys
import urllib.parse
import subprocess

# === KONFIGURACJA W JEDNYM MIEJSCU ===
CITY = "Kłodzko" 
# =====================================

# Kodujemy nazwę miasta do URL (np. obsługa spacji)
CITY_URL = urllib.parse.quote(CITY)
URL_BROWSER = f"https://wttr.in/{CITY_URL}"
URL_JSON = f"https://wttr.in/{CITY_URL}?format=j1"

# Sprawdzenie, czy skrypt został uruchomiony przez kliknięcie (on-click)
if "--open" in sys.argv:
    # Otwiera domyślną przeglądarkę i kończy działanie
    subprocess.run(["xdg-open", URL_BROWSER], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    sys.exit(0)

# --- Poniżej standardowa część pobierająca dane dla paska ---
try:
    req = requests.get(URL_JSON, timeout=5)
    
    if req.status_code != 200:
        raise Exception(f"Kod {req.status_code}")

    data = req.json()
    current = data['current_condition'][0]
    
    # Dane do wyświetlenia
    temp = current['temp_C']
    desc = current['weatherDesc'][0]['value']
    city_name = data['nearest_area'][0]['areaName'][0]['value']
    
    # Proste ikony
    desc_lower = desc.lower()
    icon = ""
    if "sun" in desc_lower or "clear" in desc_lower: icon = "☀️"
    elif "rain" in desc_lower or "drizzle" in desc_lower: icon = "🌧️"
    elif "snow" in desc_lower: icon = "❄️"
    elif "cloud" in desc_lower or "overcast" in desc_lower: icon = "☁️"
    elif "thunder" in desc_lower: icon = "⛈️"

    out_data = {
        "text": f"{icon} {temp}°C",
        "tooltip": f"<b>{city_name}</b>\n{desc}\nOdczuwalna: {current['FeelsLikeC']}°C",
        "class": "weather"
    }
    print(json.dumps(out_data))

except Exception as e:
    error_data = {"text": "", "tooltip": str(e), "class": "error"}
    print(json.dumps(error_data))
