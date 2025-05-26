#!/usr/bin/env bash

# HIGGS=higgs.local
HIGGS=higgs.home

# scp "$HIGGS:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/*" "$HOME/noita/new" &&
# ssh "$HIGGS" " \
#   del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots_animated\*.gif \
# & del AppData\LocalLow\Nolla_Games_Noita\save_rec\screenshots\*.png" || true \
# && noita.sh "$PWD" \
# && mkdir _gifs_converted || true \
# && mv *.gif _gifs_converted/ || true \
# && $HOME/dotfiles/bin/noita-rename-shots.sh "$HOME/noita/new"


# scp "$HIGGS:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/*.{mp4,png}" "$HOME/noita/new" &&

rsync --remove-source-files -av -e ssh "$HIGGS:AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots*/*.{mp4,png}" "$HOME/noita/new" &&
noita-rename-shots.sh


NOITADIR=noita
SCREENSHOTS=AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots
ANIMATED=AppData/LocalLow/Nolla_Games_Noita/save_rec/screenshots_animated

ssh "$HIGGS" "mkdir _transfer_in_progress || echo 'Temp. Transfer directory exists \
  && mv $SCREENSHOTS/*.png $NOITADIR/$TRANSFER/ \
  && mv $ANIMATED/*.mp4 $NOITADIR/$TRANSFER/ \
  " \
  && scp "$HIGGS:$NOITADIR/$TRANSFER/*{.mp4,.png}" "$HOME/noita/new" \
  && ssh "$HIGGS" "


CHOICE /C YNC /M "Press Y for Yes, N for No or C for Cancel." || true if errorlevel 255 (echo Error) else if errorlevel 2 (set "Chose=no") else if errorlevel 1 (set "Chose=yes") else if errorlevel 0 (exit /b) || true && echo %errorlevel%

set EnableDelayedExpansion & CHOICE /C YNC /M "Press Y for Yes, N for No or C for Cancel." & if %errorlevel% EQU 255 (echo Error & exit /b 255) else if %errorlevel% EQU 2 (set "Chose=no") else if %errorlevel% EQU 1 (set "Chose=yes") & echo %Chose% %errorlevel%

