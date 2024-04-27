#!/opt/homebrew/bin/bash

args=("$@")

if [ $# -eq 0 ]
then
  echo "Specify some files to transfer" >&2
  exit 1
fi

for arg in "${args[@]}"
do
  if [ -f "$arg" ]
  then
    scp "$arg" higgs.home:ToHiggs/
  else
    echo "Not a file, skipping" >&2
  fi
done
