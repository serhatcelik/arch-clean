case $(zenity --warning \
    --icon system-shutdown --title "Power" --text "What do you want to do?" \
    --ok-label "[ X ]" \
    --extra-button "Lock" \
    --extra-button "Log Out" \
    --extra-button "Reboot" \
    --extra-button "Power Off") in
    "Lock")
        bash lock.sh
        ;;
    "Log Out")
        i3-msg exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Power Off")
        systemctl poweroff
        ;;
esac
