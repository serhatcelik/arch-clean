#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done
polybar primary --config="$HOME"/.config/polybar/config.ini &
if xrandr --query | grep -q "HDMI.* connected"
then
    polybar external --config="$HOME"/.config/polybar/config.ini &
fi
