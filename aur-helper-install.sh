#!/usr/bin/env bash

. color.sh 

title() {
  clear
  printf '%s\n' ${BLUE}"==========================="${NORMAL}
  printf '%s\n' ${YELLOW}"Installing an AUR Helper"${NORMAL}
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
    echo -e "${BLUE}Aura is an AUR helper written in Haskell that has no file review and partial diff view.${NC}"
    if ask "Do you want to install Aura?"; then
        git clone https://aur.archlinux.org/aura.git && cd aura/ && makepkg -sri --noconfirm
    else 
        echo -e "${BLUE}Okay returning to the menu${NC}"
        sleep 1
        title
    fi
}

function pakku() {
    echo -e "${BLUE}Pakku is an AUR helper written in Nim.${NC}"
    if ask "Do you want to install Pakku?"; then
        git clone https://aur.archlinux.org/pakku-git.git && cd aura/ && makepkg -sri --noconfirm
    else
        echo -e "${BLUE}Okay returning to the menu${NC}"
        sleep 1
        title
    fi
}

function paru() {
    echo -e "${BLUE}Paru is an AUR helper written in Rust.${NC}"
    if ask "Do you want to install Paru?"; then
        git clone https://aur.archlinux.org/paru.git && cd paru/ && makepkg -sri --noconfirm
    else
        echo -e "${BLUE}Okay returning to the menu${NC}"
        sleep 1
        title
    fi
}

function pikaur() {
    echo -e "${BLUE}Pikaur is an AUR helper written in Python.${NC}"
    if ask "Do you want to install Pikaur?"; then
        git clone https://aur.archlinux.org/pikaur.git && cd pikaur/ && makepkg -sri --noconfirm
    else 
        echo -e "${BLUE}Okay returning to the menu${NC}"
        sleep 1
        title
    fi
}

function trizen() {
    echo -e "${BLUE}Trizen in an AUR helper written in Perl that has partial split package support.${NC}"
    if ask "Do you want to install Trizen?"; then
        git clone https://aur.archlinux.org/trizen.git && cd trizen/ && makepkg -sri --noconfirm
    else
        echo -e "${BLUE}Okay returning to the menu${NC}"
        sleep 1
        title
    fi
}

function yay() {
    echo -e "${BLUE}Yay is an AUR helper written in Go.${NC}"
    if ask "Do you want to install Yay?"; then
        git clone https://aur.archlinux.org/yay.git && cd yay/ && makepkg -sri --noconfirm
    else
        echo -e "${BLUE}Okay returning to the menu${NC}"
        sleep 1
        title
    fi
}

menu() {
  echo -e "
  ${GREEN}1)${NC} ${PURPLE}Aura${NC}
  ${GREEN}2)${NC} ${PURPLE}Pakku${NC}
  ${GREEN}3)${NC} ${PURPLE}Paru${NC}
  ${GREEN}4)${NC} ${PURPLE}Pikaur${NC}
  ${GREEN}5)${NC} ${PURPLE}Trizen${NC}
  ${GREEN}6)${NC} ${PURPLE}Yay${NC}
  ${GREEN}0)${NC} ${CYAN}Exit${NC} "
      read a
      case $a in
        1) aura ; menu ;;
        2) pakku ; menu ;;
        3) paru ; menu ;;
        4) pikaur ; menu ;;
        5) trizen ; menu ;;
        6) yay ; menu ;;
        0) exit 0 ;;
        *) echo -e ${RED}"Invalid option."${NC}
      esac
}

title
menu
