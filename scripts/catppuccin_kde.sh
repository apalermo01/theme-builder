#!/bin/bash 

echo "Configuring KDE theme..."

git clone --depth=1 https://github.com/catppuccin/kde /tmp/catppuccin-kde && cd /tmp/catppuccin-kde

./install.sh
