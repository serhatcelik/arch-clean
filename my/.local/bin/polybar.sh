#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null 2>&1; do sleep 1; done
polybar main --config="$HOME"/.config/polybar/config.ini &
polybar hdmi --config="$HOME"/.config/polybar/config.ini &
