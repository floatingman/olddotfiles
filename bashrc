#!/bin/bash

stty -ixon # Disable ctrl-s and ctrl-q

# get out if non-interactive
[[ $- != *i* ]] && return

## set xterm for tmux
[ -z "$TMUX" ] && export TERM=xterm-256color

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
    _have sudo && complete -cf sudo
fi

if [[ -d $HOME/.bash_completion ]]; then
    _load_bash_completion_files
fi

# macports path
if [[ -f /opt/local/etc/bash_completion ]]; then
    . /opt/local/etc/bash_completion
    _have sudo && complete -cf sudo
fi

if [[ -f "$HOME/.lscolors" ]] && [[ $(tput colors) == "256" ]]; then
    # https://github.com/trapd00r/LS_COLORS
    _have dircolors && eval "$(dircolors -b "$HOME"/.lscolors)"
fi

# should've done this a long time ago
set -o vi

eval "$(fasd --init auto)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autojump on mac
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

