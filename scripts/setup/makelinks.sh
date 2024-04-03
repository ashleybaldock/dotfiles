#!/bin/bash

# Run this file from the "dotfiles" directory

cwd=$(pwd)

function link {
  if [ ! -L "$HOME/$1" ]
  then
    if [ -f "$HOME/$1" ]
    then
      if [ -f "$HOME/$1.backup" ]
      then
        echo "! Abort - File '$HOME/$1' already exists, as does '$HOME/$1.backup' - clean up backup file to proceed. " >&2
        exit 1
      fi
      echo   "Warning - File '~/$1' already exists. A backup has been saved to '~/$1.backup'"
      mv "$HOME/$1" "$HOME/$1.backup"
    fi
    echo     " Linked - '~/$1' to '${cwd}/$1'"
    ln -sf "${cwd}/$1" "$HOME/$1"
  else
    echo     "Skipped - '~/$1' is already a link"
  fi
}

link .vimrc
link .gvimrc
link .vim
link .tmux.conf
link .tmux-osx.conf
link .bashrc
link .profile
link .gitignore
link Brewfile
link .config


