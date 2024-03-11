#!/bin/bash

trap "" SIGINT  # Ignore SIGINT


echo "+++ CHECK IF RUNNING AS ROOT +++"

if [ "$(id -u)" -eq 0 ]
then
    echo "--- you are root ---"
    exit 1
else
    sudo true  # Get sudo token
fi


echo "+++ INSTALL PACKAGES +++"

if ! sudo pacman -Syu --noconfirm --needed alacritty alsa-utils arandr base base-devel bluez bluez-utils brightnessctl caja copyq curl dkms feh ffmpeg firefox flameshot gcc git htop i3 intel-media-driver iptables ipython john jq libreoffice libva-intel-driver libva-mesa-driver lightdm lightdm-gtk-greeter make man mesa nano neofetch net-tools netcat networkmanager openssh openvpn p7zip papirus-icon-theme pavucontrol picom polybar powerline powerline-fonts pulseaudio python python-pip reflector rofi sudo tk unzip vim vulkan-intel vulkan-radeon wget which wireshark-cli wireshark-qt xf86-input-libinput xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware xorg xorg-server xorg-xinit xss-lock zip zsh
then
    echo "--- alas, pacman failed ---"
    exit 1
fi


echo "+++ INSTALL SUBLIME TEXT +++"

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
if ! grep -q "\[sublime-text\]" /etc/pacman.conf
then
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
fi
sudo pacman -Syu sublime-text --noconfirm --needed


echo "+++ INSTALL OH MY ZSH +++"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


echo "+++ DOWNLOAD OH MY ZSH PLUGINS +++"

git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"


echo "+++ DOWNLOAD POWERLEVEL10K THEME +++"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"


echo "+++ UNBLOCK WIRELESS DEVICES WITH RFKILL +++"

rfkill unblock bluetooth
rfkill unblock wlan


echo "+++ ENABLE SERVICES +++"

sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo systemctl enable reflector.service


echo "+++ ENABLE TIMERS +++"

sudo systemctl enable reflector.timer


echo "+++ CHANGE DEFAULT SHELL TO ZSH +++"

if ! sudo chsh "$USER" --shell "$(which zsh)"
then
    echo "--- cannot change shell ---"
    exit 1
fi


echo "+++ ADD USER TO THE VIDEO GROUP +++"

sudo usermod -a -G video "$USER"


echo "+++ COPY CONFIGS (USER) +++"

cp -a my/. "$HOME"


echo "+++ COPY CONFIGS (SYSTEM) +++"

sudo cp -a system/. /


echo "+++ BUILD FONT INFORMATION CACHE FILES +++"

fc-cache -fv /usr/share/fonts


echo "+++ MAKE THE POLYBAR SCRIPTS EXECUTABLE +++"

for f in .sh .py
do
    sh -c "chmod +x $HOME/.config/polybar/*$f"
done
