#!/opt/homebrew/bin/bash

args=("$@")

if [ $# -eq 0 ]
then
  echo "Specify a file" >&2
  exit 1
fi

sips -j "$HOME/dotfiles/bin/imgscale.js" $args
