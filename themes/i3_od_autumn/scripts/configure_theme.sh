#!/usr/bin/env sh
###!/usr/bin/env fish
# kitty +kitten themes --reload-in=all catppuccin-macchiato
# fisher install rkbk60/onedark-fish
# fish_config prompt save acidhub

# set -l onedark_options '-b'
#
# if set -q VIM
#     # Using from vim/neovim.
#     set onedark_options "-256"
# else if string match -iq "eterm*" $TERM
#     # Using from emacs.
#     function fish_title; true; end
#     set onedark_options "-256"
# end
#
# set_onedark $onedark_options


if test -e ~/.config/polybar/i3_polybar_start.sh
    bash ~/.config/polybar/i3_polybar_start.sh
end


