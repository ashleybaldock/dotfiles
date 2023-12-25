#!/bin/bash

# Run this file from the "dotfiles" directory

cwd=$(pwd)

git submodule init
git submodule update --remote --merge
git add .vim/pack
git commit -m'Updated vim packages'
