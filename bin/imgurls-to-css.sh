#!/opt/homebrew/bin/bash

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/createFile.sh"

echo ""
echo ""
echo "imgurls-to-css start"

args=("$PWD")
out="progress.css"

touch "$out"

for file in *.svg
do
  if [ -d "$file" ]
  then
    echo ""
    echo "Skipping subdirectory '$file'"
  else
    if [ -f "$file" -a "${file: -4}" == ".svg" ]
    then
      imgurl.sh "$file" >> "$out"
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done

