#!/usr/bin/env bash

NC='\033[0m'
RED='\033[0;31m'

if [[ $(fdisk "-l" | awk '/Disklabel/*/type:/ { print $3 }') == 'dos' ]]; then
        echo "grub-install --target=i386-pc $(fdisk "-l" | awk '/dev/*/\*/ { print $1 }')"
elif [[ $(fdisk "-l" | awk '/Disklabel/*/type:/ { print $3 }') == 'gpt' ]]; then
        var=$(sudo fdisk "-l" | awk '/EFI/*/\System/ { print $1 }' | cut -c6-)
        loc=$(lsblk "-rno" name,mountpoint | awk -v pat="$var" '$0 ~ pat { print $2}')
        #fs=$(cat joe.txt)
        echo "grub-install --target=x86_64-efi --efi-directory=$loc --bootloader-id=GRUB"
        #echo "fuck this shit"
else
        echo -e "${RED}""Something has gone wrong chief ¯\_(ツ)_/¯""${NC}"
fi
