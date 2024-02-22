#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if ! [ -e /sys/class/backlight/intel_backlight ]
then
    sed -i "s/hidden = false/hidden = true/" ~/.config/polybar/config.ini
fi

polybar primary &

if xrandr --query | grep -q "HDMI.* connected"
then
    polybar external &
fi
