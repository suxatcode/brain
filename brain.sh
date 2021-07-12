#!/usr/bin/zsh

cwd=$0:A:h
source "$cwd/conf.sh"
source "$cwd/grep.sh"

# LANGUAGE
__brain_find_file_in_path () {
  #echo "[d] __brain_find_file_in_path $@" >&2
  local root="$1" q="$2"
  local f=($(find "$root" -name "lang.$q" -or -name "$q.lang"))
  if [[ $#f -eq 0 ]]; then
    f=($(find "$root" -name "*$q*.$__brain_suffix" -or -name "$__brain_suffix.*$q*"))
  fi
  echo "${(j/:/)f}"
  [[ $#f -eq 1 ]] || return 1
  return 0
}
__brain_find_all () {
  local all=$(__brain_find_file "")
  for f in $(echo "$all"|sed "s,:,\n,g"); do
    echo $f|sed 's,.*/\(.*\),\1,g'
  done
}
__brain_find_file () {
  local q="$1"
  local multiple=0 res=()
  for root in $__brain_roots; do
    res+=($(__brain_find_file_in_path "$root" "$q"))
    [[ $? -eq 0 ]] || multiple=1
  done
  echo "${(j/:/)res}"
  if [[ $#res -ne 1 ]] || [[ $multiple == 1 ]]; then
    return 1
  fi
  return 0
}
__brain_edit () {
  if [[ $# -eq 0 ]]; then
    echo "brain: no search term provided"
    return 1
  fi
  local f=$(__brain_find_file "$@")
  local multiple=0
  [[ "$f" =~ '.*:.*' ]] && multiple=1
  if [[ "$f" == "" ]]; then
    echo "brain: no information available about '$@'"
    return 1
  fi
  if [[ $multiple == 1 ]]; then
    local first=$(echo $f|sed "s,:,\n,g"|head -n1)
    local all=$(echo $f|sed "s,:,\n,g")
    echo -e "brain: ambiguous query result {\n$all\n}, choosing '$first'"
    f="$first"
  fi
  "$EDITOR" "$f"
}
brain () {
  if [[ $# -eq 0 ]]; then
    echo "brain"
    echo "  e|edit <file>     search for <file> an open it"
    echo "  n|new <file>      ???"
    return 0
  fi
  local arg1="$1"
  shift
  if [[ "$arg1" =~ '^(e|edit)$' ]]; then
    __brain_edit "$@"
  elif [[ "$arg1" =~ '^(g|grep)$' ]]; then
    greplang "$@"
  elif [[ "$arg1" =~ '^(n|new)$' ]]; then
    echo "hippocamus: long term memory failure"
  fi
}
