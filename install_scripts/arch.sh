#!/bin/bash

echo "Installing dependencies for desktop themes on arch"

read -p "Install hyprland? [y, n]" input
case $input in
    y|Y)
        
        echo "Installing hyprland and it's dependencies"
        sudo pacman -S hyprland hyprpaper waybar
    esac

read -p "Install i3? [y, n]" input
case $input in
    y|Y)
        
        echo "Installing i3 with it's dependencies"
        sudo pacman -S i3 feh picom python-pywal rofi

        read -p "Install bumblebee status? [y, n]" input2

        case $input2 in
            y|Y)
            mkdir /tmp/bumblebee-status
            cd /tmp/bumblebee-status
            git clone https://aur.archlinux.org/bumblebee-status.git
            cd bumblebee-status
            makepkg -sicr
            cd ~
        esac

        read -p "Install polybar? [y, n]" input3

        case $input3 in
            y|Y)
            sudo pacman -S polybar
        esac
esac
