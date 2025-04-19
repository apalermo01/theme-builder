#!/usr/bin/env fish
# kitty +kitten themes --reload-in=all catppuccin-macchiato
fisher install jomik/fish-gruvbox
fish_config prompt save acidhub
bash ~/.config/polybar/i3_polybar_start.sh

if test -e ~/.config/polybar/i3_polybar_start.sh
    bash ~/.config/polybar/i3_polybar_start.sh
end

