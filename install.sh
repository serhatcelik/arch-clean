#!/bin/bash

if [ "$(id -u)" -eq 0 ]
then
    echo "YOU ARE ROOT."
fi
#!/bin/bash

prepare() {
    read -r -p "Enter username: " USER
    read -r -s -p "Enter password: " PASS

    if id -u "$USER"
    then
        return 1
    fi

    if [ -z "$USER" ] || [ -z "$PASS" ]
    then
        return 1
    fi

    HOME_DIR="/home/$USER"

    if ! useradd --gid users --groups wheel --shell "$(which zsh)" --create-home "$USER" --home-dir "$HOME_DIR"
    then
        return 1
    fi

    yes "$PASS" | passwd "$USER"

    EDITOR=$(which vim)
    export EDITOR
    visudo

    if ! pacman -Syu --noconfirm alacritty alsa-utils arandr base-devel bluez bluez-utils caja curl dkms feh ffmpeg firefox flameshot gcc git htop i3 iptables ipython john jq libreoffice make man mesa neofetch net-tools netcat networkmanager openssh openvpn p7zip picom powerline powerline-fonts pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer python-pip rofi sudo unzip vim virtualbox-guest-utils vulkan-icd-loader wget which wireshark-cli wireshark-qt xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-vmmouse xorg xorg-xinit zsh
    then
        return 1
    fi

    systemctl enable bluetooth.service
    systemctl enable iwd.service
    systemctl enable NetworkManager.service
    systemctl enable systemd-timesyncd.service
    systemctl enable fstrim.timer

    if [ $? -ne 0 ]
    then
        return 1
    fi

    echo "DONE."
    echo "Reboot and log in as $USER."
    echo "Then run me again."
}

install() {
    if ! grep -q "\[sublime-text\]" /etc/pacman.conf
    then
        curl -O https://download.sublimetext.com/sublimehq-pub.gpg && pacman-key --add sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
        echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | tee -a /etc/pacman.conf
        sudo pacman -Syu --noconfirm sublime-text
    fi

    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts || exit 1
    chmod +x install.sh
    ./install.sh
    cd ..
    rm -rf fonts

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

    cp -a my/. ~

    echo "DONE."
    echo "Log out and log back in again."
}

if [ "$(id -u)" -eq 0 ]
then
    prepare
else
    install
fi
