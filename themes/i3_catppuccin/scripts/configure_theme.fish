#!/bin/fish
kitty +kitten themes --reload-in=all catppuccin-mocha
fisher install catppuccin/fish
fish_config theme save "Catppuccin Mocha"
fish_config prompt choose terlar
