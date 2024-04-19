#!/bin/bash

echo "-- Setting up SSH..."
mkdir "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
(
  umask 077
  touch "$HOME/.ssh/authorized_keys"
  touch "$HOME/.ssh/config"
  touch "$HOME/.ssh/environment"
  touch "$HOME/.ssh/known_hosts"
)
echo ""

echo "-- Making links..."
(
  cd "$HOME/dotfiles"
  "$HOME/dotfiles/scripts/setup/makelinks.sh"
)
echo ""

echo "-- Installing/updating brew..."
which -s brew
[ $? != 0 ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew bundle --file "$HOME/Brewfile"
# defaults write org.n8gray.QLColorCode hlTheme Zenburn
# xattr -d -r com.apple.quarantine $HOME/Library/QuickLook
echo ""

echo "-- Installing/updating nvm..."
export NVM_DIR="$HOME/.nvm" && (
  [ ! -d "$NVM_DIR" ] && git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git fetch --tags origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
)
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
echo ""

echo "-- Installing/updating vim packages"
(
  cd "$HOME/dotfiles"
  "$HOME/dotfiles/scripts/update-vim-packages.sh"
)
echo ""
echo "-- Setting up macvim"
(
  cd "$HOME/dotfiles"
  "$HOME/dotfiles/scripts/macvim-write-defaults.sh"
)
echo ""

echo "-- Finishing..."
(
  cd "$HOME/dotfiles"
  "$HOME/dotfiles/scripts/git-setup.sh"
)
echo ""


# mdls -name kMDItemContentType /full/path/to/file.ts
# mdls -name kMDItemContentType /full/path/to/file.tsx
# mdls -name kMDItemContentType /full/path/to/file.json
# Copy the file types into the LSItemContentTypes array in
# ~/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist
# Finally, reboot Quicklook by moving QLColorCode.qlgenerator out of ~/Library/QuickLook/, then moving it back.
# defaults write org.n8gray.QLColorCode hlTheme Zenburn
# xattr -d -r com.apple.quarantine ~/Library/QuickLook
