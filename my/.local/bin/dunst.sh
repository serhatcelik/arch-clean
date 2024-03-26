#!/bin/bash
killall -q dunst
while pgrep -u $UID -x dunst > /dev/null 2>&1; do sleep 1; done
dunst -config "$HOME"/.config/dunst/dunstrc &
