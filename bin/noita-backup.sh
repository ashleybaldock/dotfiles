#!/usr/bin/env bash

# HIGGS=higgs.local
HIGGS=higgs.home

ssh "$HIGGS" "cd .\noita\  & noita-backup.sh"
