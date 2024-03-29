Audio() {
    polybar-msg action audio "$1" &> /dev/null
    pactl --format json list sinks | sed -n -E 's/.*,"mute":(false|true),.*,"value_percent":"([0-9]+)%",.*,"front-right":.*/\2\1/p' | sed 's/false//;s/true/(mute)/'
}

Light() {
    polybar-msg action light "$1" &> /dev/null
    brightnessctl set +0 | grep -o -P "[0-9]+(?=%)"
}

notify-send --hint=string:x-dunst-stack-tag:my "$1" "$($1 "$2")"
