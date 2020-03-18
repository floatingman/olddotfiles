
###################### Gnome Terminal Configuration ######################

# Gnome terminal configuration is never easy to save. These are the
# documented ways to save, reset, and restore a gnome-configuration
# setting for an individual user. The commands are easy enough to execute
# so these are included mostly as reminders about how to do it.

gnome-terminal-conf-dump () {
  if ! havecmd dconf ; then
    telln 'Cannot locate: `dconf`'
    return 1
  fi
  declare dest="${1:-/tmp/dconf-terminal-$(tstamp)}"
  declare buf=$(dconf dump /org/gnome/terminal/)
  echo "$buf" >| $dest
  echo $dest
} && export -f gnome-terminal-conf-dump

gnome-terminal-conf-reset () {
  if ! havecmd dconf ; then
    telln 'Cannot locate: `dconf`'
    return 1
  fi
  dconf reset -f /org/gnome/terminal/
} && export -f gnome-terminal-conf-reset

gnome-terminal-conf-load () {
  if ! havecmd dconf ; then
    telln 'Cannot locate: `dconf`'
    return 1
  fi
  if [[ -z "$1" ]]; then
    usageln 'gnome-terminal-conf-load <path>'
    return 1
  fi
  dconf load < "$1"
} && export -f gnome-terminal-conf-load

termtitle () {
  printf "\033]0;$*\007"
} && export -f termtitle

alias tmatrix="tmatrix -s 15 --fade"

hidecursor () {
  if havecmd setterm; then
    setterm --cursor off
    trapterm 'setterm --cursor on; clear'
  fi
} && export -f hidecursor
