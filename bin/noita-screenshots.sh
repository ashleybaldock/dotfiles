#!/usr/bin/env bash

# HIGGS=higgs.local
HIGGS=higgs.home

# scp "$HIGGS:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/*" "$HOME/noita/new" &&
# ssh "$HIGGS" "del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots_animated\*.gif & del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots\*.png" || true && noita.sh "$PWD" && mkdir _gifs_converted || true && mv *.gif _gifs_converted/ || true && $HOME/dotfiles/bin/noita-rename-shots.sh "$HOME/noita/new"


# scp "$HIGGS:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/*.{mp4,png}" "$HOME/noita/new" &&

rsync --remove-source-files -av -e ssh "$HIGGS:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/*.{mp4,png}" "$HOME/noita/new" &&
noita-rename-shots.sh
