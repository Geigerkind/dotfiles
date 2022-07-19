#!/bin/bash

yay -s system76-io-dkms system76-dkms system76-firmware-daemon firmware-manager-git system76-acpi-dkms system76-driver system76-power

# Fixes sha512 error during dkms
sudo ln -s /usr/bin/sha512sum /usr/bin/sha512

sudo systemctl enable --now system76-firmware-daemon
sudo systemctl enable --now system76
sudo systemctl enable --now com.system76.PowerDaemon.service

sudo yay -S nvidia nvidia-utils nvidia-settings nvidia-prime optimus-manager

# PRIME
sudo cp ./graphics/optimus-manager.conf /etc/optimus-manager/
sudo systemctl enable optimus-manager

# Audio
pacman -S alsa alsa-firmware pulseaudio pavucontrol
# Create the following file
echo "options snd_hda_intel probe_mask=1" > /etc/modprobe.d/audio-patch.conf

# Java
sudo pacman -S jre-openjdk jdk-openjdk
sudo archlinux-java set java-18-openjdk

# Anti-Virus
sudo pacman -S clamav
freshclam
sudo systemctl enable clamav-freshclam.service
sudo systemctl start clamav-freshclam.service

# Printer
yay -S cups cups-pdf usbutils
sudo systemctl enable cups.socket
