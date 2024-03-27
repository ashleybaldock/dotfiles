#!/bin/bash

VIMDIR="$HOME/dotfiles/.vim"
GITDIR="$HOME/dotfiles/.git"

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

if [ ! -d "$VIMDIR" ]
then
  echo "Failed to find VIMDIR '($VIMDIR)', aborting" >&2
  exit 1
fi

git diff --cached --quiet || echo "Git has staged changes, commit or stash them first" >&2 || exit 1

git submodule deinit "$VIMDIR/pack/default/start/$1" || echo "submodule deinit failed" >&2 || exit 1
git rm "$VIMDIR/pack/default/start/$1" || echo "git rm failed" >&2 || exit 1
rm -Rf "$GITDIR/modules/.vim/pack/default/start/$1" || exit 1
git commit -m"Remove vim package '$1'" || exit 1
