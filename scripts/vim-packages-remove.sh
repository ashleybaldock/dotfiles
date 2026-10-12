#!/usr/bin/env bash

GITROOT="$HOME/dotfiles"
VIMDIR="$GITROOT/.vim"
GITDIR="$GITROOT/.git"

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


packname="$1"
packpath=".vim/pack/default/start/$packname"
packpathopt=".vim/pack/default/opt/$packname"
modulepath="$GITDIR/modules/$packpath"
modulepathopt="$GITDIR/modules/$packpathopt"

cwd=$(pwd)

if [ ! -d "$GITROOT" ]
then
  echo "Failed to find '$GITROOT'" >&2
  exit 1
fi

cd $GITROOT

if [ ! -d "$packpath" ]
then
  echo "Failed to find package directory '$packpath'" >&2
  exit 1
fi

# git diff --cached --quiet && echo "git has staged changes, commit or stash them first" >&2 && exit 1

git submodule deinit "$packpath"

git rm "$packpath"

rm -Rf "$modulepath"

git commit -m"Remove vim package '$packname'"
