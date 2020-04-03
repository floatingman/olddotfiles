
################## Vim Editing / Magic Wand (!) Functions ################

# Fast way to pull down newly added Plug plugins after update to .vimrc.
# When in doubt begin names with the letter 'p' for disambiguation.

# TODO make a want function that converts Pandoc tables (which are so easy
# to make) into the GitHub Flavored Markdown style tables (that are
# supported everywhere). Need something like that for README.md files that
# are primarily read on GitHub and GitLab instead of getting converted to
# HTML, LaTeX or whatever (which Pandoc focuses on).

alias vimpluginstall="vim +':PlugInstall' +':q!' +':q!'"
alias nvimpluginstall="nvim +':PlugInstall' +':q!' +':q!'"
# TODO Set the VIMSPELL env variable pointing to the main `add` file so editing

funcsin () {
  egrep '^[-_[:alpha:]]* ?\(' $1 | while read line; do
    echo ${line%%[ (]*}
  done
} && export -f funcsin

aliasesin () {
  mapfile -t  lines < <(perg '^alias ' "$*")
  declare line
  # LEFTOFF
  for line in "${lines[@]}"; do
    echo $line
  done
} && export -f aliasesin

# Opens any executable found in the PATH for editing, including binaries.

vic () {
  vi $(which $1)
} && export -f vic

# Echo the first argument, second argument (n) number of times.

echon () {
  declare i
  for ((i=0; i<${2:-1}; i++)); do echo -n "$1"; done
} && export -f echon

export HRULEWIDTH=74

hrule () {
  declare ch="${1:-#}"
  echo $(echon "$ch" $HRULEWIDTH)
} && export -f hrule

# This is how all the heading separators are made (!!htitle Title)

htitle () {
  declare str=$(argsorin $*)
  declare len=${#str}
  declare side=$(( ((HRULEWIDTH/2)-len/2)-1 ))
  declare left=$side
  declare right=$side
  [[ $[len%2] == 1 ]] && right=$[right-1]
  echo "$(echon '#' $left) $str $(echon '#' $right)"
} && export -f htitle

h1now () { now '#'; } && export -f h1now
h2now () { now '##'; } && export -f h2now
h3now () { now '###'; } && export -f h3now
h4now () { now '####'; } && export -f h4now
h5now () { now '#####'; } && export -f h5now
h6now () { now '######'; } && export -f h6now
