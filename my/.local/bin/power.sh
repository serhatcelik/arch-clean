#!/bin/bash
if ! zenity --question --title "$1" --text "Are you sure?" --default-cancel
then
    exit 1
fi
shutdown --"$1" now
