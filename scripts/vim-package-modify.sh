#!/usr/bin/env bash

# Run this file from the "dotfiles" directory

# First argument is package name, e.g. vim-package
# Second argument 
#
# vim-pack add      <package_name> <repo_url> [<branch>]
# vim-pack addopt   <package_name> <repo_url> [<branch>]
# vim-pack remove   <package_name> 
# vim-pack option   <package_name> 
# vim-pack startup  <package_name> 
# vim-pack remove   <package_name> 
# vim-pack track    <package-name> <branch_to_track>
# vim-pack list    [<package-name>]
# vim-pack update  [<package-name>]

__usage="
Usage: $(basename $0) [options] <package-name> modify [<start|opt>]

Options:
  -h, --help          Print this 🤡
  -p, --prefix        Package directory prefix, i.e.: 
                        \".vim/pack/<prefix>/[<start|opt>]/<packagename>\"
                      Can also be set with \$VIM_PACK_PREFIX
                      Defaults to a default of 'default'
"

PREFIX="${VIM_PACK_PREFIX:-default}"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo 1>&2 "$__usage"
  exit 2
elif [ $# -lt 2 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo 1>&2 "$__usage"
  exit 2
fi

cwd=$(pwd)

if [ -d ".vim/pack/$PREFIX/start/$2" && ! -d ".vim/pack/$PREFIX/opt/$2" ]; then 
  git mv ".vim/pack/$PREFIX/start/$2" ".vim/pack/$PREFIX/opt/$2" 
  git commit -m"vim package '$2' start->opt"
else

fi

if [ -d ".vim/pack/$PREFIX/opt/$2" && ! -d ".vim/pack/$PREFIX/start/$2" ]; then 
  git mv ".vim/pack/$PREFIX/opt/$2" ".vim/pack/$PREFIX/start/$2" 
  git commit -m"vim package '$2' opt->start"
else

fi
