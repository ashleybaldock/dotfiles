#!/usr/bin/env bash

MOVE_M2TS_TO=_m2ts_converted

FFMPEG=/opt/homebrew/bin/ffmpeg

args=("$@")

echo ""
echo ""
echo "m2ts-to-mp4 start; \$@:"
for an_arg in "$@" ; do
   echo "  '${an_arg}'"
done

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
    mkdir $MOVE_M2TS_TO || true
    for file in *.m2ts
    do
      if [ -f "$file" ]
      then
        echo ""
        echo "Processing file '$file'"
        $FFMPEG -i "$file" -vcodec copy -acodec copy -f mp4 "${file%.m2ts}.mp4" \
          && mv "$file" "./$MOVE_M2TS_TO/"
      fi
    done
  else
    if [ -f "$arg" ]
    then
      file="$arg"
      echo ""
      echo "Processing file '$file'"
      if [ "${file: -5}" == ".m2ts" ]
      then
        cd $(dirname "$file") \
          && (mkdir $MOVE_M2TS_TO || true) \
          && $FFMPEG -i "$file" -vcodec copy -acodec copy -f mp4 "${file%.m2ts}.mp4" \
          && mv "$file" "./$MOVE_M2TS_TO/"
      else
        echo "Not an .m2ts file, skipping" >&2
      fi
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done


