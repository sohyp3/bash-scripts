#/bin/bash

SESSION_NAME="sig"

# Check if session exists
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
  echo "Session $SESSION_NAME already exists. Attaching..."
  tmux attach -t $SESSION_NAME
  exit 0
fi

# Session does not exist, create it
echo "Creating new tmux session: $SESSION_NAME"

# cd /home/cofi/Documents/projects/python/SigmaAccounting
# source env/bin/activate
# cd Sigma
#
# code .

# Start tmux session
tmux new-session -d -s $SESSION_NAME

# Window 1: nvim
tmux rename-window -t $SESSION_NAME:0 'vi'
tmux send-keys -t $SESSION_NAME:vi 'nvim .' C-m

# Window 2: terminal for 'run'
tmux new-window -t $SESSION_NAME -n 'ter'
tmux send-keys -t $SESSION_NAME:ter 'run' C-m

# Window 3: tailwind
tmux new-window -t $SESSION_NAME -n 'tw'
tmux send-keys -t $SESSION_NAME:tw 'cd contracts/static/css' C-m
tmux send-keys -t $SESSION_NAME:tw 'npx tailwindcss -i tailwind.css -o tw.css --watch' C-m

# Select the 'vi' window on attach
tmux select-window -t $SESSION_NAME:vi

# Attach to the session
tmux attach -t $SESSION_NAME
