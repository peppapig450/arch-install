#!/usr/bin/env bash 

COL=$(tput cols)
kernel=''

kernel_menu() {
    printf '\t%s\n' "What kernel would you like to install?"
    echo
  {
    printf '\t%s %s\n' "1)" "Linux"
    printf '\t%s %s\n' "2)" "Linux Zen"
    printf '\t%s %s\n' "3)" "Linux LTS"
    printf '\t%s %s\n' "4)" "Linux Hardened"
  } | gpr -t2 -w "$((COL-40))"
    echo 
    printf '\t%s %s\n' "x)" "x to exit"
    read main 
  clear 
  while [[ "$main" != '\n' ]]; do
    if [[ "$main" = "\n" ]]; then 
      exit 1;
    else 
      case $main in 
    1) kernel='linux';
       printf '%s\n' "$kernel";
       exit 0;
        ;;
    2) kernel='linux-zen'
       printf '%s\n' "$kernel";
       exit 0;
        ;;
    3) kernel='linux-lts'
       printf '%s\n' "$kernel";
       exit 0;
        ;;
    4)
       kernel='linux-hardened'
       printf '%s\n' "$kernel";
       exit 0;
        ;;
    x) exit 0;
        ;;
    *)
      kernel='linux'
      printf '%s\n' "Installing default Linux kernel";
      exit 0;
      ;;
  esac
    fi
  done 
}
kernel_menu
