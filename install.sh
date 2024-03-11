#!/bin/bash

trap "" SIGINT

if [ "$(id -u)" -eq 0 ]
then
    echo "You are root."
    exit 1
else
    sudo true  # Get sudo token
fi

# Install packages
if ! sudo pacman -Syu --noconfirm --needed alacritty alsa-utils arandr base base-devel bluez bluez-utils brightnessctl caja copyq curl dkms feh ffmpeg firefox flameshot gcc git htop i3 intel-media-driver iptables ipython john jq libreoffice libva-intel-driver libva-mesa-driver lightdm lightdm-gtk-greeter make man mesa nano neofetch net-tools netcat networkmanager openssh openvpn p7zip papirus-icon-theme pavucontrol picom polybar powerline powerline-fonts pulseaudio python python-pip reflector rofi sudo tk unzip vim vulkan-intel vulkan-radeon wget which wireshark-cli wireshark-qt xf86-input-libinput xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xf86-video-vmware xorg xorg-server xorg-xinit xss-lock zip zsh
then
    echo "Alas, Pacman failed."
    exit 1
fi

# Install Sublime Text
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
grep -q "sublime-text" /etc/pacman.conf || echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu sublime-text --noconfirm --needed

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Download Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"

# Download Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Unblock wireless devices with rfkill
rfkill unblock bluetooth
rfkill unblock wlan

# Enable services
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo systemctl enable reflector.service

# Enable timers
sudo systemctl enable reflector.timer

# Change default shell to zsh
sudo chsh "$USER" --shell "$(which zsh)"

# Add user to the video group
sudo usermod -a -G video "$USER"

# Copy files (user)
cp -a my/. "$HOME"

# Copy files (system)
sudo cp -a system/. /

# Build font information cache files
fc-cache -fv /usr/share/fonts

# Make the polybar scripts executable
for f in .sh .py
do
    sh -c "chmod +x $HOME/.config/polybar/*$f"
done
