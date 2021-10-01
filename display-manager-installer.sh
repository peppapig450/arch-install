#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
RED='\033[0;31m'
PURPLE='\033[1;35m'
CYAN='\033[0;36m'
PURP='\033[0;35m'
CY='\033[1;35m'
LG='\033[1;32m'

aur=$(ls /usr/bin/ | grep -e yay -e paru -e aura -e pacaur -e pakku -e pikaur -e trizen)
use=$(/usr/bin/$aur | sed 's|.*/||')

title() {
        clear
        echo -e ${RED}"==========================="${NC} 
        echo -e ${LG}"Installing an Display Manager"${NC}
        echo -e ${RED}"==========================="${NC}
}

ask() {
    local prompt default reply

    if [[ ${2:-} = 'Y' ]]; then
        prompt='Y/n'
        default='Y'
    elif [[ ${2:-} = 'N' ]]; then
        prompt='y/N'
        default='N'
    else
        prompt='y/n'
        default=''
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read -r reply </dev/tty

        # Default?
        if [[ -z $reply ]]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

function cdm() {
        echo -e ${BLUE}"CDM is a minimalistic, yet full-featured replacement for display managers like SLiM, SDDM and GDM that provides a fast, dialog-based login system without the overhead of the X Window System. Written in pure bash, CDM has almost no dependencies, yet supports multiple users/sessions and can start virtually any desktop environment or window manager."${NC}
        if ask "Would you like to install cdm?"; then
            use -S --noconfirm cdm 
            dm=$(cat /etc/X11/default-display-manager | cut -c10-)
            sudo systemctl disable $dm
            sudo systemctl enable cdm
        else 
            

