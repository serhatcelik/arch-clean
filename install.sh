#!/bin/bash

printRed() {
    printf "\033[31m%s\033[0m\n" "$1"
}

printBlue() {
    printf "\033[34m%s\033[0m\n" "$1"
}

sigint() {
    echo
    echo
    echo "Bye."
    exit 2
}


trap sigint SIGINT


if [ "$(id -u)" -eq 0 ]
then
    printRed "[x] You are root."
    exit 1
else
    sudo true  # Get sudo token
fi


printBlue "[*] INSTALL PACKAGES"

if ! sudo pacman -Syu --noconfirm --needed alacritty alsa-utils arandr base-devel blueberry bluez bluez-utils brightnessctl caja code copyq curl dkms feh ffmpeg firefox flameshot gcc git htop i3 iptables ipython john jq libreoffice make man mesa nano neofetch net-tools netcat networkmanager openssh openvpn p7zip pavucontrol picom polybar powerline powerline-fonts pulseaudio python-pip reflector rofi sudo unzip vim wget which wireshark-cli wireshark-qt xorg xorg-xinit zsh
then
    printRed "[x] Alas, Pacman failed."
    exit 1
fi


printBlue "[*] CREATE REFLECTOR CONFIG"

cat << EOF | sudo tee /etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--country Türkiye,Germany
--protocol https
--latest 10
--download-timeout 90
EOF


printBlue "[*] ENABLE REFLECTOR SERVICE"

sudo systemctl enable reflector.timer
sudo systemctl enable reflector.service


printBlue "[*] INSTALL SUBLIME TEXT"

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
if ! grep -q "\[sublime-text\]" /etc/pacman.conf
then
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
fi
sudo pacman -Syu sublime-text --noconfirm --needed


printBlue "[*] DOWNLOAD FONTS"

wget -q --show-progress --no-clobber https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip
wget -q --show-progress --no-clobber https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
git clone https://github.com/powerline/fonts.git --depth=1


printBlue "[*] INSTALL FONTS"

mkdir -p "$HOME/.local/share/fonts"
unzip -o RobotoMono.zip -d "$HOME/.local/share/fonts"
unzip -o JetBrainsMono-2.304.zip -d JetBrainsMono
cp JetBrainsMono/fonts/ttf/* "$HOME/.local/share/fonts"
cp fonts/RobotoMono/* "$HOME/.local/share/fonts"


printBlue "[*] BUILD FONT INFORMATION CACHE FILES"

fc-cache -fv "$HOME/.local/share/fonts"


printBlue "[*] INSTALL OH MY ZSH"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


printBlue "[*] DOWNLOAD OH MY ZSH PLUGINS"

git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"


printBlue "[*] DISABLE DPMS"

cat << EOF | sudo tee /etc/X11/xorg.conf.d/10-monitor.conf
Section "Extensions"
    Option "DPMS" "Disable"
EndSection

Section "ServerFlags"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
EndSection

Section "ServerLayout"
    Identifier "ServerLayout0"
EndSection

Section "Monitor"
    Identifier "eDP-1"
    Option "DPMS" "false"
EndSection

Section "Monitor"
    Identifier "HDMI-1"
    Option "DPMS" "false"
EndSection
EOF


printBlue "[*] CHANGE DEFAULT SHELL TO ZSH"

if ! sudo chsh "$USER" --shell "$(which zsh)"
then
    printRed "[x] Cannot change shell."
    exit 1
fi


printBlue "[*] ADD USER TO THE VIDEO GROUP"

sudo usermod -a -G video "$USER"


printBlue "[*] BRIGHTNESS FIX"

cat << EOF | sudo tee /etc/udev/rules.d/45-backlight.rules
ACTION=="add",SUBSYSTEM=="backlight",KERNEL=="intel_backlight",RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
ACTION=="add",SUBSYSTEM=="backlight",KERNEL=="intel_backlight",RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
EOF


printBlue "[*] COPY CONFIGS"

cp -a my/. "$HOME"


printBlue "[*] MAKE THE POLYBAR SCRIPT EXECUTABLE"

chmod +x "$HOME/.config/polybar/launch.sh"
