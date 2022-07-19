#!/bin/bash

dhcpcd
sudo pacman -S zip unzip tar unrar wget htop clang cmake git python go openssh npm pacman-contrib pkgconfig autoconf automake man p7zip bzip2 zstd xz gzip

sudo systemctl enable --now NetworkManager
sudo systemctl enable --now acpid

sudo pacman -S intel-ucode
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo pacman -S apparmor
sudo systemctl enable --now apparmor.service

sudo pacman -S ufw
sudo systemctl enable --now ufw
sudo ufw enable

sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j12"/g' /etc/makepkg.conf
