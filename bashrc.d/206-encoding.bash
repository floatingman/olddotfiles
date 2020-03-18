
################################ Encoding ################################

rot13 () {
  declare data=$(argsorin "$*")
  echo "$data" | tr '[A-Za-z]' '[N-ZA-Mn-za-m]'
} && export -f rot13

