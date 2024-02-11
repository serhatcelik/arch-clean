#!/bin/bash

###################
# Get credentials #
###################
read -r -p "Enter username: " USER
read -r -s -p "Enter password: " PASS

[ -z "$USER" ] || [ -z "$PASS" ] && echo -e "\nNo credentials.\nExit." && exit 1

HOME_DIR="/home/$USER"

###############
# Create user #
###############
useradd --gid users --groups wheel --create-home "$USER" --home-dir "$HOME_DIR"
yes "$PASS" | passwd "$USER"
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

####################
# Install packages #
####################
pacman -Syu --noconfirm alacritty alsa-utils arandr base-devel bluez bluez-utils caja curl dkms feh ffmpeg firefox flameshot gcc git htop i3 iptables ipython john jq libreoffice make man mesa neofetch net-tools netcat networkmanager openssh openvpn p7zip picom powerline powerline-fonts pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer python-pip rofi sudo unzip vim virtualbox-guest-utils vulkan-icd-loader wget which wireshark-cli wireshark-qt xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-vmmouse xorg xorg-xinit zsh

################
# Change shell #
################
chsh "$USER" --shell "$(which zsh)"

################
# Autostarting #
################
systemctl enable bluetooth.service
systemctl enable NetworkManager.service
systemctl enable systemd-timesyncd.service
systemctl enable fstrim.timer

########################
# Install Sublime Text #
########################
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && pacman-key --add sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
if grep -q "\[sublime-text\]" /etc/pacman.conf
then
    :
else
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | tee -a /etc/pacman.conf
fi
pacman -Syu --noconfirm sublime-text

#####################
# Install Powerline #
#####################
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts || exit 1
sudo -u "$USER" chmod +x install.sh
sudo -u "$USER" ./install.sh
cd ..
rm -rf fonts

#####################
# Install Oh My Zsh #
#####################
sudo -u "$USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -u "$USER" git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME_DIR"/.oh-my-zsh/plugins/zsh-autosuggestions
sudo -u "$USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME_DIR"/.oh-my-zsh/plugins/zsh-syntax-highlighting

##############
# Copy files #
##############
sudo -u "$USER" cp -a my/. "$HOME_DIR"

echo "Done."
echo "Log out and log back in again as $USER."
