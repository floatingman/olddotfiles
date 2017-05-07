# ~/.bashrc
# Daniel Newman 2014
#
# an attempt at a monolithic/portable bashrc
# taken from pbrisbin and helmuthdu and other sources
#
###

# get out if non-interactive
[[ $- != *i* ]] && return

## set xterm for tmux
[ -z "$TMUX" ] && export TERM=xterm-256color

## BASH OPTIONS {{{

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
    _have sudo && complete -cf sudo
fi

# macports path
if [[ -f /opt/local/etc/bash_completion ]]; then
    . /opt/local/etc/bash_completion
    _have sudo && complete -cf sudo
fi

#}}}


## EXPORTS {{{


if [[ -f "$HOME/.lscolors" ]] && [[ $(tput colors) == "256" ]]; then
    # https://github.com/trapd00r/LS_COLORS
    _have dircolors && eval $( dircolors -b $HOME/.lscolors )
fi

# should've done this a long time ago
set -o vi

VBOX_USB=usbfs

eval "$(fasd --init auto)"
#}}}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if $_ismac; then
  export SDKMAN_DIR="/Users/daniel.newman/.sdkman"
  [[ -s "/Users/daniel.newman/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/daniel.newman/.sdkman/bin/sdkman-init.sh"
fi
