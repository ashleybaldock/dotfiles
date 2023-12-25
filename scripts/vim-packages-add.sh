#!/usr/bin/env bash

# Run this file from the "dotfiles" directory

# First argument is url, e.g. https://github.com/foo/vim-package.git
# Second argument is package name, e.g. vim-package
# (Optional) Third argument is a specific branch (e.g. release) to track

__usage="
Usage: $(basename $0) [options] <repo-url> <package-name> [<branch>]

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

cwd=$(pwd)

git submodule init
if [ "$3" != "" ]; then
  git submodule add -b "$3" "$1" ".vim/pack/default/start/$2"
# Changing existing submodule's branch:
##   git submodule set-branch --branch release -- .vim/pack/default/start/$2
else
  git submodule add "$1" ".vim/pack/default/start/$2"
fi
git add .gitmodules ".vim/pack/default/start/$2"
git commit -m"Add vim package '$2'"
