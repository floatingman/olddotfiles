
############################ Web API / Tokens ############################

token () {
  [[ -z "$TOKENS" ]] && telln '`$TOKENS` is not set.' && return 1
  declare file="$TOKENS/$1"
  [[ ! -r "$file" ]] && return 1
  firstline "$TOKENS/$1"
} && export -f token
