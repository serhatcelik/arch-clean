#!/bin/bash
notify-send --hint=string:x-dunst-stack-tag:my "Brightness" ""$(brightnessctl set +0 | grep -o -P "[0-9]+(?=%)")""
