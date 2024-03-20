#!/bin/bash
BRIGHTNESS="$(brightnessctl set "$1" 2> /dev/null | grep -o -P "[0-9]+(?=%)")"
notify-send --urgency low --hint=string:x-dunst-stack-tag:my "Brightness" "$BRIGHTNESS"
echo "$BRIGHTNESS"
