#!/usr/bin/zsh

# my precious todo thingy
todo () {
  local grep_excludes=(
    --exclude='*~' --exclude='*.swp' --exclude-dir=.git
    --binary-files=without-match
    --exclude-dir=docker-data
  )
  # special comments found in program source
  local re_notes='\<\(TODO\|NOTE\|FIXME\|XXX\|HELP\|WTF\|CONTINUE\)\>'
  # default todofile
  local todofile=$HOME/0x/todo
  if [[ $1 =~ '^(-?p|(--)?pj|(--)?pwd|\.)$' ]]; then
    shift
    grep --color=auto -rn $grep_excludes[@] $re_notes . "$@"
  elif [[ $1 =~ '^(-?e|(--)?edit)$' ]]; then
    vim $todofile
  else
    head -n20 $todofile
  fi
}
alias what='todo pj'
