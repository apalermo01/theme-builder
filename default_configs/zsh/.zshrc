###########
# General #
###########

export MANPAGER "nvim +Man!"

function quick_commit() {
    today=$(date "+%Y-%m-%d")
    git add . && git commit -m "$today"
}

######################
# Obsidian Functions #
######################

export NOTES_PATH "/home/alex/Documents/git/notes"

new_tech_note() {
    if [[ "$#" -ne 1 ]]; then
        echo "ont: generate a new note in tech notes inbox"
        echo "usage: ont name-of-note"
        exit 1
    fi

    file_name=$(echo $1 | tr ' ' '-')
    formatted_file_name=$(date "+%Y-%m-%d")_$file_name.md
    cd $NOTES_PATH
    touch "0-notes/0-notes/0-inbox/$formatted_file_name"
    nvim "0-notes/0-notes/0-inbox/$formatted_file_name"
}

new_personal_note() {
    if [[ "$#" -ne 1 ]]; then
        echo "onp: generate a new note in tech notes inbox"
        echo "usage: onp name-of-note"
        exit 1
    fi

    file_name=$(echo $1 | tr ' ' '-')
    formatted_file_name=$(date "+%Y-%m-%d")_$file_name.md
    cd $NOTES_PATH
    touch "0-notes/1-private/0-inbox/$formatted_file_name"
    nvim "0-notes/1-private/0-inbox/$formatted_file_name"
}

move_note_on_type() { 
    vaults=("0-notes", "1-private")

    for vault_name in ${vaults[@]}; do
        find "$NOTES_PATH/0-notes/$vault_name/5-zettelkasten/" \
            -type f -name '*.md' -not -path "*tags*" | \
            while read -l file;
            
            tag=$(awk -F': ' '/^type:/{print $2; exit}' "$file" | sed -e 's/^ *//;s/ *$//')
            if [ ! -z "$tag" ]; then
                target_dir="$NOTES_PATH/0-notes/$vault_name/5-zettelkasten/$tag"

                if [ $file != "$target_dir/(path basename $file)" ]; then
                    echo "Processihng (path basename $file)"
                    echo "Found tag $tag"
                    mkdir -p $target_dir
                    mv $file "$target_dir/"
                    echo "Moved $file to $target_dir"
                fi
            else
                echo "No type tag found for (path basename $file)"
            fi
    done

    echo "vault restructure complete"
}

###########
# Aliases #
###########

# Obsidian
alias ont new_tech_note
alias onp new_personal_note
alias og move_note_on_type

# other
alias personal bash ~/personal_docs.sh
alias reading bash ~/reading_session.sh
alias notes cd ~/Documents/git/notes
alias o obsidian
