#!/bin/bash
#
# Using the vim-packages-* scripts now
#

mkdir ~/.vim

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle

git clone https://github.com/mileszs/ack.vim.git
git clone https://github.com/w0rp/ale.git
git clone https://github.com/ctrlpvim/ctrlp.vim.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone https://github.com/rodnaph/vim-color-schemes.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-dispatch.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/pangloss/vim-javascript.git
git clone https://github.com/mxw/vim-jsx.git
git clone https://github.com/prettier/vim-prettier.git
git clone https://github.com/romainl/vim-qf.git
git clone https://github.com/christoomey/vim-tmux-navigator.git
git clone https://github.com/ianks/vim-tsx.git

git clone https://github.com/Valloric/YouCompleteMe.git
cd ./YouCompleteMe
git submodule update --init --recursive
brew install cmake
./install.py --ts-completer #--clang-completer --cs-completer
npm install -g typescript
cd third_party/ycmd/ && npm install -g --prefix third_party/tsserver typescript

npm install -g prettier

cd ~/.vim/bundle

