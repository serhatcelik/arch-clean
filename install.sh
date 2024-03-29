#!/bin/bash

if [ "$(id -u)" -eq 0 ]
then
    echo "You are root."
    exit 1
fi

# Install packages
if ! sudo pacman -Syu --noconfirm --needed - < PACKAGES
then
    echo "Alas, Pacman failed."
    exit 1
fi

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Download Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME"/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Download Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Unblock wireless devices
rfkill unblock bluetooth
rfkill unblock wlan

# Enable services
sudo systemctl enable bluetooth.service
sudo systemctl enable lightdm.service
sudo systemctl enable reflector.service

# Enable timers
sudo systemctl enable reflector.timer

# Change default shell
sudo chsh "$USER" --shell "$(which zsh)"

# Add user to the video group
sudo usermod -a -G video "$USER"

# Copy files (user)
cp -a my/. "$HOME"

# Copy files (system)
sudo cp -a system/. /
sudo cp my/.vimrc /root

# Build font information cache files
fc-cache -fv /usr/share/fonts

# Make non-hidden scripts executable
for f in "$HOME"/.local/bin/*
do
    sh -c "chmod +x $f"
done
