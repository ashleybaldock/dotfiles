#!/usr/bin/env bash
#
scp higgs:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/* $HOME/noita/new &&
ssh higgs "del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots_animated\*.gif & del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots\*.png" && noita.sh "$PWD" && mkdir _gifs_converted || true && mv *.gif _gifs_converted/
