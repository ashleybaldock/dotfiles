#!/bin/bash

# Run this file from the "dotfiles" directory

cwd=$(pwd)

AUTO=$1

function link {
  if [ ! -L ~/$1 ]
  then
    if [ -f ~/$1 ]
    then
      if [ -f ~/$1.backup ]
      then
        echo "~/$1 already exists, as does ~/$1.backup - aborting"
        exit 1
      fi
      echo "~/$1 already exists, backing up to ~/$1.backup"
      mv ~/$1 ~/$1.backup
    fi
    echo "Linking ~/$1 to ${cwd}/$1"
    ln -sf ${cwd}/$1 ~/$1
  else
    echo "~/$1 is already a link, skipping"
  fi
}

function linkyn {
  if [ ! -z "$AUTO" ]
  then
    echo "Link .profile? (Probably mac-specific)"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) link $1; break;;
        No ) break;;
      esac
    done
  fi
}

link .vimrc
link .vim
link .tmux.conf
link .tmux-osx.conf
link .bashrc
link .gitignore
git config --global core.excludesfile ~/.gitignore
link Brewfile

# Skip these if first arg set, e.g. automatic mode
if [ -z "$1" ]
then
  linkyn .profile
fi


