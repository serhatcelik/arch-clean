#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar primary &

if xrandr -q | grep -q "HDMI.* connected"
then
    polybar external &
fi
