# dotfiles
Super exciting configuration

## install

Check the repo out at your homedir root.
Run `makelinks.sh` inside the `dotfiles` directory.
Some links are optional (typically things that are only needed on OSX e.g. `.profile`). Auto-skip these by setting an argument e.g. `makelinks.sh auto`.

## vim install

After `git clone` run `git submodule update --recursive` to set up vim packages installed with the `add-vim-package.sh` script.
Use `add-vim-package.sh`, `remove-vim-package.sh` and `update-vim-packages.sh` to manage vim packages (using the built in package functionality).

Vim package management scripts inspired by [this post](https://shapeshed.com/vim-packages/).
