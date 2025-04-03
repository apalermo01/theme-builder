export PATH="/opt/nvim-linux64/bin/nvim:$PATH"
set -U OBSIDIAN_NOTES_DIR /mnt/c/Users/apalermo/github/notes/
set -U NOTES_DIR /mnt/c/Users/apalermo/github/notes/

if status is-interactive
    set -l onedark_options '-b'

    if set -q VIM
        # Using from vim/neovim.
        set onedark_options "-256"
    else if string match -iq "eterm*" $TERM
        # Using from emacs.
        function fish_title; true; end
        set onedark_options "-256"
    end

    set_onedark $onedark_options
end
