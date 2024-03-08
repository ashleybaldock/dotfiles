#!/usr/bin/env bash
#
scp higgs.local:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/* $HOME/noita/new &&
ssh higgs.local "del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots_animated\*.gif & del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots\*.png" || true && noita.sh "$PWD" && mkdir _gifs_converted || true && mv *.gif _gifs_converted/ || true && $HOME/dotfiles/bin/noita-rename-shots.sh "$HOME/noita/new"
