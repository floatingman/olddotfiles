

[ -z "$OS" ] && export OS=`uname`
case "$OS" in
  Linux)          export PLATFORM=linux ;;
  *indows*)       export PLATFORM=windows ;;
  FreeBSD|Darwin) export PLATFORM=mac ;;
  *)              export PLATFORM=unknown ;;
esac

onmac () {
  [[ $PLATFORM == mac ]]  && return 0
  return 1
} && export -f onmac

onwin () {
  [[ $PLATFORM == windows ]]  && return 0
  return 1
} && export -f onwin

onlinux () {
  [[ $PLATFORM == linux ]]  && return 0
  return 1
} && export -f onlinux

onunknown () {
  [[ PLATFORM == unknown ]]  && return 0
  return 1
} && export -f onunknown

