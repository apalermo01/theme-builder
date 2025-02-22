#!/bin/bash

# TODO: check distro before running these

echo "installing fish shell..."
sudo pacman -S fish

echo "installing maple mono font..."
yay -S ttf-maple
