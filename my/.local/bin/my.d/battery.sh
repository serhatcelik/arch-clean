UEVENT=/sys/class/power_supply/BAT0/uevent

CAPACITY="$(grep -o -P '(?<=POWER_SUPPLY_CAPACITY=).+' "$UEVENT")"

FILE_BATTERY_D=/tmp/BATTERY_D
FILE_BATTERY_C=/tmp/BATTERY_C

FILE_BATTERY_F=/tmp/BATTERY_F
FILE_BATTERY_R=/tmp/BATTERY_R

if grep -q Discharging "$UEVENT"
then
    rm -f "$FILE_BATTERY_C"
    if [ ! -f "$FILE_BATTERY_D" ]
    then
        touch "$FILE_BATTERY_D"
        bash notify.sh battery D
    fi
    rm -f "$FILE_BATTERY_F"
    if [ ! -f "$FILE_BATTERY_R" ] && [ "$CAPACITY" -le "$BATTERY_RISK_AT" ]
    then
        touch "$FILE_BATTERY_R"
        bash notify.sh battery R
    fi
else
    rm -f "$FILE_BATTERY_D"
    if [ ! -f "$FILE_BATTERY_C" ]
    then
        touch "$FILE_BATTERY_C"
        bash notify.sh battery C
    fi
    rm -f "$FILE_BATTERY_R"
    if [ ! -f "$FILE_BATTERY_F" ] && [ "$CAPACITY" -ge "$BATTERY_FULL_AT" ]
    then
        touch "$FILE_BATTERY_F"
        bash notify.sh battery F
    fi
fi
