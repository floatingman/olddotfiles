#!/usr/bin/env zsh

# Setup config directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Setup zsh config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Setup History for repeating commands
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
