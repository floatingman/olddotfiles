
################### README World Exchange / WorldPress ###################

# This is stuff being prototyped for inclusion into the `rw` tool (which
# is written in Golang).

rw () {

  if [[ -z "$README" ]]; then
    telln 'Need to define `$README` directory.'
    return 1
  fi

  declare _rw=$(which rw)
  declare action="${1:-cd}"; shift

  case "$action" in 

    # Change into the current `$README` directory or module within it. If
    # a specific match is not found searches from a list of all modules
    # and prompts to select one.

    cd|d|dir)
      # TODO read first argument, look for
      cd "$README"
      ;;

    week)
      echo "$(year)w$(week)"
      ;;

    cal)
      # TODO in final version include the ncal code equiv
      # rather than depend on n/cal being on system.
      declare exe=$(which ncal)
      if [[ -z "$exe" ]]; then
        cal
      fi
      $exe -M -w
      ;;

    blog)
      declare blogdir="$README/$(rw week)"
      [[ ! -d $blogdir ]] && mkdir -p $blogdir
      $EDITOR $blogdir/README.md
      tell "Would you like to commit?"
      # TODO factor this into a save)
      if confirm; then
          cd $README
          save
          cd -
      fi
      ;;

    *)
      usageln 'rw <subcommand> <argument>...'
      # TODO later pass off to _rw
      ;;

  esac
} && export -f rw && complete -W 'cd d dir blog' rw

# Imma go ahead and create a `blog` command function to go with the `rw
# blog` subcommand only because that is what I would be doing once `rw` is
# released as a standalone package.

blog () {
  if havecmd rw; then
    rw blog $*
  fi
} && export -f blog 

