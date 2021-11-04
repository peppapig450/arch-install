#!/bin/bash 
if [ $(tput colors) -ne 256 ]; then  
  export TERM=xterm-256color ; reset
fi 

source color.sh 

printf '%s\n' "
  ${GREEN}1)${NORMAL} ${MAGENTA}Aura${NORMAL}
  ${GREEN}2)${NORMAL} ${MAGENTA}Pakku${NORMAL}
  ${GREEN}3)${NORMAL} ${MAGENTA}Paru${NORMAL}
  ${GREEN}4)${NORMAL} ${MAGENTA}Pikaur${NORMAL}
  ${GREEN}5)${NORMAL} ${MAGENTA}Trizen${NORMAL}
  ${GREEN}6)${NORMAL} ${MAGENTA}Yay${NORMAL}
  ${GREEN}0)${NORMAL} ${CYAN}Exit${NORMAL} "
