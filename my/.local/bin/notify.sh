#!/bin/bash
Audio() {
    polybar-msg action audio "$1" > /dev/null 2>&1
    pactl --format json list sinks | sed -n -E 's/.*,"mute":(false|true),.*,"value_percent":"([0-9]+)%",.*,"front-right":.*/\2\1/p' | sed 's/false//;s/true/(mute)/'
}
Brightness() {
    polybar-msg action backlight "$1" > /dev/null 2>&1
    brightnessctl set +0 | grep -o -P "[0-9]+(?=%)"
}
Touchpad() {
    ID="$(xinput list | sed -n -E 's/.*Touchpad.*id=([0-9]+).*/\1/p')"
    xinput --"$1" "$ID"
    xinput list-props "$ID" | sed -n -E 's/.*Device Enabled.*:.*(0|1).*/\1/p' | sed 's/0/Disabled/;s/1/Enabled/'
}
notify-send --hint=string:x-dunst-stack-tag:my "$1" "$($1 "$2")"
