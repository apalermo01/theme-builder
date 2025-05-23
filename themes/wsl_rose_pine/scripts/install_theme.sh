#!/usr/bin/env bash

if [[ -d ~/.tmux/plugins/tmux ]]; then
    echo "removing ~/.tmux/plugins/tmux"
    sudo rm -rn ~/.tmux/plugins/tmux
fi
