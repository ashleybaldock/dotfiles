#!/bin/bash

echo "Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle --global

# mdls -name kMDItemContentType /full/path/to/file.ts
# mdls -name kMDItemContentType /full/path/to/file.tsx
# mdls -name kMDItemContentType /full/path/to/file.json
# Copy the file types into the LSItemContentTypes array in
# ~/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist
# Finally, reboot Quicklook by moving QLColorCode.qlgenerator out of ~/Library/QuickLook/, then moving it back.
# defaults write org.n8gray.QLColorCode hlTheme Zenburn
# xattr -d -r com.apple.quarantine ~/Library/QuickLook
