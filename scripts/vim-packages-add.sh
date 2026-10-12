#!/usr/bin/env bash

GITROOT="$HOME/dotfiles"
VIMDIR="$GITROOT/.vim"

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

repourl="$1"
packname="$2"
branch="$3"
packpath=".vim/pack/default/start/$packname"
packpathopt=".vim/pack/default/opt/$packname"

cwd=$(pwd)

if [ ! -d "$GITROOT" ]
then
  echo "Failed to find '$GITROOT'" >&2
  exit 1
fi

cd $GITROOT

git diff --cached --quiet || echo "git has staged changes, commit or stash them first" >&2 && exit 1

git submodule init || echo "git submodule init failed" >&2 && exit 1

if [ "$branch" != "" ]; then
  git submodule add -b "$branch" "$repourl" "$packpath" || echo "git submodule add failed" >&2 && exit 1
# Changing existing submodule's branch:
##   git submodule set-branch --branch release -- "$VIMDIR/pack/default/start/$2"
else
  git submodule add "$repourl" "$packpath" || echo "git submodule add failed" >&2 && exit 1
fi

git config -f .gitmodules "submodule.$packpath.ignore untracked"

git add .gitmodules "$packpath" || echo "git add .gitmodules failed" >&2 && exit 1

git commit -m"Add vim package '$packname'"
