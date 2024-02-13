#!/bin/bash

read -r -p "Enter username: " USER
read -s -r -p "Enter password: " PASS

if [ -z "$USER" ] || [ -z "$PASS" ]
then
    echo "Not enough credentials, shell not changed."
else
    yes "$PASS" | sudo -S chsh "$USER" --shell "$(which zsh)"
fi

if ! sudo pacman -Syu --noconfirm --needed alacritty alsa-utils arandr base-devel bluez bluez-utils caja curl dkms feh ffmpeg firefox flameshot gcc git htop i3 iptables ipython john jq libreoffice make man mesa nano neofetch net-tools netcat networkmanager openssh openvpn p7zip picom pipewire powerline powerline-fonts pavucontrol pulseaudio python-pip rofi sudo unzip vim wget which wireshark-cli wireshark-qt xorg xorg-xinit zsh
then
    echo "Alas, Pacman failed."
    exit 1
fi

if ! grep -q "\[sublime-text\]" /etc/pacman.conf
then
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu sublime-text --noconfirm --needed
fi

git clone https://github.com/powerline/fonts.git --depth=1
mkdir -p ~/.local/share/fonts
cp fonts/RobotoMono/* ~/.local/share/fonts
fc-cache -fv ~/.local/share/fonts
rm -rf fonts

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

cp -a my/. ~

