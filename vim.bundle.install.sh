#!/bin/sh

mkdir ~/.vim
mkdir ~/.vim/bundle
cd ~/.vim/bundle

git clone https://github.com/w0rp/ale.git
git clone https://github.com/ctrlpvim/ctrlp.vim.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/Valloric/YouCompleteMe.git
