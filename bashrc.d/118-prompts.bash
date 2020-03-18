
confirm () {
  declare yn
  read -p " [y/N] " yn
  [[ ${yn,,} =~ y(es)? ]] && return 0
  return 1
} && export -f confirm

tell () {
  declare buf=$(argsorin "$*")
  mark $md_plain "$buf"
} && export -f tell

telln () {
  tell "$*"; echo
} && export -f telln

remind () {
  declare buf=$(argsorin "$*")
  tell "*REMEMBER:* $buf"
} && export -f remind

remindln () {
  remind "$*"; echo
} && export -f remindln

danger () {
  declare buf=$(argsorin "$*")
  tell "${blinkon}***DANGER:***${blinkoff} $buf"
} && export -f danger

dangerln () {
  danger "$*"; echo
} && export -f dangerln

warn () {
  declare buf=$(argsorin "$*")
  tell "${yellow}WARNING:${reset} $buf"
} && export -f warn

warnln () {
  warn "$*"; echo
} && export -f warnln

usageln () {
  declare cmd="$1"; shift
  declare buf="$*"
  tell "**usage:** *$cmd* $buf"
  echo
} && export -f usageln
