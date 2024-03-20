#!/bin/bash
Get() {
    pactl get-sink-"$1" @DEFAULT_SINK@ | grep -o -E "[0-9]+%|Mute.*"
}
Set() {
    pactl set-sink-"$1" @DEFAULT_SINK@ "$2"
}
if [ "$3" = "lower" ] || [ "$3" = "mute" ]
then
    Set "$1" "$2"
else
    if ! grep -q "15[0-9]%" <<< "$(Get "$1")"
    then
        Set "$1" "$2"
    fi
fi
notify-send --urgency low --hint=string:x-dunst-stack-tag:my "Volume" "$(Get "$1")"
