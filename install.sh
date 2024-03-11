#!/bin/bash

ERR="\033[31m"
INF="\033[34m"


msg() {
    echo -e "$1$2\033[0m"
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
    msg "$ERR" "You are root."
    exit 1
else
    sudo true  # Get sudo token
fi


msg "$INF" "== INSTALL PACKAGES =="

if ! sudo pacman -Syu --noconfirm --needed alacritty alsa-utils arandr base base-devel bluez bluez-utils brightnessctl caja copyq curl dkms feh ffmpeg firefox flameshot gcc git htop i3 intel-media-driver iptables ipython john jq libreoffice libva-intel-driver libva-mesa-driver lightdm lightdm-gtk-greeter make man mesa nano neofetch net-tools netcat networkmanager openssh openvpn p7zip papirus-icon-theme pavucontrol picom polybar powerline powerline-fonts pulseaudio python python-pip reflector rofi sudo tk unzip vim vulkan-intel vulkan-radeon wget which wireshark-cli wireshark-qt xf86-input-libinput xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware xorg xorg-server xorg-xinit xss-lock zip zsh
then
    msg "$ERR" "Alas, Pacman failed."
    exit 1
fi


msg "$INF" "== CREATE REFLECTOR CONFIG =="

cat << EOF | sudo tee /etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--country Germany
--protocol https
--latest 10
--download-timeout 90
EOF


msg "$INF" "== UNBLOCK WIRELESS DEVICES WITH RFKILL =="

rfkill unblock bluetooth
rfkill unblock wlan


msg "$INF" "== ENABLE SERVICES =="

sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo systemctl enable reflector.timer
sudo systemctl enable reflector.service


msg "$INF" "== INSTALL SUBLIME TEXT =="

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
if ! grep -q "\[sublime-text\]" /etc/pacman.conf
then
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
fi
sudo pacman -Syu sublime-text --noconfirm --needed


msg "$INF" "== INSTALL OH MY ZSH =="

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


msg "$INF" "== DOWNLOAD OH MY ZSH PLUGINS =="

git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"


msg "$INF" "== DISABLE DPMS =="

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


msg "$INF" "== CHANGE DEFAULT SHELL TO ZSH =="

if ! sudo chsh "$USER" --shell "$(which zsh)"
then
    msg "$ERR" "Cannot change shell."
    exit 1
fi


msg "$INF" "== ADD USER TO THE VIDEO GROUP =="

sudo usermod -a -G video "$USER"


msg "$INF" "== BRIGHTNESS FIX =="

cat << EOF | sudo tee /etc/udev/rules.d/45-backlight.rules
ACTION=="add",SUBSYSTEM=="backlight",KERNEL=="intel_backlight",RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
ACTION=="add",SUBSYSTEM=="backlight",KERNEL=="intel_backlight",RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
EOF


msg "$INF" "== INSTALL POWERLEVEL10K =="

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"


msg "$INF" "== COPY CONFIGS =="

cp -a my/. "$HOME"


msg "$INF" "== COPY CONFIGS FOR SYSTEM-WIDE USAGE =="

sudo cp -a system/. /


msg "$INF" "== BUILD FONT INFORMATION CACHE FILES =="

fc-cache -fv /usr/share/fonts


msg "$INF" "== MAKE THE POLYBAR SCRIPTS EXECUTABLE =="

for f in .sh .py
do
    sh -c "chmod +x $HOME/.config/polybar/*$f"
done
