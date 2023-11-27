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
_grepFindFilesToGrep () {
  local IFS=$'\n'
  local findargs=(
    -type f
    -not -wholename '*/.stversions/*'
    -not -wholename '*/docker-data/*'
    -not -wholename '*/node_modules/*'
  )
  # TODO: reuse find.sh functions
  local langfiles=($(find $_grepLangSearchPATH -regex ".*/$__brain_suffix"'[^/]*[^~]$\|.*'"$__brain_suffix$" $findargs))
  local todos=($(find $_grepLangSearchPATH -name "todo" -type f))
  for t in $todos; do langfiles+=$t; done
  #echo "XXX $langfiles" >&2
  echo "${langfiles[@]}"
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
