#!/bin/bash
killall -q dunst
dunst -config "$HOME"/.config/dunst/dunstrc &
