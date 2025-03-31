#!/bin/bash

source $(pwd)/env/bin/activate 

python main.py --theme $1 \
               --no-test \
               --migration-method dotfiles \
               --dotfiles-path $HOME/Documents/git/dotfiles \
               --destination-structure config

deactivate
