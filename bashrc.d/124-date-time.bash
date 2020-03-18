
############################### Date / Time ##############################

tstamp () {
  echo -n $1
  date '+%Y%m%d%H%M%S'
} && export -f tstamp

tstampfile () {
  declare path="$1"
  declare pre=${path%.*}
  declare suf=${path##*.}
  echo -n $pre.$(tstamp)
  [[  "$pre" != "$suf" ]] && echo .$suf
} && export -f tstampfile

now () {
  echo "$1" $(date "+%A, %B %e, %Y, %l:%M:%S%p")
} && export -f now

now-s () {
  echo "$1" $(date "+%A, %B %e, %Y, %l:%M %p")
} && export -f now-s

epoch () {
  date +%s
} && export -f now

watchnow () {
  declare -i delay="${1:-10}"
  havecmd setterm && setterm --cursor off
  trapterm 'setterm --cursor on; clear'
  while true; do 
    clear
    echo -n $(now-s) |lolcat
    now-s > ~/.now
    sleep $delay
  done
} && export -f watchnow

weekday () {
  echo $(lower $(date +"%A"))
} && export -f weekday

month () {
  echo $(lower $(date +"%B"))
} && export -f month

year () {
  echo $(lower $(date +"%Y"))
} && export -f year

week () {
  date +%W
} && export -f week

# Calls the compact ncal variation with Mondays first and including the
# week count during the year. I prefer keeping track of blogs and such by
# the week of the year and not more complicated months and dates. (No one
# ever plugs in a specific month and day into a long blog URL. They just
# want it to be short).

cal () {
  declare exe=$(which ncal)
  if [[ -z "$exe" ]]; then
    cal $* 
    return $?
  fi
  $exe -M -w $*
} && export -f cal
