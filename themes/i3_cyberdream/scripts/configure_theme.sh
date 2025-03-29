#!/bin/fish
fish_config prompt save acidhub
fish_config theme save cyberdream

if test  ! -d ~/.config/tmux/plugins/catppuccin
    mkdir -p ~/.config/tmux/plugins/catppuccin
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
end

if test -e ~/cyberdream.conf
    mv ~/cyberdream.conf ~/.config/tmux/plugins/catppuccin/tmux/themes/catppuccin_cyberdream_tmux.conf

end
kitten themes --reload-in=all cyberdream
bash ~/.config/polybar/i3_polybar_start.sh


