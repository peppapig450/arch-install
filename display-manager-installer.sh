#!/usr/bin/env bash

stty -echoctl 

oldterm="$TERM"

if [ $(tput colors) -ne 256 ]; then 
  export TERM=xterm-256color ; reset 
fi 

control_c() {
  tput setaf 1 
  printf '\r%s' "SIGINT caught"
  tput sgr0
  sleep 1 
  printf '\r%s' "Setting terminal back to what it was before..."
  export TERM="$oldterm" ; reset 
  exit 1

}

source color.sh 

aur=$(find /usr/bin -type f | awk -F/ '/paru/ || /yay/ || /aura/ || /pacaur/ || /pakku/ || /trizen/ || /pikaur/ {print $4}')
shell=$(grep "$USER" /etc/passwd | awk -F: '{print $7}' | sed 's@.*/@@')

title() {
    clear
    echo -e ${RED}"============================="${NORMAL} 
    echo -e ${LIME_YELLOW}"Installing a Display Manager"${NORMAL}
    echo -e ${RED}"============================="${NORMAL}
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
    echo -e ${BLUE}"CDM is a minimalistic, yet full-featured replacement for display managers like SLiM, SDDM and GDM written in pure Bash."${NORMAL}
    if ask "Would you like to install CDM?"; then
      "$aur" -S --noconfirm cdm 
      sudo systemctl disable display-manager && sudo systemctl enable cdm
    else 
      echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
      sleep 1
      title
    fi
}

ctdm() {
    echo -e ${BLUE}"Console TDM is an extension for xorg-xinit written in pure Bash."${NORMAL}
    if ask "Would you like to install Console TDM?"; then
        "$aur" -S --noconfirm console-tdm xorg-xinit
        sudo systemctl disable display-manager 
        if [[ $shell == 'bash' ]]; then
            echo 'source /usr/bin/tdm' >> ~/.bashrc
        elif [[ $shell == 'zsh' ]]; then
            echo 'bash /usr/bin/tdm' >> ~/.zshrc 
        elif [[ $shell =~ 'csh' ]]; then 
            echo 'bash /usr/bin/tdm' >> ~/.cshrc
        fi 
        cp 'xinitrc' ~/.xinitrc
        sed -i '/tdm/ s/^#//' ~/.xinitrc
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

ly() {
    echo -e ${BLUE}"Ly is a lightweight TUI (ncurses-like) display manager for Linux and BSD."${NORMAL}
    if ask "Would you like to install Ly?"; then
        "$aur" -S --noconfirm ly
        sudo systemctl disable display-manager & sudo systemctl enable ly
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

tbsm() {
    echo -e ${BLUE}"TBSM is a Bash session or application launcher with no ncurses or dialog depencies. Supports X and Wayland sessions."${NORMAL}
    if ask "Would you like to install tbsm?"; then
        "$aur" -S --noconfirm tbsm
        if [[ $shell == 'bash' ]]; then
            echo '[[ $XDG_VTNR -le 2 ]] && tbsm' >> ~/.bash_profile;
        elif [[ $shell == 'zsh' ]]; then
            echo '[[ $XDG_VTNR -le 2 ]] && tbsm' >> ~/.zprofile;
        #else 
        #    echo ' [[ $XDG_VTNR -le '
        fi
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

entrance() {
    echo -e ${BLUE}"Entrance is the display manager for Enlightenment."${NORMAL}
    if ask "Would you like to install Entrance?"; then
        "$aur" -S --noconfirm entrance-git
        sudo systemctl disable display-manager && sudo systemctl enable entrance
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

gdm() {
    echo -e ${BLUE}"GDM is the display manager for GNOME."${NORMAL}
    if ask "Would you like to install GDM?"; then
        sudo pacman -S --noconfirm gdm
        sudo systemctl disable display-manager && sudo systemctl enable gdm
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

lightdm() {
    echo -e ${BLUE}"LightDM is a cross-desktop display manager, can use various front-ends written in any toolkit."${NORMAL}
    if ask "Would you like to install LightDM?"; then
        sudo pacman -S --noconfirm lightdm xorg-server lightdm-gtk-greeter lightdm-gtk-greeter-settings
        sudo systemctl disable display-manager && sudo systemctl enable lightdm
        sudo sed -i 's/#greeter-session=.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

lxdm() {
    echo -e ${BLUE}"LXDM is a lightweight display manager for the LXDE desktop environment. The UI is implemented with GTK 2. Can be used independent of the LXDE desktop environment"${NORMAL}
    if ask "Would you like to install LXDM"; then
        sudo pacman -S --noconfirm lxdm
        sudo systemctl disable display-manager && sudo systemctl enable lxdm
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title
    fi
}

sddm() {
    echo -e ${BLUE}"SDDM is a display manager for the X11 and Wayland windowing systems. SDDM supports theming via QML, and is the recommended display manager for the KDE Plasma and LXQt desktop environments."${NORMAL}
    if ask "Would you like to install SDDM"; then
        sudo pacman -S --noconfirm sddm sddm-kce
        sudo systemctl disable display-manager && sudo systemctl enable sddm
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title 
    fi
}

xdm() {
    echo -e ${BLUE}"XDM provides a simple and straightforward graphical login prompt, and gets the sessions from ~/.xinitrc."${NORMAL}
    if ask "Would you like to install XDM?"; then
        if ask "Would you like to install the Arch Linux theme for XDM?"; then
            sudo pacman -S --noconfirm xdm-archlinux
            sudo systemctl disable display-manager && sudo systemctl enable xdm-archlinux
        else
            sudo pacman -S --noconfirm xorg-xdm
            sudo systemctl disable display-manager && sudo systmectl enable xdm
        fi
    else
        echo -e ${BLUE}"Okay returning to the menu"${NORMAL}
        sleep 1
        title 
        menu
    fi
}

menu() {
    echo -e "
    ${GREEN}1)${NORMAL} ${MAGENTA}CDM${NORMAL}          
    ${GREEN}2)${NORMAL} ${MAGENTA}Console TDM${NORMAL}
    ${GREEN}3)${NORMAL} ${MAGENTA}Ly${NORMAL}            
    ${GREEN}4)${NORMAL} ${MAGENTA}TBSM${NORMAL}
    ${GREEN}5)${NORMAL} ${MAGENTA}Entrance${NORMAL}      
    ${GREEN}6)${NORMAL} ${MAGENTA}GDM${NORMAL}
    ${GREEN}7)${NORMAL} ${MAGENTA}LightDM${NORMAL}       
    ${GREEN}8)${NORMAL} ${MAGENTA}LXDM${NORMAL}
    ${GREEN}9)${NORMAL} ${MAGENTA}SDDM${NORMAL}          
    ${GREEN}10)${NORMAL} ${MAGENTA}XDM${NORMAL}
    ${GREEN}0)${NORMAL} ${CYAN}Exit${NORMAL} "
        read a
        case $a in
          1) cdm ; exit 0;;
          2) ctdm ; exit 0;;
          3) ly ; exit 0;;
          4) tbsm ; exit 0;;
          5) entrance ; exit 0;;
          6) gdm  ; exit 0;;
          7) lightdm ; exit 0;;
          8) lxdm ; exit 0;;
          9) sddm ; exit 0;;
          10) xdm ; exit 0;;
          0) exit 0 ;;
          *) echo -e ${RED}"Invalid option."${NORMAL}
        esac
}

trap 'control_c' SIGINT 

while true; do
  title && menu 
done 
