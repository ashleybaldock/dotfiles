#!/bin/bash

VIMDIR="$HOME/dotfiles/.vim"

if [ ! -d "$VIMDIR" ]
then
  echo "Failed to find VIMDIR '($VIMDIR)', aborting" >&2
  exit 1
fi

cwd=$(pwd)

cd "$VIMDIR/pack/default/start/"

# ls -Gd */

# ls -Gd1 */

# submoduleinfo=$(git submodule status)

# while IFS=$'\t' read -r c1 c2 c3; do
#     tput setaf 2; printf '%-30s' "$c2"
#     tput setaf 3; printf '%-30s' "$c3"
#     tput sgr0; echo
# done < "$(git submodule status)" 2>&1

# awk '{printf "\033[1;32m%s\t\033[00m\033[1;33m%s\t\033[00m\033[1;34m%s\033[00m\n", $1, $2, $3;}' a.txt 

cd "$VIMDIR/pack/"

git submodule status 2>&1 | awk -F" " '{ gsub(/^[ \t]+/,"",$2); gsub(/[ \t]+$/,"",$2); n=split($2,a,"/"); gsub(/^[ \t]+/,"",$3); gsub(/[ \t]+$/,"",$3); printf "\033[1;33m%s\033[00m,\033[1;32m%s\033[00m,\033[1;32m%s\033[00m,\033[1;34m%s\033[00m\n", a[n-2], a[n-1], a[n], $3}' | column -t -s ","

printf "\n"
for i in $(seq 0 12);
do
  for j in $(seq 0 9);
  do

    k=$((j + (i * 10)))
    printf "\t\033[1;${k}m %4s \033[00m" $k
  done

  for j in $(seq 0 9);
  do
    printf "\t\033[1;${k}m %-4s \033[00m" $k
  done

  printf "\n"
done

