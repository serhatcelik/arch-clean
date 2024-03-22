#!/bin/bash
Audio() {
    amixer get Master | sed -n -E 's/.*Left:.*\[([0-9]+)%\].*\[(on|off)\]/\1 \2/p' | sed 's/on//;s/off/(mute)/'
}
Brightness() {
    brightnessctl set +0 | grep -o -P "[0-9]+(?=%)"
}
notify-send --hint=string:x-dunst-stack-tag:my "$1" "$($1)"
