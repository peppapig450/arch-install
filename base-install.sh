#!/usr/bin/env bash

NC='\033[0m'
RED='\033[0;31m'

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

pacman -S --noconfirm grub networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils alsa-utils pulseaudio bash-completion openssh rsync acpi acpi_call openbsd-netcat iptables ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font lshw man-db

if [[ $(fdisk "-l" | awk '/Disklabel/*/type:/ { print $3 }') == 'dos' ]]; then
        grub-install --target=i386-pc $(fdisk "-l" | awk 'NR==1 { print $2 }' | tr -d :)
        grub-mkconfig -o /boot/grub/grub.cfg
elif [[ $(fdisk "-l" | awk '/Disklabel/*/type:/ { print $3 }') == 'gpt' ]]; then
        pacman -S --noconfirm efibootmgr
        grub-install --target=x86_64-efi --efi-directory=$(lsblk "-rno" name,mountpoint | awk -v pat="$(fdisk "-l" | awk '/EFI/*/\System/ { print $1 }' | sed 's|.*/||')" ' $0 ~ pat { print $2 }') --bootloader-id=GRUB
        grub-mkconfig -o /boot/grub/grub.cfg
else
        echo -e "${RED}""Something has gone wrong chief ¯\_(ツ)_/¯""${NC}"
fi

printf "Checking to see if you're on a virtual machine...\n"
vmplat="$(systemd-detect-virt)"
if [[ $(systemd-detect-virt) ]]; then
    if [[ "$vmplat" == "vmware" ]]; then 
        printf  'Installing and enabling vmware tools\n'
        pacman -S --noconfirm open-vm-tools gtkmm3 
        systemctl enable vmtoolsd 
        systemctl enable vmware-vmblock-fuse
    elif [[ "$vmplat" == "oracle" ]]; then
        printf 'Installing and enabling virtualbox extensions\n'
        pacman -S --noconfirm virtualbox-guest-utils
        systemctl enable vboxservice
    else 
        printf 'No virtual machine platform found\n'
    fi
else 
    if [[ $(lshw -C display | grep vendor) =~ Nvidia ]]; then
        printf 'Found Nvidia GPU, installing drivers...'
        pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
    elif [[ $(lshw -C display | grep vendor) =~ 'Advanced Micro Devices' ]]; then
        printf 'Found AMD GPU, installing drivers...'
        pacman -S --noconfirm xf86-video-amdgpu
    elif [[ $(lshw -C display | grep vendor) =~ Intel ]]; then
        printf 'Found Intel GPU, installing drivers...'
        pacman -S --noconfirm mesa
    else 
        printf 'No GPU found'
    fi
fi

if [[ -z $(systemd-detect-virt) ]]; then
    if [[ $(lscpu | grep Vendor) =~ GenuineIntel ]]; then
        printf 'Found Intel CPU installing intel-ucode\n'
        pacman -S --noconfirm intel-ucode
    elif [[ $(lscpu | grep Vendor) =~ AMDisbetter! ]] || [[ $(lscpu | grep Vendor) =~ AuthenticAMD ]];  then
        printf 'Found AMD CPU installing amd-ucode\n'
        pacman -S --noconfirm amd-ucode
    else 
        printf 'No cpu found... or other error\n'
    fi
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

useradd -m "$user"
usermod -aG wheel "$user"

if [ "$pass1" = "$pass2" ]; then
    echo "${user}:${pass1}" | chpasswd
  else
    printf "The passwords do not match!"
fi

ln=$(awk '{ if ( ($2 == "%wheel" && $4 == "ALL")) print NR;}' /etc/sudoers)
sed -i ''"$ln"'s/^#//' /etc/sudoers

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
