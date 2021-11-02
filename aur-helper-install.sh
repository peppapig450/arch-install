#!/usr/bin/env bash

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
        git clone https://aur.archlinux.org/aura.git && cd aura/ && makepkg -sri --noconfirm
    else 
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
    fi
}

function pakku() {
    printf "%s\n" "${BLUE}Pakku is an AUR helper written in Nim.${NORMAL}"
    if ask "Do you want to install Pakku?"; then
        git clone https://aur.archlinux.org/pakku-git.git && cd paku-git/ && makepkg -sri --noconfirm
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
    fi
}

function paru() {
    printf "%s\n" "${BLUE}Paru is an AUR helper written in Rust.${NORMAL}"
    if ask "Do you want to install Paru?"; then
        git clone https://aur.archlinux.org/paru.git && cd paru/ && makepkg -sri --noconfirm
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
    fi
}

function pikaur() {
    printf "%s\n" "${BLUE}Pikaur is an AUR helper written in Python.${NORMAL}"
    if ask "Do you want to install Pikaur?"; then
        git clone https://aur.archlinux.org/pikaur.git && cd pikaur/ && makepkg -sri --noconfirm
    else 
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
    fi
}

function trizen() {
    printf "%s\n" "${BLUE}Trizen in an AUR helper written in Perl that has partial split package support.${NORMAL}"
    if ask "Do you want to install Trizen?"; then
        git clone https://aur.archlinux.org/trizen.git && cd trizen/ && makepkg -sri --noconfirm
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
    fi
}

function yay() {
    printf "%s\n" "${BLUE}Yay is an AUR helper written in Go.${NORMAL}"
    if ask "Do you want to install Yay?"; then
        git clone https://aur.archlinux.org/yay.git && cd yay/ && makepkg -sri --noconfirm
    else
        printf "%s\n" "${BLUE}Okay returning to the menu${NORMAL}"
        sleep 1
        title
    fi
}

menu() {
  printf "%s\n" "
  ${GREEN}1)${NORMAL} ${PURPLE}Aura${NC}
  ${GREEN}2)${NORMAL} ${PURPLE}Pakku${NC}
  ${GREEN}3)${NORMAL} ${PURPLE}Paru${NC}
  ${GREEN}4)${NORMAL} ${PURPLE}Pikaur${NC}
  ${GREEN}5)${NORMAL} ${PURPLE}Trizen${NC}
  ${GREEN}6)${NORMAL} ${PURPLE}Yay${NC}
  ${GREEN}0)${NORMAL} ${CYAN}Exit${NC} "
      read a
      case $a in
        1) aura ; menu ;;
        2) pakku ; menu ;;
        3) paru ; menu ;;
        4) pikaur ; menu ;;
        5) trizen ; menu ;;
        6) yay ; menu ;;
        0) exit 0 ;;
        *) printf "%s\n" ${RED}"Invalid option."${NORMAL}
      esac
}

title
menu
