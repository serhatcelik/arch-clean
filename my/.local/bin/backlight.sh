#!/bin/bash
BRIGHTNESS="$(brightnessctl set "$1" 2> /dev/null | grep -o -P "[0-9]+(?=%)")"
[ -n "$2" ] || notify-send --hint=string:x-dunst-stack-tag:my "Brightness" "$BRIGHTNESS"
echo "$BRIGHTNESS"
