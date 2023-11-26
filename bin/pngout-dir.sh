#!/usr/bin/env bash

for file in *.png
do
    if [ -f "$file" ]
    then
      pngout "$file"
    fi
done
