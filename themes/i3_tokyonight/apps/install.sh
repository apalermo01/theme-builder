#!/usr/bin/env bash 

url="https://raw.githubusercontent.com/nonetrix/tokyonight-kde/1e6d8a4e515be9f80959e0a7500bf1aede256dd7/TokyoNight.colors"
dest="$HOME/.local/share/color-schemes/TokyoNight.colors"
echo "$(curl -L $url)" > $dest
