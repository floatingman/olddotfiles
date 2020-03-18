
################################## Curl ##################################

alias ipinfo="curl ipinfo.io"
alias weather="curl wttr.in"

# Igor Chubin is a god.

cheat() {
  where="$1"; shift
  IFS=+ curl "http://cht.sh/$where/ $*"
} && export -f cheat
