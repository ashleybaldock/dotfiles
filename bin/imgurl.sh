#!/opt/homebrew/bin/bash

args=("$@")

if [ $# -eq 0 ]
then
  echo "Specify a file" >&2
  exit 1
fi

if [ -z "$NVM_DIR" ]; then
  export NVM_DIR="$HOME/.nvm"
fi
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
echo "NVM_DIR: $NVM_DIR"
echo "NVM_BIN: $NVM_BIN"
echo "PATH: $PATH"

ENCODESVG="$HOME/dotfiles/bin/encodeSVG.js"
PNGOUT="/opt/homebrew/bin/pngout"
SVGO="$HOME/.nvm/versions/node/v18.19.0/bin/svgo"

# TODO multiple inputs: accumulate and copy together
# TODO input directories too
# TODO configurable option for optimise/copy etc.

optimise=1
alwaysbase64=0
copy=1

if [ $# -gt 1 ]
then
  echo "Multiple inputs, will skip copy" >&2
  copy=0
fi

for arg in "${args[@]}"
do
  detectedtype=unknown
  # the output encoding used within the data url
  # 'auto' - base64 (with exceptions: svg uses minimal encoding)
  # 'b64' - base64
  encoding=auto
  # encoding used
  usedencoding=
  # name to use for generating CSS variable
  name=
  # resulting dataurl
  dataurl=

  if [ -f "$arg" ]
  then
    file=$( tr '[:upper:]' '[:lower:]' <<<"$arg" )
    filename=$(basename "$file")

    name=${filename%.*}

    ## input type: PNG
    if [ "${file: -4}" == ".png" ]
    then
      detectedtype=png
      # base64="$(base64 -i "$arg" -o -)"
      echo "pngout:" >&2
      base64="$("$PNGOUT" "$arg" - 2> >(sed 's/^/pngout: /' >&2) | base64 -i - -o -)"
      echo "" >&2
      dataurl="url('data:image/png;base64,$base64')"
      usedencoding="b64"

    ## input type: GIF
    elif [ "${file: -4}" == ".gif" ]
    then
      detectedtype=gif
      # TODO optimise gifs
      base64="$(base64 -i "$arg" -o -)"
      dataurl="url('data:image/gif;base64,$base64')"
      usedencoding="b64"

    elif [ "${file: -4}" == ".jpg" -o "${file: -5}" == ".jpeg" ]
    then
      detectedtype=jpeg
      # TODO optimise jpegs
      base64="$(base64 -i "$arg" -o -)"
      dataurl="url('data:image/jpeg;base64,$base64')"
      usedencoding="b64"

    ## input type: SVG
    elif [ "${file: -4}" == ".svg" ]
    then
      detectedtype=svg
      echo "svgo:" >&2
      optimised="$(cat "$arg" | "$SVGO" -q -i - -o - 2> >(sed 's/^/svgo: /' >&2))"
      echo "" >&2
      if [ "$encoding" == "b64" ]
      then
        base64data="$(echo "$optimised" | base64 -i - -o -)"
        dataurl="url('data:image/svg+xml;base64,$base64data')"
        usedencoding="b64"
      else
        dataurl="$(echo "$optimised" | $ENCODESVG)"
        usedencoding="svgmin"
      fi

    ## input type: TTF
    elif [ "${file: -4}" == ".ttf" ]
    then
      detectedtype=ttf
      base64="$(base64 -i "$arg" -o -)"
      dataurl="url('data:font/truetype;charset=utf-8;base64,$base64')"
      usedencoding="b64"
    fi

    cssvar="--fontdata-${name//_/-}: $dataurl;"

    if [ "$detectedtype" == "unknown" ]
    then
      echo "Unknown file type for input "$arg"" >&2
    else
      optcopy=""
      if [ $copy -eq 0 ]
      then
        echo -n "$cssvar"
        echo ''
      else
        echo -n "$cssvar" | tee >(pbcopy)
        echo ''
        if [ $? -eq 0 ]
        then
          echo "copied dataurl to clipboard" >&2
        else
          echo "copy command failed ($?)" >&2
        fi
        optcopy=",copy"
      fi

      optencoding="encoding=$encoding"
      optoptimise=",optimise"
      cssvar=",cssvar"
      echo "in:$detectedtype options:$optencoding$optoptimise$cssvar out:$detectedtype,stdout$optcopy" >&2
    fi

  else
    detectedtype="not a file"
    echo "Not a file, skipping" >&2
  fi
done


# gen-delims  = " : / ? # [ ] @ "
# sub-delims  = " ! $ & ' ( ) /  * + , ; = "

