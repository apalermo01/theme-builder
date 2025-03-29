#!/bin/bash

# Find all theme directories under ./themes/ that contain 'i3' in the name
themes=($(find ./themes -maxdepth 1 -type d -name '*i3*' -printf "%f\n"))

# Check if any matching themes were found
if [ ${#themes[@]} -eq 0 ]; then
  echo "No themes with 'i3' found in ./themes/"
  exit 1
fi

# Pick a random theme
random_theme=${themes[RANDOM % ${#themes[@]}]}
source $(pwd)/env/bin/activate 

read -p "Selected random theme: $random_theme. Continue (A backup will NOT be made) (y/n)?" choice
case "$choice" in
    y|Y) ;;
    *) exit 1;;
esac

python main.py --theme $random_theme \
               --no-test \
               --no-make-backup \
               --migration-method copy \
               --destination-root $HOME \
               --destination-structure config

deactivate
