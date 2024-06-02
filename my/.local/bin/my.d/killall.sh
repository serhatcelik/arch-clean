for p in "$@"
do
    killall -q "$p"

    while pgrep -u "$UID" -x "$p" > /dev/null
    do
        sleep 1
    done

    case $p in
        dunst)
            dunst -config ~/.config/dunst/dunstrc &
            ;;
        feh)
            feh --no-fehbg --bg-fill /usr/share/backgrounds/wp.jpg
            ;;
        flameshot)
            flameshot &
            ;;
        fusuma)
            fusuma --daemon -c ~/.config/fusuma/config.yml
            ;;
        nm-applet)
            nm-applet &
            ;;
        picom)
            picom --daemon --config ~/.config/picom/picom.conf
            ;;
        polybar)
            for mon in $(xrandr -q | grep ' connected' | cut -d ' ' -f 1)
            do
                MONITOR=$mon polybar --reload -c ~/.config/polybar/config.ini &
            done
            ;;
        xfce4-clipman)
            xfce4-clipman &
            ;;
    esac
done
