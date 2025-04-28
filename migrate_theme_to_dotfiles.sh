#!/usr/bin/env sh
set -eou pipefail

in_nix_env=false

if [ -n "$IN_NIX_SHELL" ] || [ -n "$DIRENV_DIR" ]; then
    in_nix_env=true
fi

current_shell=$(basename "$SHELL")

if [ "$in_nix_env" = false ] && [ -f "./env/bin/activate" ]; then
    if [ "$current_shell" = "fish" ]; then
        echo "Activating local virtual environment (fish)..."
        source ./env/bin/activate.fish
        activated_env=true
    else
        echo "Activating local virtual environment (bash/zsh)..."
        . ./env/bin/activate
        activated_env=true
    fi
else
    echo "Skipping virtual environment activation."
    activated_env=false
fi


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

if [ "$activated_env" = true ]; then
    deactivate
fi
