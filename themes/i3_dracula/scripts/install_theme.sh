#!/usr/bin/env bash
# fisher install dracula/fish
# fish_config theme choose "Dracula Official"
# fish_config prompt save acidhub

if [ -f ~/.config/polybar/i3_polybar_start.sh ]; then
    bash ~/.config/polybar/i3_polybar_start.sh
fi

ya pack -a yazi-rs/flavors:dracula
