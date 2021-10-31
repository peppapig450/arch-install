#!/usr/bin/env bash

aur=$(find /usr/bin -type f | awk -F/ '/paru/ || /yay/ || /aura/ || /pacaur/ || /pakku/ || /trizen/ || /pikaur/ {print $4}')
shell=$(ps -p $$ | awk 'FNR==2 { print $4 }')

title() {
    clear
    echo -e ${RED}"============================="${NC} 
    echo -e ${LG}"Installing a Display Manager"${NC}
    echo -e ${RED}"============================="${NC}
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

cdm() {
    echo -e ${BLUE}"CDM is a minimalistic, yet full-featured replacement for display managers like SLiM, SDDM and GDM written in pure Bash."${NC}
    if ask "Would you like to install CDM?"; then
      "$aur" -S --noconfirm cdm 
      if [[ -d /etc/X11/default-display-manager ]]; then
        sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable cdm
      else 
        sudo systemctl enable cdm
      fi
    else 
      echo -e ${BLUE}"Okay returning to the menu"${NC}
      sleep 1
      title
    fi
}

ctdm() {
    echo -e ${BLUE}"Console TDM is an extension for xorg-xinit written in pure Bash."${NC}
    if ask "Would you like to install Console TDM?"; then
        "$aur" -S --noconfirm console-tdm xorg-xinit
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager)
        fi
        if [[ $shell == 'bash' ]]; then
            echo 'source /usr/bin/tdm' >> ~/.bash_profile
        elif [[ $shell == 'zsh' ]]; then
            echo 'bash /usr/bin/tdm' >> ~/.zprofile
        fi
        cp $(pwd)'/xinitrc' ~/.xinitrc
        sed -i '/tdm/ s/^#//' ~/.xinitrc
    else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

ly() {
    echo -e ${BLUE}"Ly is a lightweight TUI (ncurses-like) display manager for Linux and BSD."${NC}
    if ask "Would you like to install Ly?"; then
        "$aur" -S --noconfirm ly
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable ly
        else
          sudo systemctl enable ly
        fi
      else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

tbsm() {
    echo -e ${BLUE}"TBSM is a Bash session or application launcher with no ncurses or dialog depencies. Supports X and Wayland sessions."${NC}
    if ask "Would you like to install tbsm?"; then
        "$aur" -S --noconfirm tbsm
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager)            fi
        if [[ $shell == 'bash' ]]; then
            echo '[[ $XDG_VTNR -le 2 ]] && tbsm' >> ~/.bash_profile;
        elif [[ $shell == 'zsh' ]]; then
            echo '[[ $XDG_VTNR -le 2 ]] && tbsm' >> ~/.zprofile;
        else 
            echo ' [[ $XDG_VTNR -le '
        fi
    else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

entrance() {
    echo -e ${BLUE}"Entrance is the display manager for Enlightenment."${NC}
    if ask "Would you like to install Entrance?"; then
        "$aur" -S --noconfirm entrance-git
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable entrance
        else 
          sudo systemctl enable entrance
        fi
    else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

gdm() {
    echo -e ${BLUE}"GDM is the display manager for GNOME."${NC}
    if ask "Would you like to install GDM?"; then
        sudo pacman -S --noconfirm gdm
        if [[ -d /etc/X11/default-display-manager ]]; then
            sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable gdm
        else
          sudo systemctl enable gdm
        fi
      else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

lightdm() {
    echo -e ${BLUE}"LightDM is a cross-desktop display manager, can use various front-ends written in any toolkit."${NC}
    if ask "Would you like to install LightDM?"; then
        sudo pacman -S --noconfirm lightdm xorg-server lightdm-gtk-greeter lightdm-gtk-greeter-settings
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager)
        fi
        sudo systemctl enable lightdm
        sudo sed -i 's/#greeter-session=.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
    else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

lxdm() {
    echo -e ${BLUE}"LXDM is a lightweight display manager for the LXDE desktop environment. The UI is implemented with GTK 2. Can be used independent of the LXDE desktop environment"${NC}
    if ask "Would you like to install LXDM"; then
        sudo pacman -S --noconfirm lxdm
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable lxdm
        else 
          sudo systemctl enable lxdm
        fi
      else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title
    fi
}

sddm() {
    echo -e ${BLUE}"SDDM is a display manager for the X11 and Wayland windowing systems. SDDM supports theming via QML, and is the recommended display manager for the KDE Plasma and LXQt desktop environments."${NC}
    if ask "Would you like to install SDDM"; then
        sudo pacman -S --noconfirm sddm sddm-kce
        if [[ -d /etc/X11/default-display-manager ]]; then
          sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable sddm
        else 
          sudo systemctl enable sddm
        fi
      else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title 
    fi
}

xdm() {
    echo -e ${BLUE}"XDM provides a simple and straightforward graphical login prompt, and gets the sessions from ~/.xinitrc."${NC}
    if ask "Would you like to install XDM?"; then
        if ask "Would you like to install the Arch Linux theme for XDM?"; then
            sudo pacman -S --noconfirm xdm-archlinux
            if [[ -d /etc/X11/default-display-manager ]]; then
                sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable xdm-archlinux
            else 
              sudo systemctl enable xdm-archlinux
            fi
        else
            sudo pacman -S --noconfirm xorg-xdm
            if [[ -d /etc/X11/default-display-manager ]]; then
                sudo systemctl disable $(awk -F/ '{print $4}' /etc/X11/default-display-manager) && sudo systemctl enable xdm
            fi
            sudo systemctl enable xdm
        fi
    else
        echo -e ${BLUE}"Okay returning to the menu"${NC}
        sleep 1
        title 
    fi
}

menu() {
    echo -e "
    ${GREEN}1)${NC} ${PURPLE}CDM${NC}          
    ${GREEN}2)${NC} ${PURPLE}Console TDM${NC}
    ${GREEN}3)${NC} ${PURPLE}Ly${NC}            
    ${GREEN}4)${NC} ${PURPLE}TBSM${NC}
    ${GREEN}5)${NC} ${PURPLE}Entrance${NC}      
    ${GREEN}6)${NC} ${PURPLE}GDM${NC}
    ${GREEN}7)${NC} ${PURPLE}LightDM${NC}       
    ${GREEN}8)${NC} ${PURPLE}LXDM${NC}
    ${GREEN}9)${NC} ${PURPLE}SDDM${NC}          
    ${GREEN}10)${NC} ${PURPLE}XDM${NC}
    ${GREEN}0)${NC} ${CYAN}Exit${NC} "
        read a
        case $a in
          1) cdm ; menu ;;
          2) ctdm ; menu ;;
          3) ly ; menu ;;
          4) tbsm ; menu ;;
          5) entrance ; menu ;;
          6) gdm ; menu ;;
          7) lightdm ; menu ;;
          8) lxdm ; menu ;;
          9) sddm ; menu ;;
          10) xdm ; menu ;;
          0) exit 0 ;;
          *) echo -e ${RED}"Invalid option."${NC}
        esac
}

title
menu
