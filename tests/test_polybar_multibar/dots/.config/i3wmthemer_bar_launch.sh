#!/bin/env sh
polybar-msg cmd quit
killall -q polybar 

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# DO NOT DELETE THIS
# Parser for polybar DEPENDs on this line
declare -a bar_names=( "left" "center" "right")

if [ -z "$(pgrep -x polybar)" ]; then
  for b in "${bar_names[@]}"; do
    for m in $(polybar --list-monitors | cut -d":" -f1); do
        MONITOR=$m polybar --reload "$b" --config=~/.config/polybar/config.ini &
        sleep 1
    done
  done
else
    polybar-msg cmd restart
fi

echo "Bars launched..."
