#!/usr/bin/env bash
#
# https://stackoverflow.com/a/12194427
# bash 4.4+
#

createFile() { # fd base [suffix [max]]]
  local fd="$1" base="$2" suffix="${3-}" max="${4-}"
  local n= file
  local - # ash-style local scoping of options in 4.4+
  set -o noclobber
  REPLY=
  until
    file=$base${n:+-$n}$suffix
    eval 'command exec '"$fd"'> "$file"' 2> /dev/null
  do
    ((n++))
    ((max > 0 && n > max)) && return 1
  done
  REPLY=$file
}

