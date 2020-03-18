
preview () {
  browser-sync start \
    --no-notify --no-ui \
    --ignore '**/.*' \
    -sw
} && export -f preview

httphead () {
  curl -I -L "$@"
} && export -f httphead
