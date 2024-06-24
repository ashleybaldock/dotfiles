#!/usr/bin/env bash

VIMDIR="$HOME/dotfiles/.vim"

__usage="
Usage: $(basename $0) [options] <repo-url> <package-name> [<branch>]
     <repo-url>: Github URL, e.g. https://github.com/foo/vim-package.git
 <package-name>: Package name, e.g. vim-package
     [<branch>]: Track a specific branch (e.g. release)

Options:
  -h, --help                   Print this 🤡
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

cwd=$(pwd)

cd $VIMDIR

git diff --cached --quiet || echo "Git has staged changes, commit or stash them first" >&2 && exit 1

git submodule init || echo "Git submodule init failed" >&2 && exit 1

if [ "$3" != "" ]; then
  git submodule add -b "$3" "$1" ".vim/pack/default/start/$2"
# Changing existing submodule's branch:
##   git submodule set-branch --branch release -- "$VIMDIR/pack/default/start/$2"
else
  git submodule add "$1" ".vim/pack/default/start/$2"
fi

git add .gitmodules ".vim/pack/default/start/$2" || echo "git add .gitmodules failed" >&2 && exit 1

git commit -m"Add vim package '$2'"
