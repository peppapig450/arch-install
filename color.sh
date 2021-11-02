#!/bin/sh

if [ $(tput colors) -ne 256 ]; then  
  export TERM=xterm-256color ; reset
fi 

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
ORANGE=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
GREY=$(tput setaf 8)
YELLOW=$(tput setaf 11)
SALMON=$(tput setaf 9)
LIGHT_PURPLE=$(tput setaf 12)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)
