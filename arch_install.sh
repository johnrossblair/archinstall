#!/bin/bash

##### Arch Install #####

is_y_n() {      #Verify that the answer is either 'y' or 'n'.
    while true; do
        if [ "$ANSWER" == "y" ] || [ "$ANSWER" == "n" ]; then
            break
        else
            read -ep "Invalid reponse. Please type 'y' or 'n': " ANSWER
            echo ""
        fi
    done
}

# Prompt for the root password
read -sp "Please enter a root password: " ROOT_PW
echo

# Set the root password
echo "root:$ROOT_PW" | chpasswd

# Prompt for the username
read -p "Please enter a username: " USERNAME

# Create the user
useradd -m -G wheel,users,audio,video,storage,network -s /bin/bash "$USERNAME"

# Prompt for the user's password
read -sp "Please create a password for $USERNAME: " USER_PW
echo

# Set the user's password
echo "$USERNAME:$USER_PW" | chpasswd

echo "Root password and user $USERNAME have been set up successfully."

# Root partition configuration
read -p "Please enter your root partition (needs to start with /dev/): " ROOTPART

while [ ! -e "$ROOTPART" ]; do
    echo "The root partition does not exist, please try again."
    read -p "Please enter your root partition (needs to start with /dev/): " ROOTPART
done

# Timezone and clock setup
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc --utc

# Pacman configuration
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf

# Update mirrorlist with Reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector -c US -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Locale setup
sed -i 's/^#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "archlinux" > /etc/hostname

# Update system
pacman -Syu

# Sudoers configuration
cp /etc/sudoers /etc/sudoers.backup
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Bootloader setup
bootctl install

cat <<EOL > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
EOL

echo "options root=PARTUUID=$(blkid -s PARTUUID -o value $ROOTPART) rw" >> /boot/loader/entries/arch.conf

read -p "Do you have an Nvidia GPU? (y/n): " ANSWER
echo ""

    # Verify answer is valid & set the variable
    is_y_n
    EXCLUDE_HIDDEN_ANSWER=$ANSWER

    # Give option to exclude all hidden files and folders
    if [ "$EXCLUDE_HIDDEN_ANSWER" == "y" ]; then
        pacman -S nvidia-dkms nvidia-utils nvidia-settings opencl-nvidia lib32-opencl-nvidia lib32-nvidia-utils linux-headers
        sed -i 's/^MODULES=().*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sed -i 's/\bkms\s//g' /etc/mkinitcpio.conf
        mkinitcpio -P
    else
        echo "Skipping Nvidia driver install"
    fi

pacman -S plasma-meta sddm xorg-server egl-wayland pipewire lib32-pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack lib32-pipewire-jack speech-dispatcher firefox steam spotify-launcher lutris wine wine-mono wine-gecko winetricks zenity dolphin okular konsole ark kate gwenview spectacle kdeconnect gparted kcalc filelight ksystemlog kompare isoimagewriter kamoso ktorrent sweeper elisa ufw timeshift discord git wget less unrar unzip zip zram-generator fastfetch remmina freerdp libreoffice-fresh power-profiles-daemon qemu-full virt-viewer virt-manager dnsmasq vde2 bridge-utils openbsd-netcat ebtables libguestfs swtpm qemu-img guestfs-tools libosinfo edk2-ovmf virt-install flatpak lshw cups vlc system-config-printer cups-pdf

flatpak install flathub tv.plex.PlexDesktop
flatpak install flathub net.davidotek.pupgui2
wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

cat <<EOL > /etc/systemd/zram-generator.conf
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOL

systemctl enable ufw
ufw enable
ufw allow ssh
systemctl enable fstrim.timer
timedatectl set-ntp true
systemctl enable bluetooth.service
systemctl enable power-profiles-daemon
systemctl enable libvirtd.service
systemctl enable libvirtd.socket
usermod -a -G libvirt $USERNAME
systemctl enable sddm
systemctl enable cups
systemctl enable NetworkManager
