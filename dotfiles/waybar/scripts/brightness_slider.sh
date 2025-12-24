#!/bin/bash

# Pobierz aktualną jasność
VAL=$(brightnessctl g)
MAX=$(brightnessctl m)
PERC=$(( VAL * 100 / MAX ))

# Zmiany:
# 1. Usunięto --close-on-unfocus (zapobiega znikaniu przy ruchu myszką)
# 2. Dodano --timeout=3 (okno zniknie samo po 3 sekundach, jeśli nic nie zrobisz)
# 3. Zwiększono nieco wysokość (geometry) dla wygody
# 4. Dodano --mouse (pojawia się pod kursorem)

yad --scale --min-value=1 --max-value=100 --value=$PERC --step=2 \
    --title="Jasność" --geometry=300x40 --undecorated --fixed \
    --mouse \
    --timeout=3 \
    --no-buttons \
    --print-partial | while read -r new_val; do
        brightnessctl set "$new_val%"
    done
