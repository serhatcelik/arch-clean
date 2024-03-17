#!/bin/bash
notify-send --urgency low --hint=string:x-dunst-stack-tag:volume "Volume" "$(pactl get-sink-$1 @DEFAULT_SINK@)"
