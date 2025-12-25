#!/bin/bash
DIR="$HOME/Pictures/Wallpaper"
INTERVAL=7200 #2h

trap 'kill $!; wait $!' USR1

while true; do
    sleep $INTERVAL &
    wait $!
    WALLPAPER=$(find "$DIR" -type f | shuf -n 1)
    swww img "$WALLPAPER" --transition-type wipe --transition-fps 60
done
