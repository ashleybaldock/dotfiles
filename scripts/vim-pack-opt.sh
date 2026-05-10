#!/usr/bin/env bash

VIMDIR="$HOME/dotfiles/.vim"

__usage="
Make <plugin> not load at start.

Usage:

    vim-pack opt <plugin>
"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo 1>&2 "$__usage"
  exit 2
elif [ $# -lt 2 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo 1>&2 "$__usage"
  exit 2
fi

if [ ! -d "$VIMDIR" ]
then
  echo "Failed to find VIMDIR '($VIMDIR)', aborting" >&2
  exit 1
fi

CWD=$(pwd)

cd $VIMDIR

git diff --cached --quiet || echo "Git has staged changes, commit or stash them first" >&2 && exit 1

git submodule init || echo "Git submodule init failed" >&2 && exit 1

PACKAGE="${2}"
PLUGIN="${3}"

OPT="$VIMDIR/pack/$PLUGIN/opt/$PLUGIN"
START="$VIMDIR/pack/$PLUGIN/start/$PLUGIN"

if [ -d "$START" ]; then 
  if [ -d "$OPT" ]; then 
    echo 1>&2 "Plugin '$PLUGIN' found in both start/ and opt/"
  else
    git mv "$START" "$OPT" 
    git commit -m"vim plugin '$PLUGIN' start->opt"
  fi
else
  if [ -d "$OPT" ]; then 
    echo 1>&2 "Plugin '$PLUGIN' is already optional"
  else
    echo 1>&2 "Plugin '$PLUGIN' not found"
  fi
fi

cd $CWD

