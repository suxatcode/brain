#!/usr/bin/zsh

cwd=$0:A:h
source "$cwd/brain_functions.sh"
which compdef >/dev/null && compdef _brain brain
