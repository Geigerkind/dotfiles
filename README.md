# Arch Linux i3 setup on a System76 Oryx Pro 7
## Features
* Full disk encryption
* System76 packages installed
* i3 and Sway setups
* Startup Arch Linux logo and styled FDE password prompt
* SDDM greeter
* Notifications 
* Built-In screen turns off when lid is closed

## Wayland: Known bugs
* Screensharing only works with the integrated graphics card
* Screenshots only work with the integrated graphics card

## Preview
<details>
<summary>SDDM greeter</summary>

![greeter](preview/greeter.png)
</details>

<details>
<summary>Xorg with i3</summary>

![i3](preview/i3.png)
</details>
<details>
<summary>Wayland with sway</summary>

![sway](preview/sway.png)
</details>

## Bindings
<details>
<summary>VIM Bindings</summary>

### Moving
#### Words
* **b**: Move to the start of the **previous** word
* **w**: Move to the start of the **next** word
* **e**: Move to the end of the word
#### Lines
* **0**: Move to the start of the line
* **^**: Move to the first **non-blank** character of the line
* **$**: Move to the end of the line
* **:<LINE_NUMBER>**: Move to a specific line
* **G**: Move to the end of the file
* **gg**: Move to the begginning of the file

### Inserting Text
* **a**: Insert **after** the cursor
* **A**: Insert at the **end** of the line
* **o**: Insert **below** the current line
* **O**: Insert **above** the current line

### Editing Text
* **r**: Replace a single character and return to command mode
* **cc**: **Replace (its in the clipboard)** entire line and go into insert mode
* **c<MOVEMENT CHARACTER>**: Replace from the cursor to whereever specified after
* **J / gJ**: Merge with the line below with or without a space
* **u**: Undo
* **CTRL + r**: Redo
* **w !sudo tee %**: Write file using sudo and tee

### Copy and Paste
* **yy**: Copy line
* **dd**: Cut line
* **p**: Paste **after** the cursor
* **P**: Paste **before** the cursor

### Selecting
* **v**: Select by character
* **V**: Select by line
* **CTRL + v**: Select by block mode
* **y**: Copy selected
* **d**: Cut selected
* **u**: Change to lowercase
* **U**: Change to uppercase

### Searching
* **(/|?)pattern**: Forward or backward pattern search
* **n**: Repeat search in same direction
* **N**: Repeat search in oppsosite direction

</details>
<details>
<summary>IntelliJ</summary>

* **CTRL + ALT + R**: Rename
* **CTRL + ALT + T**: Sorround with
* **CTRL + ALT + V**: Extract local variable
* **CTRL + ALT + F**: Extract to field
* **CTRL + ALT + N**: Inline
* **CTRL + ALT + M**: Extract method

</details>

## Installation
<details>
<summary>System setup</summary>

### Create a bootable ArchLinux USB drive
```sh
sudo umount /dev/sdx
sudo dd bs=4M if=arch_linux.ISO of=/dev/sdb status=progress
```

Insert drive and reboot into the drive.

### Installation convinience
```sh
# Available keyboard layouts
ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys de-latin1

# Adjust TTY font size
ls /usr/share/kbd/consolefonts | grep -P "[2-9]\d+\.ps"
# Use the biggest font you can find
setfont latarcyrheb-sun32
```

### Verify boot mode
If it shows an output it uses UEFI, if not it uses BIOS
```sh
ls /sys/firmware/efi/efivars
```
This tutorial only supports UEFI.

### Setting up an internet connection
```sh
# Verify your connection
ping www.google.com

# If not try this
## Ethernet
### Find adapters
ip link
### Configure adapter
ip link set NIC up
dhclient NIC

## Wireless
ip link
ip link set wlan0 up
### Chose on variant
#### No encryption
iw dev wlan0 connect “your_essid”
#### WEP
iw dev wlan0 connect “your_essid” key 0:your_key
#### WPA/WPA2
wpa_passphrase my_essid my_passphrase > /etc/wpa_supplicant/my_essid.conf
wpa_supplicant -c /etc/wpa_supplicant/my_essid.conf -i wlan0
wpa_supplicant -B -c /etc/wpa_supplicant/my_essid.conf -i wlan0
dhclient wlan0

# Verify your connection
ping www.google.com
```

### Update system clock
```sh
timedatectl set-ntp true
```

### Prepare for LUKS encryption
```sh
modprobe dm-crypt
modprobe dm-mod
```

### Prepare disks
```sh
# Find your disk for me its nvme1n1
lsblk

# You may have to remove partitions before
# Follow the instructions d, enter, select partition, repeat
fdisk /dev/nvme0n1

# Choose gpt
cfdisk /dev/nvme0n1
# Create 3 partitions
## Goto new, enter size and select type, 'Free Space'
## First: Size: 256MB, Type: 'EFI'
## Second: Size: 512MB, Type: 'ext4'
## Third: Size: Rest, Type: 'ext4'
## Goto write and press enter
```

#### Encrypt root partition
```sh
# Confirm with uppercase YES and type desired password
cryptsetup luksFormat -v -s 512 -h sha512 /dev/nvme0n1p3

# Open it, it will prompt for your password
# The partition will be available under /dev/mapper/luks_root
cryptsetup open /dev/nvme0n1p3 luks_root
```

#### Format and mount file system
```sh
# Format all partitions
mkfs.vfat -n “EFI” /dev/nvme0n1p1
mkfs.ext4 -L boot /dev/nvme0n1p2
mkfs.ext4 -L root /dev/mapper/luks_root

# Mount them
mount /dev/mapper/luks_root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
mkdir /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

# Create a swap
cd /mnt
dd if=/dev/zero of=swap bs=1M count=65536
mkswap swap
swapon swap
chmod 0600 swap
```

### Update Pacman mirrors
Find the mirror closes to you and copy it to the top of the list
```sh
vim /etc/pacman.d/mirrorslist
```

### Installing ArchLinux
```bash
# Pacstrap
pacstrap -i /mnt base base-devel efibootmgr grub linux linux-firmare networkmanager sudo vi gvim bash-completion nano
genfstab -U /mnt >> /mnt/etc/fstab

# Change root to new system
arch-chroot /mnt

pacman -S git
git clone https://github.com/Geigerkind/dotfiles
cd dotfiles
bash ./scripts/install_arch.sh nvme0n1p2 nvme0n1p3

exit
reboot
```
</details>

<details>
<summary>Configuration</summary>

```bash
sudo dhcpcd
git clone https://github.com/Geigerkind/dotfiles
bash ./scripts/config.sh nvme0n1p3

# Enable dGPU
reboot
prime-offload
optimus-manager --switch nvidia
sudo system76-power graphics nvidia

reboot
```
</details>

<details>
<summary>Ricing</summary>

```bash
bash ./scripts/rice.sh

nvim +PackerInstall

# reboot for everything to take effect
```
</details>
