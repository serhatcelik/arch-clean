#!/bin/bash

DIR="$HOME"/.config/dunst

killall -q dunst

dunst -config "$DIR"/dunstrc &
