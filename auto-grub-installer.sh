#!/usr/bin/env bash

NC='\033[0m'
RED='\033[0;31m'

if [[ $(fdisk "-l" | awk '/Disklabel/*/type:/ { print $3 }') == 'dos' ]]; then
        grub-install --target=i386-pc $(fdisk "-l" | awk '/dev/*/\*/ { print $1 }'
        grub-mkconfig -o /boot/grub/grub.cfg
elif [[ $(fdisk "-l" | awk '/Disklabel/*/type:/ { print $3 }') == 'gpt' ]]; then
        var=$(fdisk "-l" | awk '/EFI/*/\System/ { print $1 }' | cut -c6-)
        grub-install --target=x86_64-efi --efi-directory=$(lsblk "-rno" name,mountpoint | awk -v pat="$var" '$0 ~ pat { print $2}') --bootloader-id=GRUB
        grub-mkconfig -o /boot/grub/grub.cfg
else
        echo -e "${RED}""Something has gone wrong chief ¯\_(ツ)_/¯""${NC}"
fi
