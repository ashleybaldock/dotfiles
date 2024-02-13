#!/opt/homebrew/bin/bash

DIR="$(dirname ${BASH_SOURCE[0]})"
. "$DIR/createFile.sh"

MOVE_M2TS_TO=_m2ts_converted

FFMPEG=/opt/homebrew/bin/ffmpeg
TRASH=/opt/homebrew/bin/trash

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

processFile() {
  local file="$1"
  echo "Processing file '$file'"
  if [ "${file: -5}" == ".m2ts" ]
  then
    cd $(dirname "$file")
      createFile 3 "${file%.m2ts}" ".mp4" || exit
      $FFMPEG -y -i "$file" -vcodec copy -acodec copy -f mp4 "$REPLY" \
        && exec 3>&- && $TRASH "$file"
  else
    echo "Not an .m2ts file, skipping" >&2
  fi
}

for arg in "${args[@]}"
do
  if [ -d "$arg" ]
  then
    echo ""
    echo "Processing directory '$arg'"
    cd $arg
    #mkdir $MOVE_M2TS_TO || true
    for file in *.m2ts
    do
      if [ -f "$file" ]
      then
        echo ""
        processFile "$file"
      fi
    done
  else
    if [ -f "$arg" ]
    then
      echo ""
      processFile "$arg"
    else
      echo "Not a file or directory, skipping" >&2
    fi
  fi
done

        # $FFMPEG -i "$file" -vcodec copy -acodec copy -f mp4 "${file%.m2ts}.mp4" \
          # && $TRASH "$file" # mv "$file" "./$MOVE_M2TS_TO/"

          #\ #&& (mkdir $MOVE_M2TS_TO || true) \
          # \ # && $FFMPEG -i "$file" -vcodec copy -acodec copy -f mp4 "${file%.m2ts}.mp4" \
          # && $TRASH "$file" # mv "$file" "./$MOVE_M2TS_TO/"

