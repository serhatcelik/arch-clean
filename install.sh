#!/bin/bash

read -r -p "Enter username: " USER
read -r -s -p "Enter password: " PASS

if [ "$USER" = "root" ] || [ -z "$USER" ] || [ -z "$PASS" ]
then
    echo "Not enough credentials have been provided."
    exit 1
fi

HOME_DIR="/home/$USER"
FONT_DIR="$HOME_DIR/.local/share/fonts"

if useradd "$USER" --gid users --groups wheel --shell /usr/bin/zsh --create-home --home-dir "$HOME_DIR"
then
    yes "$PASS" | passwd "$USER"
    EDITOR=vim
    export EDITOR
    visudo
fi

if ! pacman -Syu --noconfirm alacritty alsa-utils arandr base-devel bluez bluez-utils caja curl dkms feh ffmpeg firefox flameshot gcc git htop i3 iptables ipython john jq libreoffice make man mesa neofetch net-tools netcat networkmanager openssh openvpn p7zip picom powerline powerline-fonts pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer python-pip rofi sudo unzip vim virtualbox-guest-utils vulkan-icd-loader wget which wireshark-cli wireshark-qt xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-vmmouse xorg xorg-xinit zsh
then
    echo "Alas, Pacman failed."
    exit 1
fi

if ! grep -q "\[sublime-text\]" /etc/pacman.conf
then
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg && pacman-key --add sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | tee -a /etc/pacman.conf
    pacman -Syu --noconfirm sublime-text
fi

git clone https://github.com/powerline/fonts.git --depth=1
sudo -u "$USER" mkdir -p "$FONT_DIR"
sudo -u "$USER" cp fonts/RobotoMono/* "$FONT_DIR"
fc-cache -fv "$FONT_DIR"
rm -rf fonts

sudo -u "$USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -u "$USER" git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME_DIR/.oh-my-zsh/plugins/zsh-autosuggestions"
sudo -u "$USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME_DIR/.oh-my-zsh/plugins/zsh-syntax-highlighting"

sudo -u "$USER" cp -a my/. "$HOME_DIR"

echo "DONE."
echo "Reboot and login as $USER."
