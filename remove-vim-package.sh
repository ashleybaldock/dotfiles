#!/bin/bash

# Run this file from the "dotfiles" directory

# First argument is package name, e.g. vim-package

cwd=$(pwd)

git submodule deinit .vim/pack/default/start/$1
git rm .vim/pack/default/start/$1
rm -Rf .git/modules/.vim/pack/default/start/$1
git commit -m"Remove vim package '$1'"
