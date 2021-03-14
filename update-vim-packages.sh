#!/bin/bash

# Run this file from the "dotfiles" directory

cwd=$(pwd)

git submodule update --remote --merge
git commit -m'Update vim packages'
