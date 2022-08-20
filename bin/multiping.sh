#!/usr/bin/env bash

# It's a trap
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

__usage="
Usage: $(basename $0) [options] <host> [<host2> ... <hostN>]

Options:
  -h, --help                   Print this
"
  # -i                           Seconds between ping attempts

NL=$'\n'
interval=2 # TODO make this configurable

if [ $1 = "-h" ] || [ $1 = "--help" ]; then
  echo 1>&2 "$__usage"
  exit 2
elif [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo 1>&2 "$__usage"
  exit 2
fi

# Run ping repeatedly for each host
ping_forever() {
  local host=$1
  local interval=$2

  echo -e "\r\033[K$(date "+%H:%M:%S") --  ??  -- \033[1m$1\033[0m"

  while :
  do
    # local output=$(ping -q -o -t $interval $1 | awk '/packet loss/ {printf "%s/%s (%s)", $4, $1, $7} /PING/ {print $3}' | paste -sd " " -)
    set -o pipefail
    output=$(ping -q -o $host 2>/dev/null | awk '/PING/ {print $3}' | tr -d '():')
    retVal=$?

    if [ $retVal -ne 0 ]; then
      echo -e "\r\033[K$(date "+%H:%M:%S") -- \033[1;91mdown\033[0m -- \033[1m$1\033[0m"
    else
      echo -e "\r\033[K$(date "+%H:%M:%S") --  \033[1;92mup\033[0m  -- \033[1m$1\033[0m ($output)"
    fi

    sleep $interval
  done
}

# Bash has no multi-dimensional array support, boo
fds=()
lasts=()

# Map each host to a ping subshell, file descriptor for IPC, and cache of the last result
for host in "$@"
do
  PIPE=$(mktemp -u)
  mkfifo $PIPE
  exec {fd}<>$PIPE
  rm $PIPE

  ping_forever $host $interval 1>&${fd} &
  fds+=($fd)
  lasts+=('')
done

# Loop forever checking for updated ping status and updating display
while :
do
  for i in "${!fds[@]}"
  do
    while IFS= read -r -u ${fds[i]} -t 0.1 line; do
      lasts[i]="$line"
    done
    out+="${lasts[i]}$NL"
  done

  echo -n "$out"

  # move cursor up N lines to overwrite output
  out=$'\033['
  out+="${#fds[@]}A"

  sleep 1
done

wait
exit

