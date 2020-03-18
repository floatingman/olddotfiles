################### Simple Todo Utility Using Markdown ###################

todo () {
  if [[ -n "$TODOFILE" ]]; then
    $EDITOR $TODOFILE
  else
    telln 'No `$TODOFILE` set.' 
  fi
} && export -f todo
