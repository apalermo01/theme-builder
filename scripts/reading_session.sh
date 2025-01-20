#!/bin/bash 

SESSION_NAME="reading"

if tmux has-session -t $SESSION_NAME 2>/dev/null; then
  echo "Session $SESSION_NAME already exists. Attaching to it."
  tmux attach-session -t $SESSION_NAME

else 
  
  tmux new-session -d -s $SESSION_NAME -n notes
  tmux send-keys -t 1 'cd ~/Documents/git/self-study/' C-m 
  tmux send-keys -t 1 nvim C-m 

  tmux new-window -n sioyek
  tmux send-keys -t 2 'cd ~/Documents/library/' C-m 
  tmux send-keys -t 2 sioyek C-m
  tmux select-window -t 1
  tmux attach-session -t $SESSION_NAME
fi
