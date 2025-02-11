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

function og -d "Move notes based on tags" 
    set VAULTS craft personal
    
    for VAULT_NAME in $VAULTS
        find "$NOTES_PATH/notes/$VAULT_NAME" -type f -name '*.md' | while read -l file;
            echo "Processing $file"
            set tag $(awk -F': ' '/^type:/{print $2; exit}' "$file" | sed -e 's/^ *//;s/ *$//')
            if [ ! -z "$tag" ]
                echo "Found tag $tag"
                set TARGET_DIR "$NOTES_PATH/notes/$VAULT_NAME/$tag" 

                mkdir -p $TARGET_DIR
                mv $file "$TARGET_DIR/" 
                echo "Moved $file to $TARGET_DIR"
            else 
                echo "No type tag found"
            end
        end
    end
end
export PATH="$HOME/.local/share/gem/ruby/3.0.0/gems/jekyll-4.3.3/exe:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/alex/.ghcup/bin # ghcup-env
set -x MANPAGER "nvim +Man!"

abbr --add personal bash ~/personal_docs.sh
abbr --add reading bash ~/reading_session.sh
abbr --add notes cd ~/Documents/git/notes/

