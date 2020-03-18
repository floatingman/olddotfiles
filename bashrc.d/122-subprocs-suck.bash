 
# When we must.

alias grep='grep -i --colour=always'
alias egrep='egrep -i --colour=always'
alias fgrep='fgrep -i --colour=always'

alias diff='diff --color=always'

# TODO maybe later
#diff () {
  #diff --color=always $* | less
#} && export -f diff

# Recursively greps everything (except the stuff with -name). The first
# /dev/null is an old trick to force find to add the name/path to the
# results.
# TODO rewrite with kat and perg instead of the subshells
grepall () {
  find .                          \
    -name '.git'                  \
    -prune -o                     \
    -exec grep -i --color=always "$1" {} \
    /dev/null                     \
    2>/dev/null \;
} && export -f grepall

# Simple egrep-ish thing without the subshell and with Bash regular
# expressions.

perg () {
  declare exp="$1"; shift
  if [[ -z "$*" ]]; then
    while IFS= read -r line; do
      [[ $line =~ $exp ]] && echo "$line"
    done
    return
  fi
  for file in $*; do
    while IFS= read -r line; do
      [[ $line =~ $exp ]] && echo "$line"
    done < "$file"
  done
} && export -f perg

lower () {
  echo ${1,,}
} && export -f lower

upper () {
  echo ${1^^}
} && export -f upper

linecount () {
   IFS=$'\n'
   declare a=($1)
   echo ${#a[@]}
} && export -f linecount

# These are so much faster than basename and dirname.

basepart () {
  echo ${1##*/}
} && export -f basepart

dirpart () {
  echo ${1%/*}
} && export -f dirpart

# Allows the reading of all combined arguments into a string buffer that
# is then echoed, or if no arguments are detected reads fully from
# standard input until there is none left and echoes that. This is notable
# because it allows the user of heredoc input instead of arguments making
# for much cleaner blocks of text See htitle, tell (which is used in the
# and the setup script including in this repo) for how to use it.

argsorin () {
  declare buf="$*"
  [[ -n "$buf" ]] && echo -n "$buf" && return
  while IFS= read -r line; do 
    buf=$buf$line$'\n'
  done
  echo "$buf"
} && export -f argsorin

# A friendlier cat that does not invoke a subshell.

kat () {
	declare line
  if [[ -z "$*" ]]; then
    while IFS= read -r line; do
      [[ $line =~ $exp ]] && echo "$line"
    done
    return
  fi
  for file in $*; do
    while IFS= read -r line; do
      echo "$line"
    done < "$file"
  done
} && export -f kat

# Same as kat but skips blank and lines with optional whitespace that
# begin with a comment character (#).

katlines () {
  for file in $*; do
    while IFS= read -r line; do
      [[ $line =~ ^\ *(#|$) ]] && continue
      echo "$line"
    done < "$file"
  done
} && export -f katlines


# True if anything that can be run from the command line exists, binaries,
# scripts, aliases, and functions.

havecmd () {
  type "$1" &>/dev/null
  return $?
} && export -f havecmd

# Moves an existing thing to the same path and name but with
# ".preserved.<tstamp>" at the end and echoes the new location. Usually
# preferable to destroying what was previously there. Can be used to roll
# back changes transactionally.

preserve () {
  declare target="${1%/}"
  [[ ! -e "$target" ]] && return 1
  declare new="$target.preserved.$(tstamp)"
  mv "$target" "$new" 
  echo "$new" 
} && export -f preserve

# Lists all the preserved files by matching the .preserved<tstamp> suffix.
# If passed an argument limits to only those preserved files matching that
# name (prefix).

lspreserved () {
  declare -a files
  if [[ -z "$1" ]]; then
      files=(*.preserved.[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
  else
      files=("$1".preserved.[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
  fi
  for i in "${files[@]}"; do
    echo "$i"
  done
} && export -f lspreserved

lastpreserved () {
  mapfile -t  a < <(lspreserved "$1")
  declare n=${#a[@]}
  echo "${a[n-1]}"
} && export -f lastpreserved

rmpreserved () {
  while IFS= read -r line; do
    rm -rf "$line"
  done < <(lspreserved)
} && export -f rmpreserved

# Undos the last preserve performed on the given target.

unpreserve () {
  declare last=$(lastpreserved "$*")
  [[ -z "$last" ]] && return 1
  mv "$last" "${last%.preserved*}"
} && export -f unpreserve

trash () {
  [[ -z "$TRASH" ]] && return 1
  mkdir -p "$TRASH"
  mv "$*" "$TRASH"
} && export -f trash

symlink () {
  declare from="$1"
  declare to="$2"
  if [[ -z "$from" || -z "$to" ]]; then
    usageln 'symlink <from> <to>'
    return 1
  fi
  preserve "$from"
  telln Linking $from'` -> `'$to 
  ln -fs $to $from                   # always hated that this is backwards
} && export -f symlink

# Changes the suffixes from the first argument to the second argument for
# all files specified after that as arguments. Use globstar expansion to
# recurse.

chsuffix () {
  declare i
  declare from="$1"; shift
  declare to="$1"; shift
  declare files=("$@")
  if [[ -z "$files" ]]; then
    usageln 'chsuffix <from> <to> <file> ...'
    return 1
  fi
  for i in "${files[@]}";do
    if [[ "$i" =~ $from$ ]]; then
      declare stripped=${i%$from}
      telln "Moving $i"'` -> `'"$stripped$to"
      mv "$i" "$stripped$to"
    fi
  done
} && export -f chsuffix

anotherterminal () {
  case "$PLATFORM" in 
    mac) ;;
    linux) gnome-terminal;;
  esac
} && export -f anotherterminal

stringscan () {
  declare buf="$1"
  declare handle=(echo)
  [[ -n "$2" ]] && handle=($2)
  for (( i=0; i<${#buf}; i++ )); do 
    ($handle ${buf:$i:1})
  done
} && export -f stringscan

firstline () {
  declare line
  declare IFS=
  read -r line <"$1"
  echo $line
} && export -f firstline


lastline () {
  # Tail is fastest because it does a seek to the end of file.
  tail -1 "$1"
} && export -f lastline

lastcmdline () {
  lastline "$HOME/.bash_history"
} && export -f lastcmdline

lastcmd () {
  declare cl=$(lastcmdline)
  echo ${cl%% *}
} && export -f lastcmd

