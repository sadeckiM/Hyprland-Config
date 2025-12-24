#!/bin/bash
DIR="$HOME/Pictures/Wallpaper"
INTERVAL=7200 #2h

sleep 1

while true; do
    WALLPAPER=$(find "$DIR" -type f | shuf -n 1)
    swww img "$WALLPAPER" --transition-type wipe --transition-fps 60
    sleep $INTERVAL &
    wait $!
done
