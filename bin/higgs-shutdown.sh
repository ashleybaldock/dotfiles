#!/usr/bin/env bash

# HIGGS=higgs.local
HIGGS=higgs.home

ssh "$HIGGS" "shutdown /P"
