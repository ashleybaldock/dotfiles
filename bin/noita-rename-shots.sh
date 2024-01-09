#!/usr/bin/env bash

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
    echo ""
    cd $arg
    for file in shot_*.png
    do
      if [ -f "$file" ]
      then
        echo "'${file:: 14}(...).png' >> 'noita-${file:5:9}(...).png'"
        mv "$file" "${file/shot_/noita-}"
      fi
    done
  fi
done

