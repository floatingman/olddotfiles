#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Add ruby gems to the path.
if which ruby >/dev/null && which gem >/dev/null; then
    path=($(ruby -rubygems -e 'puts Gem.user_dir')/bin $path)
fi

alias mtr-report='mtr --report --report-cycles 10 --no-dns'

eval `dircolors $HOME/.dircolors-solarized/dircolors.ansi-dark`

alias e='aunpack'
alias um='udiskie-mount -r'
alias uu='udiskie-umount'

# Use SSH completion for Mosh.
compdef mosh=ssh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/daniel.newman/.sdkman"
[[ -s "/Users/daniel.newman/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/daniel.newman/.sdkman/bin/sdkman-init.sh"
