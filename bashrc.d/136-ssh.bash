
############################ Secure Shell (SSH) ##########################

# At this point elliptical curve (25519) is the only algorithm anyone
# should ever use. If you haven't upgraded you really should.

sshkeygen () {
  yes '' | ssh-keygen -t ed25519
} && export -f sshkeygen

sshpubkey () {
  declare name=id_ed25519
  [[ -n "$1" ]] && name="$1"
  cat $HOME/.ssh/$name.pub
} && export -f sshpubkey

sshhosts () {
  declare file="$HOME/.ssh/config"
  [[ -f $file ]] || return 1
  while read -r line; do
    [[ "$line" =~ ^Host\ *([^\ ]*) ]] || continue
    echo ${BASH_REMATCH[1]}
  done < "$file"
} && export -f sshhosts && complete -W ssh "$(sshhosts)"

