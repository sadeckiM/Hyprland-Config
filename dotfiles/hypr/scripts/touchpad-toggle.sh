#!/bin/bash

if [ ! -f /tmp/touchpad_status ]; then
	echo 1 > /tmp/touchpad_status
fi

DEVICE="synps/2-synaptics-touchpad"
STATUS=$(cat /tmp/touchpad_status)

if [ "$STATUS" -eq 1 ]; then
	hyprctl keyword "device[$DEVICE]:enabled" 'false'
	echo 0 > /tmp/touchpad_status
	notify-send -u low -t 2000 "Touchpad" "Disabled"
else
	hyprctl keyword "device[$DEVICE]:enabled" 'true'
	echo 1 > /tmp/touchpad_status
	notify-send -u low -t 2000 "Touchpad" "Enabled"
fi
