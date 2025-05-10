#!/usr/bin/env sh
###!/usr/bin/env fish
# fish_config prompt save acidhub
# fish_config theme save cyberdream

if [ ! -d ~/.config/tmux/plugins/catppuccin ]; then
    mkdir -p ~/.config/tmux/plugins/catppuccin
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

# if test -e ~/cyberdream.conf
#     mv ~/cyberdream.conf ~/.config/tmux/plugins/catppuccin/tmux/themes/catppuccin_cyberdream_tmux.conf
# end

kitten themes --reload-in=all cyberdream

if [ -f ~/.config/polybar/i3_polybar_start.sh ]; then
    bash ~/.config/polybar/i3_polybar_start.sh
fi

