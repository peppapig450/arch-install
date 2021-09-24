#!/usr/bin/env bash

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf
echo "arch" >>/etc/hostname
echo "127.0.0.1 localhost" >>/etc/hosts
echo "::1       localhost" >>/etc/hosts
echo "127.0.1.1 arch.localdomain arch" >>/etc/hosts

echo "Please enter password to use for root: "
read -s rootpass
echo "Please repeat the same password: "
read -s rootpass2
if [ $rootpass = $rootpass2 ]; then
    echo "root:${rootpass}" | chpasswd
else
    printf "The passwords do not match!"
fi

pacman -S --noconfirm grub networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils alsa-utils pulseaudio bash-completion openssh rsync acpi acpi_call openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font 

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

printf "Checking to see if you're on a virtual machine..."
vmplat=$(systemd-detect-virt)
if [[ $vmplat == "vmware" ]]; then
    printf 'Found vmware platform, installing and enabling vmware tools'
    pacman -S --noconfirm open-vm-tools gtkmm3 
    systemctl enable vmtoolsd 
    systemctl enable vmware-vmblock-fuse
elif [[ $vmplat == "oracle" ]]; then
    printf 'Found virtualbox platform, installing and enabling vbox extensions'
    pacman -S --noconfirm virtualbox-guest-utils
    systemctl enable vboxservice
else 
    printf 'No virtual machine platform found'
fi

if [[ $(lshw -C display | grep vendor) =~ Nvidia ]]; then
    printf 'Found Nvidia GPU, installing drivers...'
    pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
elif [[ $(lshw -C display | grep vendor) =~ Advanced Micro Devices ]]; then
    printf 'Found AMD GPU, installing drivers...'
    pacman -S --noconfirm xf86-video-amdgpu
elif [[ $(lshw -C display | grep vendor) =~ Intel ]]; then
    printf 'Found Intel GPU, installing drivers...'
    pacman -S --noconfirm mesa
else 
    printf 'No GPU found'
fi


systemctl enable NetworkManager
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

echo "Enter the user you want to create: "
read user
echo "What password do you want to use for this user? "
read -s pass1
echo "Re-enter the password: "
read -s pass2

useradd -m ${user}
usermod -aG wheel ${user}

if [ $pass1 = $pass2 ]; then
    echo "${user}:${pass1}" | chpasswd
else
    printf "The passwords do not match!"
fi

sed -i '82s/.//' /etc/sudoers

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
