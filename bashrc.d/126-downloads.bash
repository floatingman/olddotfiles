
newest () {
  IFS=$'\n'
  f=($(ls -1 --color=never -trd ${1:-.}/*))
  echo "${f[-1]}"
} && export -f newest

lastdown () { echo "$(newest $DOWNLOADS)"; } && export -f lastdown
lastpic () { echo "$(newest $PICTURES)"; } && export -f lastpic
mvlast () { mv "$(lastdown)" "./$1"; } && export -f mvlast
mvlastpic () { mv "$(lastpic)" "./$1"; } && export -f mvlastpic

ex () {
  declare file=$1
  [[ -z "$file" ]] && usageln 'ex <compressed>' && return 1
  [[ ! -f "$file" ]] && tell 'Invalid file: `'$file'`' && return 1
  case $file in
    *.tar.bz2)   tar xjf $file;;
    *.tar.gz)    tar xzf $file;;
    *.bz2)       bunzip2 $file;;
    *.rar)       unrar x $file;;
    *.gz)        gunzip $file;;
    *.tar)       tar xf $file;;
    *.tbz2)      tar xjf $file;;
    *.tgz)       tar xzf $file;;
    *.zip)       unzip $file;;
    *.Z)         uncompress $file;;
    *.7z)        7z x $file;;
    *.xz)        unxz $file;;
    *)           tell 'Unknown suffix on file: `'$file'`'; return 1 ;;
  esac
}

