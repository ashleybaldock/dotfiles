#!/usr/bin/env bash

# e.g.
# HANDBRAKE_CLI=$HOME/bin/HandBrakeCLI
HANDBRAKE_CLI=$HOME/dotfiles/bin/HandBrakeCLI

# e.g.
# PRESET_FILE=$HOME/NoitaCap720p30.json
PRESET_FILE=$HOME/dotfiles/NoitaCap720p30.json

args=("$@")

if [ $# -eq 0 ]
then
  args=("$PWD")
fi

for arg in "${args[@]}"
do
  if [ -d "$arg" ]
  then
    echo ""
    echo "Processing directory '$arg'"
    cd $arg
    for file in *.gif
    do
      if [ -f "$file" ]
      then
        echo ""
        echo "Processing file '$file'"
        $HANDBRAKE_CLI --preset-import-file $PRESET_FILE --crop 0:0:0:0 -i "$file" -o "${file%.gif}.mp4"
      fi
    done
  else
    if [ -f "$arg" ]
    then
      file="$arg"
      echo ""
      echo "Processing file '$file'"
      if [ "${file: -4}" == ".gif" ]
      then
        $HANDBRAKE_CLI --preset-import-file $PRESET_FILE --crop 0:0:0:0 -i "$file" -o "${file%.gif}.mp4"
      else
        echo "Not a .gif file, skipping" >&2
      fi
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done


