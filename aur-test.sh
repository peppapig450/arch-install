#!/bin/bash

git clone https://aur.archlinux.org/aura.git
cd aura
makepkg -sri --noconfirm
