#!/bin/bash

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg
sudo pacman -U $(find ./ -name "*.tar.zst" | cut -c3-)
cd ..
rm -rf yay
