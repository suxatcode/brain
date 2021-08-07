#!/usr/bin/zsh

cwd=$0:A:h
source "$cwd/conf.sh"

_grepLangGrep () {
  grep --color=auto -nH "$@"
}
_grepLangInit () {
  _grepLangSearchPATH=( "$@" )
  _grepLangExtraFiles=()
  [ -f ~/todo ] && _grepLangExtraFiles=( ~/todo )
}
_grepLangAndTodoFiles () {
  local IFS=$'\n'
  local findargs=(
    -type f
    -not -wholename '*/.stversions/*'
  )
  local langfiles=($(find $_grepLangSearchPATH -regex ".*/$__brain_suffix"'[^/]*[^~]$\|.*'"$__brain_suffix$" $findargs))
  local todos=($(find $_grepLangSearchPATH -name "todo" -type f))
  for t in $todos; do langfiles+=$t; done
  _grepLangGrep "$@" ${langfiles[@]}
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
