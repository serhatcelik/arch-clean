#!/bin/bash

DIR="$HOME"/.config/polybar

killall -q polybar

while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

polybar primary --config="$DIR"/config.ini &

if xrandr --query | grep -q "HDMI.* connected"
then
    polybar external --config="$DIR"/config.ini &
fi
