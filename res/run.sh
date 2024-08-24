#!/usr/bin/env bash

PORT=3333

if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; then
  tmux select-pane -T "serve localhost:$PORT"
fi

source "$NVM_DIR/nvm.sh"
nvm use
npx serve -p "$PORT"
