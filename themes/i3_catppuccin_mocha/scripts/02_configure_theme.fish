#!/usr/bin/env sh
###!/usr/bin/env fish
kitty +kitten themes --reload-in=all catppuccin-macchiato
# fisher install catppuccin/fish
# fish_config theme save "Catppuccin Mocha"
# fish_config prompt save terlar

if [ -f ~/.config/polybar/i3_polybar_start.sh ]; then
    bash ~/.config/polybar/i3_polybar_start.sh
fi
