if status is-interactive
    # Commands to run in interactive sessions can go here
end


############
# Obsidian #
###########
# https://www.youtube.com/watch?v=1Lmyh0YRH-w
set NOTES_PATH "/home/alex/Documents/git/notes/"

function on -d "Create a new note for obsidian"
    if test (count $argv) -gt 1
        echo "Too many arguments. Wrap file name in quotes"
        return
    else if test $argv[1]
        set file_name $(echo $argv[1] | tr ' ' '-')
        set formatted_file_name $(date "+%Y-%m-%d")_$file_name.md
        cd $NOTES_PATH
        touch "inbox/$formatted_file_name"
        nvim "inbox/$formatted_file_name"
        echo "file name: " $file_name
    else
        echo "Expected an argument!"
        return
    end
end

export PATH="$HOME/.local/share/gem/ruby/3.0.0/gems/jekyll-4.3.3/exe:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/alex/.ghcup/bin # ghcup-env
set -x MANPAGER "nvim +Man!"

abbr --add personal bash ~/personal_docs.sh
abbr --add reading bash ~/reading_session.sh
abbr --add docs cd ~/Documents/git/docs/

function on -d "Create a new note for obsidian"
    if test $argv[1]
        echo $argv[1]
end
