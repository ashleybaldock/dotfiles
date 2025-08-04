#!/opt/homebrew/bin/bash

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/createFile.sh"

echo "" >&2
echo "" >&2
echo "imgurls-to-css start" >&2

args=("$PWD")
out="progress.css"

touch "$out"

for file in *.svg
do
  if [ -d "$file" ]
  then
    echo "" >&2
    echo "Skipping subdirectory '$file'" >&2
  else
    if [ -f "$file" -a "${file: -4}" == ".svg" ]
    then
      imgurl.sh "$file" >> "$out"
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done

