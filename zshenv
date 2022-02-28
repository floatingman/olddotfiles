#!/usr/bin/env zsh
#
# Setup zsh config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Setup History for repeating commands
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
