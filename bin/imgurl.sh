#!/opt/homebrew/bin/bash

args=("$@")

if [ $# -eq 0 ]
then
  echo "Specify a file" >&2
  exit 1
fi

# gen-delims  = " : / ? # [ ] @ "
# sub-delims  = " ! $ & ' ( ) /  * + , ; = "

for arg in "${args[@]}"
do
  if [ -f "$arg" ]
  then
    file=$( tr '[:upper:]' '[:lower:]' <<<"$arg" )
    if [ "${file: -4}" == ".png" ]
    then
      base64="$(pngout "$arg" - | base64 -i - -o -)"
      echo "b64(png): (+copied to clipboard)" >&2
      echo "url('data:image/png;base64,$base64');"
      echo "url('data:image/png;base64,$base64');" | pbcopy
    elif [ "${file: -4}" == ".gif" ]
    then
      base64="$(base64 -i "$arg" -o -)"
      echo "b64(gif): (+copied to clipboard)" >&2
      echo "url('data:image/gif;base64,$base64');"
      echo "url('data:image/gif;base64,$base64');" | pbcopy
    elif [ "${file: -4}" == ".jpg" || "${file: -5}" == ".jpeg" ]
    then
      base64="$(base64 -i "$arg" -o -)"
      echo "b64(jpeg): (+copied to clipboard)" >&2
      echo "url('data:image/jpeg;base64,$base64');"
      echo "url('data:image/jpeg;base64,$base64');" | pbcopy
    elif [ "${file: -4}" == ".svg" ]
    then
      echo "url(svg): (+copied to clipboard)" >&2
      echo "url('data:image/svg+xml;base64,$base64');"
      echo "url('data:image/png;base64,$base64');" | pbcopy
    else
      echo "Unknown file type for file "$arg"" >&2
    fi
  else
    echo "Not a file, skipping" >&2
  fi
done




