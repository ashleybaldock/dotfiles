#!/usr/bin/env bash

VIMDIR="$HOME/dotfiles/.vim"

if [ ! -d "$VIMDIR" ]
then
  echo "Failed to find VIMDIR '($VIMDIR)', aborting" >&2
  exit 1
fi

cwd=$(pwd)

git submodule init
git submodule update --remote --merge
git add .vim/pack
git commit -m'Updated vim packages'

printf "\n"

cd "$cwd"
exit 0
