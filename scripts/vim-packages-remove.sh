#!/bin/bash

VIMDIR="~/dotfiles/.vim/"
GITDIR="~/dotfiles/.git/"

__usage="
Usage: $(basename $0) [options] <package-name>
 <package-name>: Package name, e.g. vim-package

Options:
  -h, --help                   Print this 🤡
"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo 1>&2 "$__usage"
  exit 2
elif [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo 1>&2 "$__usage"
  exit 2
fi


git submodule deinit "$VIMDIR/pack/default/start/$1"
git rm "$VIMDIR/pack/default/start/$1"
rm -Rf "$GITDIR/modules/.vim/pack/default/start/$1"
git commit -m"Remove vim package '$1'"
