#!/bin/fish
fisher install rose-pine/fish
fish_config prompt save acidhub
fish_config theme choose "Rosé Pine"

kitty +kitten themes --reload-in=all Rosé Pine


if test -e ~/.config/polybar/i3_polybar_start.sh
    bash ~/.config/polybar/i3_polybar_start.sh
end
