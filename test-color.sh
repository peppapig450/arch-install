#!/bin/sh
if [ $(tput colors) -eq 256 ]; then
	continue
else
	export TERM=xterm-256color
	reset
fi
