
########################## System Administration #########################

is-valid-username () {
  [[ "$1" =~ ^[a-z_][a-z0-9_]{0,31}$ ]] && return 0
  return 1
} && export -f is-valid-username

#change-user-name () {
#  declare old="$1"
#  declare new="$2"
#  if [[ -z "$old" || -z "$new" ]]; then
#    usageln 'change-user-name <old> <new>'
#    return 1
#  fi
#  ! is-valid-username "$old" && telln 'Invalid old username: `'$old'`' && return 1
#  ! is-valid-username "$new" && telln 'Invalid new username: `'$new'`' && return 1
#  sudo groupadd $new
#  # TODO rename the directory, test on vm
#  sudo usermod -d /home/$new -m -g $new -l $new $old
#}
