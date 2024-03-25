#!/bin/bash
if ! zenity --question --title "$2" --text "Are you sure?" --default-cancel
then
    exit 1
fi
"$1" "$2"
