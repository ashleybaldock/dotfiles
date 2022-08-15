# dotfiles
Super exciting configuration

## install

Clone repo at root of home directory

    cd ~ && git clone https://github.com/ashleybaldock/dotfiles.git

Run platform-specific setup script, e.g. on OSX:

    cd ~/dotfiles && ./macsetup.sh

(This script can be run again later to update everything too, neat!)

[Generate SSH keys for this machine](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

[Add SSH key to ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)

[Add SSH key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

Change dotfiles remote to SSH

    cd ~/dotfiles && git remote set-url origin git@github.com:ashleybaldock/dotfiles.git

Optional: Set user and email for dotfiles repo commits (if different to global default)

    cd ~/dotfiles && git config user.name "[Name]"
    cd ~/dotfiles && git config user.email "[Email]"

## vim maintenance

Vim package management is done via git submodules using the built-in package functionality in Vim 8+. Scripts inspired by [this post](https://shapeshed.com/vim-packages/).

The `macsetup.sh` script updates vim packages via the `update-vim-packages.sh` script, which can be run directly to install/update vim packages.

Add a vim package with: `~/dotfiles/add-vim-package.sh [github-url] [package-name]`, e.g.:

    ~/dotfiles/add-vim-package.sh https://github.com/foo/bar.git vim-foobar

Remove a vim package with: `~/dotfiles/remove-vim-package.sh [package-name]`, e.g.:

    ~/dotfiles/remove-vim-package.sh vim-foobar

These commands create commits to keep track of installed packages. To temporarily disable a package move it from `.vim/pack/default/start` to `.vim/pack/default/opt` (it can then be loaded manually using `:packadd [package-name]`).
