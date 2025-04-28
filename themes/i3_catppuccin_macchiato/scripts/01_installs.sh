#!/usr/bin/env sh

# TODO: check distro before running these

# read -p "Install fish shell (y/n)?" choice
# case "$choice" in 
#     y|Y) echo "installing fish shell..." && sudo pacman -S fish;;
# esac

read -p "Install maple font? (y/n)?" choice
case "$choice" in 
    y|Y) echo "installing maple mono font..." && yay -S ttf-maple;;
esac
