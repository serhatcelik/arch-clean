#!/bin/bash
Audio() {
    pulseaudio-ctl full-status | cut -d " " -f -2 | sed 's/yes/(mute)/;s/no//'
}
Brightness() {
    brightnessctl set +0 | grep -o -P "[0-9]+(?=%)"
}
notify-send --hint=string:x-dunst-stack-tag:my "$1" "$("$1")"
