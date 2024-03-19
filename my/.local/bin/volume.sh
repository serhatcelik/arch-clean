#!/bin/bash
get() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -o -E "[0-9]+%"
}
if [ "$1" = "raise" ]
then
    if ! grep -q "15[0-9]%" <<< "$(get)"
    then
        pactl set-sink-volume @DEFAULT_SINK@ +5%
    fi
    notify-send --urgency low --hint=string:x-dunst-stack-tag:volume "Volume" "$(get)"
elif [ "$1" = "lower" ]
then
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    notify-send --urgency low --hint=string:x-dunst-stack-tag:volume "Volume" "$(get)"
elif [ "$1" = "mute" ]
then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify-send --urgency low --hint=string:x-dunst-stack-tag:volume "Volume" "$(pactl get-sink-mute @DEFAULT_SINK@)"
fi
