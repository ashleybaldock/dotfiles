#!/opt/homebrew/bin/bash

args=("$@")

if [ $# -eq 0 ]
then
  echo "Specify a png file" >&2
  exit 1
fi

for arg in "${args[@]}"
do
  if [ -f "$arg" ]
  then
    base64="$(pngout "$arg" - | base64 -i - -o -)"
    echo "b64: (copied to clipboard)" >&2
    echo "url('data:image/png;base64,$base64');"
    echo "url('data:image/png;base64,$base64');" | pbcopy
  else
    echo "Not a file, skipping" >&2
  fi
done
