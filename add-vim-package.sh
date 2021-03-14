#!/bin/bash

# Run this file from the "dotfiles" directory

# First argument is url, e.g. https://github.com/foo/vim-package.git
# Second argument is package name, e.g. vim-package

cwd=$(pwd)

git submodule init
git submodule add $1 .vim/pack/default/start/$2
git add .gitmodules .vim/pack/default/start/$2
git commit -m"Add vim package '$2'"
