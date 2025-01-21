#!/bin/fish
kitty +kitten themes --reload-in=all catppuccin-mocha
fisher install catppuccin/fish
fish_config theme save "Catppuccin Mocha"
fish_config prompt save terlar
bash ~/.config/polybar/i3_polybar_start.sh
