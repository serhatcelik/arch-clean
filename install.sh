#!/bin/bash

###################
# Get credentials #
###################
echo "Need your credentials to perform the following operations:"
echo "--> Change default shell to ZSH."
echo "--> Add you to the video group."
echo "--> Give write access to the video group so it can write to the brightness file."

while read -r -p "Enter username: " USER
do
    if [ "$USER" = root ]
    then
        echo "Enter a username other than root."
    else
        break
    fi
done

################
# Change shell #
################
if ! sudo chsh "$USER" --shell "$(which zsh)"
then
    echo "I have failed, because of you."
    exit 1
fi

##################
# Brightness fix #
##################
sudo usermod -a -G video "$USER"
cat << EOF | sudo tee /etc/udev/rules.d/45-backlight.rules
ACTION=="add",SUBSYSTEM=="backlight",KERNEL=="intel_backlight",RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
ACTION=="add",SUBSYSTEM=="backlight",KERNEL=="intel_backlight",RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
EOF
