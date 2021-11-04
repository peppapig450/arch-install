#!/usr/bin/env bash

if [ $(tput colors) -ne 256 ]; then  
  export TERM=xterm-256color ; reset
fi 

. color.sh 

title() {
  clear
  printf '%s\n' ${BLUE}"==========================="${NORMAL}
  printf '%s\n' ${YELLOW}${UNDERLINE}"Installing an AUR Helper"${NORMAL}
  printf '%s\n' ${BLUE}"==========================="${NORMAL}
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

function aura() {
    printf "%s\n" "${BLUE}Aura is an AUR helper written in Haskell that has no file review and partial diff view.${NORMAL}"
    if ask "Do you want to install Aura?"; then
        git clone https://aur.archlinux.org/aura.git
        cd aura/
        makepkg -sri --noconfirm 
    else 
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title 
        menu
    fi
}

function pakku() {
    printf "%s\n" "${BLUE}Pakku is an AUR helper written in Nim.${NORMAL}"
    if ask "Do you want to install Pakku?"; then
        git clone https://aur.archlinux.org/pakku-git.git 
        cd paku-git/ 
        makepkg -sri --noconfirm
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
        menu
    fi
}

function paru() {
    printf "%s\n" "${BLUE}Paru is an AUR helper written in Rust.${NORMAL}"
    if ask "Do you want to install Paru?"; then
        git clone https://aur.archlinux.org/paru.git 
        cd paru/ 
        makepkg -sri --noconfirm 
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
        menu
    fi
}

function pikaur() {
    printf "%s\n" "${BLUE}Pikaur is an AUR helper written in Python.${NORMAL}"
    if ask "Do you want to install Pikaur?"; then
        git clone https://aur.archlinux.org/pikaur.git 
        cd pikaur/ 
        makepkg -sri --noconfirm 
    else 
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
        menu
    fi
}

function trizen() {
    printf "%s\n" "${BLUE}Trizen in an AUR helper written in Perl that has partial split package support.${NORMAL}"
    if ask "Do you want to install Trizen?"; then
        git clone https://aur.archlinux.org/trizen.git 
        cd trizen/ 
        makepkg -sri --noconfirm
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
        menu
    fi
}

function yay() {
    printf "%s\n" "${BLUE}Yay is an AUR helper written in Go.${NORMAL}"
    if ask "Do you want to install Yay?"; then
        git clone https://aur.archlinux.org/yay.git 
        cd yay/ 
        makepkg -sri --noconfirm 
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
        menu
    fi
}

menu() {
  printf "%s\n" "
  ${GREEN}1)${NORMAL} ${MAGENTA}Aura${NORMAL}
  ${GREEN}2)${NORMAL} ${MAGENTA}Pakku${NORMAL}
  ${GREEN}3)${NORMAL} ${MAGENTA}Paru${NORMAL}
  ${GREEN}4)${NORMAL} ${MAGENTA}Pikaur${NORMAL}
  ${GREEN}5)${NORMAL} ${MAGENTA}Trizen${NORMAL}
  ${GREEN}6)${NORMAL} ${MAGENTA}Yay${NORMAL}
  ${GREEN}0)${NORMAL} ${CYAN}Exit${NORMAL} "
      read a
      case $a in
        1) aura ;;
        2) pakku ;;
        3) paru ;;
        4) pikaur ;;
        5) trizen ;;
        6) yay ;;
        0) exit 0 ;;
        *) printf "%s\n" "${RED}Invalid option.${NORMAL}"
      esac
}

title 
menu
