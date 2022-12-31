#!/bin/bash

## Packages
yay -S firefox alacritty exa nautilus discord-canary-electron-bin neofetch spotify libreoffice xournal
yay -S btop
yay -S postman
yay -S intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre 
yay -S neovim nvim-packer-git
yay -S keepassxc virtualbox terraform chromium microsoft-edge-stable-bin 
yay -S docker docker-compose
yay -S xorg autotiling-git udiskie sddm qt5-quickcontrols2 qt5-graphicaleffects qt5-svg vulkan-icd-loader vulkan-validation-layers qt5-virtualkeyboard
yay -S ulauncher translate-shell python-pip starship
yay -S plymouth-git
yay -S pop-theme
yay -S i3-gaps polybar feh picom dunst network-manager-applet flameshot i3lock i3lockmore-git copyq xss-lock xclip
yay -S zscroll-git
yay -S ttf-jetbrains-mono ttf-caladea ttf-carlito ttf-opensans noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-liberation ttf-dejavu ttf-roboto ttf-inconsolata ttf-font-awesome ttf-ubuntu-font-family ttf-d2coding ttf-muli nerd-fonts-source-code-pro ttf-unifont siji-ttf termsyn-font

# Graphics appendix
sudo cp ./graphics/50-gpu.conf /etc/X11/xorg.conf.d/

pip install requests --user

sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker shino

## Fonts
sudo mkdir -p /usr/local/share/fonts/
sudo cp ./fonts/* /usr/local/share/fonts/
fc-cache
gsettings set org.gnome.desktop.interface monospace-font-name 'Liberation Mono 11'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface font-name 'Roboto 11'

## Config
sudo mkdir /home/root/.config
sudo cp -r ./.config/nvim /home/root/.config/

cp -r ./.config ~/
cp -r ./.local ~/
cp ./.home/.bashrc ~/
cp ./.home/.terraformrc ~/
cp -r ./.home/.terraform.d ~/ 
sudo cp ./environment /etc/

## Home
mkdir ~/Repos
mkdir ~/Work
mkdir ~/Screenshots

## ACPI Lid closed
sudo cp ./laptop-lid-display-toggle/logind.conf /etc/systemd/
sudo cp ./laptop-lid-display-toggle/laptop-lid /etc/acpi/events/laptop-lid
sudo cp ./laptop-lid-display-toggle/laptop-lid.sh /etc/acpi/
sudo chmod 777 /etc/acpi/laptop-lid.sh

## Wayland
yay -S playerctl sway-git swaylock swayidle waybar swaybg-git brightnessctl wireplumber mako wl-clipboard clipman swayshot
yay -S xdg-desktop-portal-wlr slurp
yay -S wdisplays jq

# You may need to do this so brightnessctl works
#sudo chmod u+s /usr/bin/brightnessctl

## Plymouth
sudo cp -r ./plymouth/pop-basic /usr/share/plymouth/themes/
sudo cp ./plymouth/plymouthd.conf /etc/plymouth/
sudo cp ./plymouth/sddm-plymouth.service
sudo sed -i "s/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/HOOKS=(base udev plymouth plymouth-encrypt autodetect modconf block filesystems keyboard fsck)/g" /etc/mkinitcpio.conf
sudo mkinitcpio -p linux
sudo plymouth-set-default-theme pop-basic -R

## SDDM
sudo cp -r ./config/sddm/sugar-candy /usr/share/sddm/themes/
sudo cp ./config/sddm/Xsetup /usr/share/sddm/scripts/Xsetup
sudo cp ./config/sddm/sddm.conf /etc/sddm.conf
sudo cp ./config/sddm/sway* /usr/share/wayland-sessions/
sudo systemctl enable sddm.conf



