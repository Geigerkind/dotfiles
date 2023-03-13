#!/bin/bash

PARTITION_HOME=${1}

sudo pacman -S zip unzip tar unrar wget htop clang cmake git python go openssh npm pacman-contrib pkgconfig autoconf automake man p7zip bzip2 zstd xz gzip ntp

# Network
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now acpid

# Time
sudo cp ./misc/timesyncd.conf /etc/systemd/
sudo timedatectl set-ntp 1

# Intel ucode
sudo pacman -S intel-ucode
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Apparmor
sudo pacman -S apparmor
sudo systemctl enable --now apparmor.service
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"cryptdevice=\/dev\/${PARTITION_HOME}:luks_root\"/GRUB_CMDLINE_LINUX=\"apparmor=1 lsm=lockdown,yama,apparmor cryptdevice=\/dev\/${PARTITION_HOME}:luks_root\"/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# UFW
sudo pacman -S ufw
sudo systemctl enable --now ufw
sudo ufw enable

# Yay
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j12"/g' /etc/makepkg.conf
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg
sudo pacman -U $(find ./ -name "*.tar.zst" | cut -c3-)
cd ..
rm -rf yay

# System76
# Fixes sha512 error during dkms
sudo ln -s /usr/bin/sha512sum /usr/bin/sha512

yay -S system76-io-dkms system76-dkms system76-firmware-daemon firmware-manager-git system76-acpi-dkms system76-driver system76-power

sudo systemctl enable --now system76-firmware-daemon
sudo systemctl enable --now system76
sudo systemctl enable --now com.system76.PowerDaemon.service

sudo yay -S nvidia nvidia-utils nvidia-settings nvidia-prime

# PRIME
yay -S optimus-manager
sudo cp ./graphics/optimus-manager.conf /etc/optimus-manager/
sudo systemctl enable optimus-manager
sudo sed -i "s/MODULES=()/MODULES=(intel_agp i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g" /etc/mkinitcpio.conf
sudo mkinitcpio -P

sudo sed -i "s/GRUB_CMDLINE_LIUNUX_DEFAULT=\"loglevel=3 quiet\"/GRUB_CMDLINE_LIUNUX_DEFAULT=\"fbcon=map:1 quiet loglevel=3 splash rd.driver.blacklist=nouveau nvidia-drm.modeset=1\"/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo mkdir /etc/pacman.d/hooks
sudo cp ./graphics/nvidia.hook /etc/pacman.d/hooks/

# Audio
yay -S alsa alsa-firmware pulseaudio pavucontrol
sudo cp ./audio/audio-patch.conf /etc/modprobe.d/
sudo -i "s/load-module module-role-cork/#load-module module-role-cork/g" /etc/pulse/default.pa

# Java
sudo pacman -S jre-openjdk jdk-openjdk
sudo archlinux-java set java-18-openjdk

# Anti-Virus
sudo pacman -S clamav
sudo cp ./misc/clamd.conf /etc/clamav/

sudo freshclam
sudo systemctl enable clamav-freshclam.service
sudo systemctl start clamav-freshclam.service

sudo systemctl enable clamav-daemon.service
sudo systemctl start clamav-daemon.service

sudo systemctl enable clamav-clamonacc.service
sudo systemctl start clamav-clamonacc.service

# Printer
yay -S cups cups-pdf usbutils
sudo systemctl enable cups.socket

# Display Link
yay -S evdi displaylink
sudo cp ./graphics/60-evdi.conf /etc/X11/xorg.conf.d/
sudo systemctl enable displaylink.service
