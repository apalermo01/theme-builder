#!/usr/bin/env fish
fisher install dracula/fish
fish_config theme choose "Dracula Official"
fish_config prompt save acidhub

if test -e ~/.config/polybar/i3_polybar_start.sh
    bash ~/.config/polybar/i3_polybar_start.sh
end


