if ! zenity --question --title "$2" --text "Are you sure?" --default-cancel
then
    exit 1
else
    "$1" "$2"
fi
