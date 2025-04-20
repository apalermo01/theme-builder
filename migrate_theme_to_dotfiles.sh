#!/bin/bash

source $(pwd)/env/bin/activate 

if [[ $1 == "all" ]]; then
    for theme in $(ls ./themes/ | grep "^[i3|wsl].*"); do
        echo "building and migrating $theme"
        python main.py --theme $theme \
                       --no-test \
                       --migration-method dotfiles \
                       --dotfiles-path $HOME/Documents/git/dotfiles/themes \
                       --destination-structure config
    done
else

    python main.py --theme $1 \
                   --no-test \
                   --migration-method dotfiles \
                   --dotfiles-path $HOME/Documents/git/dotfiles/themes \
                   --destination-structure config
fi
deactivate
