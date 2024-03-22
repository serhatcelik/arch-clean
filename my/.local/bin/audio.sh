#!/bin/bash
notify-send --hint=string:x-dunst-stack-tag:my "Volume" "$(pulseaudio-ctl full-status | cut -d " " -f -2 | sed 's/yes/(mute)/;s/no//')"
