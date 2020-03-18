
# The tmp directory differs significantly between major operating systems
# so will use $TEMP throughout.

# TODO get the windows version (should be %TEMP%)

case "$PLATFORM" in
  windows) ;;
  *) export TEMP=/tmp
esac

mktempname () {
  echo "${1:-temp}.$$.$(tstamp)"
} && export -f mktempname

mktemppath () {
  [[ -z "$TEMP" ]] && return 1
  declare name=$(mktempname "$*")
  echo "$TEMP/$name"
} && export -f mktemppath

mktempdir () {
  declare path=$(mktemppath "$*")
  mkdir "$path"
  echo $path
} && export -f mktempdir

mktempfile () {
  declare path=$(mktemppath "$*")
  touch "$name"
  echo $name
} && export -f mktempfile
