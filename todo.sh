#!/usr/bin/zsh

# my precious todo thingy
todo () {
  local grep_excludes=(
    --exclude='*~' --exclude='*.swp' --exclude-dir=.git
    --binary-files=without-match
  )
  # special comments found in program source
  local re_notes='\<\(TODO\|NOTE\|FIXME\|XXX\|HELP\|WTF\)\>'
  # default todofile
  local todofile=$HOME/todo
  if [[ $1 =~ '^(-?p|(--)?pj|(--)?pwd|\.)$' ]]; then
    grep --color=auto -rn $grep_excludes[@] $re_notes .
  elif [[ $1 =~ '^(-?e|(--)?edit)$' ]]; then
    vim $todofile
  else
    head -n20 $todofile
  fi
}
alias what='todo pj'
