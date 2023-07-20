#!/usr/bin/env bash

# e.g.
# HANDBRAKE_CLI=$HOME/bin/HandBrakeCLI
HANDBRAKE_CLI=$HOME/dotfiles/bin/HandBrakeCLI

# e.g.
# PRESET_FILE=$HOME/NoitaCap720p30.json
PRESET_FILE=$HOME/dotfiles/NoitaCap720p30.json

args=$@

if [ $# -eq 0 ]
then
  args=$PWD
fi

for arg in "$args"
do
  echo "Processing argument '$arg'"
  if [ -d "$arg" ]
  then
    cd $arg
    for gif in *.gif
    do
      if [ -f "$gif" ]
      then
        $HANDBRAKE_CLI --preset-import-file $PRESET_FILE --crop 0:0:0:0 -i "$gif" -o "${gif%.gif}.mp4"
      fi
    done
  else
    if [ -f "$arg" ]
    then
      if [ "${arg: -4}" == ".gif" ]
      then
        gif=$arg
        $HANDBRAKE_CLI --preset-import-file $PRESET_FILE --crop 0:0:0:0 -i "$gif" -o "${gif%.gif}.mp4"
      fi
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done


