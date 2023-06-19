#!/usr/bin/env bash

for arg in "$@"
do
  echo "Processing argument '$arg'"
  if [ -d "$arg" ]
  then
    cd $arg
    for gif in *.gif
    do
      if [ -f "$gif" ]
      then
        ~/dotfiles/bin/HandBrakeCLI  --preset-import-file $HOME/dotfiles/NoitaCap720p30.json --crop 0:0:0:0 -i "$gif" -o "${gif%.gif}.mp4"
      fi
    done
  else
    if [ -f "$arg" ]
    then
      if [ "${arg: -4}" == ".gif" ]
      then
        gif=$arg
        ~/dotfiles/bin/HandBrakeCLI  --preset-import-file $HOME/dotfiles/NoitaCap720p30.json --crop 0:0:0:0 -i "$gif" -o "${gif%.gif}.mp4"
      fi
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done

