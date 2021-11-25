#!/usr/bin/zsh

cwd=$0:A:h
source "$cwd/conf.sh"
source "$cwd/grep.sh"

# LANGUAGE
__brain_find_file_in_path () {
  #echo "[d] __brain_find_file_in_path $@" >&2
  local root="$1" q="$2"
  local f=($(find "$root" -name "$__brain_suffix.$q" -or -name "$q.$__brain_suffix")) # try exact matches first
  if [[ $#f -eq 0 ]]; then
    f=($(find "$root" -name "*$q*.$__brain_suffix" -or -name "$__brain_suffix.*$q*")) # try non-complete matches
  fi
  # TODO: fuzzy machtes?
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
__brain_root_edit () {
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
__brain_pw_roots=($HOME/z/priv/misc/intl)
__brain_pw_suffix=pw
__brain_pw_edit () {
  local __brain_roots=$__brain_pw_roots __brain_suffix=$__brain_pw_suffix
  __brain_root_edit "$@"
}
__brain_session_dir=$__brain_roots[1]/vim
__brain_session () {
  local sess="$__brain_session_dir/$1.vim"
  [[ -f "$sess" ]] || return 1
  vim -S "$sess"
}
__brain_log_file="$HOME/z/priv/misc/mind/log"
__brain_log () {
  vim "$__brain_log_file"
}
__brain_human_root=$HOME/z/priv/misc/contact
__brain_human_files () {
  for f in $(find $__brain_human_root -type f -not \( -name '*~' -or -name '*.vcf' \) ); do
    echo ${f#$__brain_human_root/}
  done
}
__brain_human_edit () {
  local file="$HOME/z/priv/misc/contact/$1"
  vim "$file"
  local files=$(__brain_human_files)
}
__brain_human () {
  __brain_human_edit "$@"
}
brain () {
  if [[ $# -eq 0 ]]; then
    echo "brain"
    echo "  e|edit <file>     search brain for lan.<file>/<file.lang an open it"
    echo "  n|new <file>      ???"
    echo "  c|contact <name>  search brain for humans"
    echo "  pw <file>         search brain for <file>.pw"
    echo "  l|log             edit log"
    return 0
  fi
  local arg1="$1"
  shift
  if [[ "$arg1" =~ '^(e|edit)$' ]]; then
    __brain_root_edit "$@"
  elif [[ "$arg1" =~ '^(g|grep)$' ]]; then
    greplang "$@"
  elif [[ "$arg1" =~ '^(pw)$' ]]; then
    __brain_pw_edit "$@"
  elif [[ "$arg1" =~ '^(session)$' ]]; then
    __brain_session "$@"
  elif [[ "$arg1" =~ '^(n|new)$' ]]; then
    echo "hippocampus: long term memory failure"
  elif [[ "$arg1" =~ '^(c|contact)$' ]]; then
    __brain_human "$@"
  elif [[ "$arg1" =~ '^(l|log)$' ]]; then
    __brain_log "$@"
  fi
}

# completion!
_echo_line () {
  echo "ctx=$context state=$state statedescr=$state_descr line=$line"
}
_brain_2nd () {
  if [[ "$line" =~ '.*(pw).*' ]]; then
    _values 'pw files' $(ls $__brain_pw_roots/*.pw\
      |sed -e "s,$__brain_pw_roots/,,g"\
      |sed -e "s,\(.*\).pw,\1,g")
  elif [[ "$line" =~ '.*(session).*' ]]; then
    _values 'sessions' $(ls $__brain_session_dir/*.vim\
      |sed -e "s,$__brain_session_dir/,,g"\
      |sed -e "s,\(.*\).vim,\1,g")
  elif [[ "$line" =~ '.*(contact).*' ]]; then
    _values 'contact humans' $(__brain_human_files)
  else
    #_echo_line
  fi
}
_brain () {
  local context state state_descr line
  typeset -A opt_args
  #local operations=(":edit:edit brain's content" ":grep:" ":pw:")
  _arguments ":operation:(edit grep pw session log contact)" ":subject:_brain_2nd"
}
compdef _brain brain
