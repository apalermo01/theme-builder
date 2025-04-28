# references:
# https://www.youtube.com/watch?v=ud7YxC33Z3w
#########
# zinit #
#########

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# global plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# load autocompletions
autoload -U compinit && compinit

zinit cdreplay -q

###########
# General #
###########

export MANPAGER="nvim +Man!"

function quick_commit() {
    today=$(date "+%Y-%m-%d")
    git add . && git commit -m "$today"
}

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# keybindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

######################
# Obsidian Functions #
######################

export NOTES_PATH="/home/alex/Documents/git/notes"

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
alias ont='new_tech_note'
alias onp='new_personal_note'
alias og='move_note_on_type'

# other
alias personal='bash ~/personal_docs.sh'
alias reading='bash ~/reading_session.sh'
alias notes='cd ~/Documents/git/notes'
alias o='obsidian'
alias ls='ls --color'

alias vim='nvim'
alias vi='nvim'
alias nivm='nvim'

# git aliases 
alias g='git'
alias ga='git add -p'
alias gc='git commit -p'
alias gb='git branch'
alias gp='git push'

#######################
# Additional settings #
#######################




