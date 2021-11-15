#!/usr/bin/env bash
if [ "$(tput colors)" -ne 256 ]; then
	export TERM=xterm-256color
	reset
fi

. color.sh
# Define functions

# function to set root password
setrpass() {
	read -r -s -p "Enter the password you want to use for root: " rootpass
	echo
	read -r -s -p "Please repeat the password: " rootpass2
	echo
	if [[ -z "$rootpass" ]] || [[ -z "$rootpass2" ]]; then
		printf "%s\n" "${RED}Either one or both of the passwords were empty, please try again.${NORMAL}"
		sleep 4
		return 42
	elif [[ "$rootpass" != "$rootpass2" ]]; then
		printf "%s\n" 'The passwords do not match, please try again.'
		sleep 4
		return 69
	else
		printf "root:${rootpass}" | chpasswd
		return 0
	fi
}

# function to set user password
setupass() {
	read -r -p "Enter the name of the user you would like to create: " username
	echo
	read -r -s -p "Enter the password you would like to use for ${username}: " userpass
	echo
	read -r -s -p "Please repeat the password: " userpass2
	echo
	if [[ -z "$userpass" ]] || [[ -z "$userpass2" ]]; then
		printf "%s\n" "${RED}Either one of the passwords, or both were empty, please make sure to type something!${NORMAL}"
		sleep 4
		return 13
	elif [[ -z "$username" ]]; then
		printf "%s\n" "${RED}The username is empty, please make sure to type something!${NORMAL}"
		sleep 4
		return 3
	elif [[ "$userpass" -ne "$userpass2" ]]; then
		printf "%s\n" "${RED}The passwords do not match, please try again.${NORMAL}"
		sleep 4
		return 62
	else
		awk -F: '{print $1}' /etc/passwd | while IFS="" read -r f || [ -n "$f" ]; do
			if [[ "$username" == "$f" ]]; then
				printf "%s\n" "${RED}That username already exists! Try another one.${NORMAL}"
				return 16
			else
				useradd -m "$username"
				usermod -aG wheel "$username"
				printf "${username}:${userpass}" | chpasswd
				return 0
			fi
		done
	fi
}

kernel() {
	pacman -Q | grep linux | awk -v pat="5" '$2 ~ pat {print $1}' | while read -r line; do
		if [[ "$line" != *'headers'* ]]; then
			pacman -S --noconfirm "$line"-headers
		fi
	done
}

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf
read -p "What hostname would you like to use: " host
echo ${host} >>/etc/hostname
echo "127.0.0.1 localhost" >>/etc/hosts
echo "::1       localhost" >>/etc/hosts
echo "127.0.1.1 ${host}.localdomain ${host}" >>/etc/hosts

setrpass
until [ $? -eq 0 ]; do
	clear
	setrpass
done

kernel && pacman -S --noconfirm "$headers"

pacman -S --noconfirm grub networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils alsa-utils pulseaudio pulseaudio-alsa bash-completion openssh rsync acpi acpi_call openbsd-netcat iptables ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font lshw man-db

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

vmplat="$(systemd-detect-virt)"
if [[ $(systemd-detect-virt) ]]; then
	if [[ "$vmplat" == "vmware" ]]; then
		pacman -S --noconfirm open-vm-tools gtkmm3
		systemctl enable vmtoolsd
		systemctl enable vmware-vmblock-fuse
	elif [[ "$vmplat" == "oracle" ]]; then
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
		printf '%s\n' "${MAGENTA}Installing amd gpu drivers"
		pacman -S --noconfirm xf86-video-amdgpu
	elif [[ $(lshw -C display | grep vendor) =~ Intel ]]; then
		printf '%s\n' "${MAGENTA}Installing intel gpu drivers${NORMAL}"
		sleep 1
		pacman -S --noconfirm mesa
	else
		printf '%s\n' "${RED}${UNDERLINE}No GPU found${NORMAL}"
	fi
fi

if [[ -z $(systemd-detect-virt) ]]; then
	if [[ $(lscpu | grep Vendor) =~ GenuineIntel ]]; then
		printf '%s\n' "${CYAN}Installing intel-ucode${NORMAL}"
		sleep 1
		pacman -S --noconfirm intel-ucode
	elif [[ $(lscpu | grep Vendor) =~ AMDisbetter! ]] || [[ $(lscpu | grep Vendor) =~ AuthenticAMD ]]; then
		printf '%s\n' "${CYAN}Installing amd-ucode${NORMAL}"
		sleep 1
		pacman -S --noconfirm amd-ucode
	else
		printf '%s\n' "${RED}${UNDERLINE}No cpu found${NORMAL}"
	fi
fi

systemctl enable NetworkManager
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

setupass
until [ $? -eq 0 ]; do
	clear
	setupass
done

ln=$(awk '{ if ( ($2 == "%wheel" && $4 == "ALL")) print NR;}' /etc/sudoers)
sed -i ''"$ln"'s/^#//' /etc/sudoers

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
