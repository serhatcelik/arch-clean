case $1 in
    date)
        dunstify -u N -h string:x-dunst-stack-tag:all \
            -i unity-datetime-panel "Date & Time" "$(date +'%d/%m/%y %A\n%H:%M:%S')"
        ;;
    audio)
        polybar-msg action audio "$2"

        if pamixer --get-mute | grep -q true
        then
            ICON=volume-level-none
        else
            ICON=volume-level-high
        fi

        dunstify -u L -h string:x-dunst-stack-tag:all \
            -i "$ICON" "Volume" -h int:value:"$(pamixer --get-volume)"
        ;;
    light)
        polybar-msg action light "$2"

        if [ "$2" = "inc" ]
        then
            ICON=notification-display-brightness
        else
            ICON=notification-display-brightness-medium
        fi

        dunstify -u L -h string:x-dunst-stack-tag:all \
            -i "$ICON" "Brightness" -h int:value:"$(brightnessctl | grep -o -P '[0-9]+(?=%)')"
        ;;
    touchpad)
        dunstify -u L -h string:x-dunst-stack-tag:all \
            -i input-touchpad-"$2" "Touchpad" "Touchpad $2"
        ;;
    airplane)
        dunstify -u N -h string:x-dunst-stack-tag:all \
            -i airplane-mode "Wireless Devices" "$(rfkill -n -o soft | uniq)"
        ;;
    battery)
        case $2 in
            D)
                dunstify -u N -h string:x-dunst-stack-tag:bat \
                    -i battery-050 "Battery" "Battery is discharging..."
                ;;
            R)
                dunstify -u C -h string:x-dunst-stack-tag:bat \
                    -i battery-010 "Battery" "Battery is running low :("
                ;;
            C)
                dunstify -u L -h string:x-dunst-stack-tag:bat \
                    -i battery-050-charging "Battery" "Battery is charging..."
                ;;
            F)
                dunstify -u L -h string:x-dunst-stack-tag:bat \
                    -i battery-100-charging "Battery" "Battery full :)"
                ;;
        esac
        ;;
esac
