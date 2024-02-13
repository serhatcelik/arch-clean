#!/bin/bash

####################
# Install packages #
####################
if ! sudo pacman -Syu --noconfirm --needed alacritty alsa-utils arandr base-devel blueberry bluez bluez-utils caja curl dkms feh ffmpeg firefox flameshot gcc git htop i3 iptables ipython john jq libreoffice make man mesa nano neofetch net-tools netcat networkmanager openssh openvpn p7zip pavucontrol picom polybar powerline powerline-fonts python-pip rofi sudo unzip vim wget which wireshark-cli wireshark-qt xorg xorg-xinit zsh
then
    echo "Alas, Pacman failed."
    exit 1
fi

########################
# Install Sublime Text #
########################
if ! grep -q "\[sublime-text\]" /etc/pacman.conf
then
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu sublime-text --noconfirm --needed
fi

##################
# Download fonts #
##################
wget -q --show-progress --no-clobber https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip
wget -q --show-progress --no-clobber https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
git clone https://github.com/powerline/fonts.git --depth=1

#################
# Install fonts #
#################
mkdir -p "$HOME/.local/share/fonts"
unzip -o RobotoMono.zip -d "$HOME/.local/share/fonts"
unzip -o JetBrainsMono-2.304.zip -d JetBrainsMono
cp JetBrainsMono/fonts/ttf/* "$HOME/.local/share/fonts"
cp fonts/RobotoMono/* "$HOME/.local/share/fonts"
fc-cache -fv "$HOME/.local/share/fonts"

#####################
# Install Oh My Zsh #
#####################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"

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
sudo chgrp video /sys/class/backlight/intel_backlight/brightness
sudo chmod g+w /sys/class/backlight/intel_backlight/brightness

################
# Copy configs #
################
cp -a my/. "$HOME"
