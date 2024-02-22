#!/usr/bin/zsh

cwd=$0:A:h
source "$cwd/find.sh"
source "$cwd/conf.sh"

_grepLangGrep () {
  grep --color=auto -nH "$@"
}
_grepLangInit () {
  _grepLangSearchPATH=( "$@" )
}

# TODO: move to find.sh
_grepFindFilesToGrep_find () {
  local IFS=$'\n'
  local findargs=(
    -type f
    -not -wholename '*/.stversions/*'
    -not -wholename '*/docker-data/*'
    -not -wholename '*/node_modules/*'
  )
  local langfiles=($(find $_grepLangSearchPATH -regex ".*/$__brain_suffix"'[^/]*[^~]$\|.*'"$__brain_suffix$" $findargs))
  local todos=($(find $_grepLangSearchPATH -name "todo" -type f))
  for t in $todos; do langfiles+=$t; done
  echo "${langfiles[@]}"
}
_grepFindFilesToGrep_fd () {
  local opts=($(printf ' -E "%s" ' "${__brain_directory_ignores[@]}"))
  local f=($(fd $opts "(^$__brain_suffix\.|\.$__brain_suffix$)" $_grepLangSearchPATH))
  if [[ $#f -eq 0 ]]; then
    f=($(fd $opts "(^${__brain_suffix}\.[^/]*|[^/]*\.${__brain_suffix})" $_grepLangSearchPATH))
  fi
  echo "${f}"
}
_grepFindFilesToGrep () {
  if which fd >/dev/null; then
    _grepFindFilesToGrep_fd
  else
    _grepFindFilesToGrep_find
  fi
}

_grepLangAndTodoFiles () {
  _grepLangGrep "$@" $(_grepFindFilesToGrep)
}
grepz () {
  _grepLangInit $__brain_roots[2]
  _grepLangAndTodoFiles "$@";
}
alias grepstu=grepz
grep0x () {
  _grepLangInit $__brain_roots[1]
  _grepLangAndTodoFiles "$@"
}
greplang () {
  _grepLangInit $__brain_roots
  _grepLangAndTodoFiles "$@"
}
alias grepbrain='greplang'
