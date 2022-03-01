#!/bin/env zsh

##############
# Navigation #
##############
setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

###########
# History #
###########
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

export HISTORY_FILTER_EXCLUDE=("_KEY" "Bearer" ".mkv" ".avi" ".mp4") # Exclude certain file types from History - Requires plugin 

###########
# Aliases #
###########
[ -f "${XDG_CONFIG_HOME}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME}/shell/aliasrc"

# Useful Functions
source "$ZDOTDIR/zsh-functions"

##################
# AUTOCOMPLETION #
##################

# asdf
if [ -d $HOME/.asdf ]; then
    . $HOME/.asdf/asdf.sh
    # append completions to fpath
    fpath=(${ASDF_DIR}/completions $fpath)
fi

zsh_add_file "zsh-completion"

autoload -Uz $ZDOTDIR/completion/kubectl-completion/zsh-kubectl-completion


##########
# Prompt #
##########
zsh_add_file "zsh-prompt"

################
# Key-Bindings #
################
# Use emacs-like key bindings by default:
#bindkey -e

zsh_add_file "zsh-vim-mode":w

bindkey -s '^o' 'ranger^M'
bindkey -s '^s' 'ncdu^M'
# Find a file and cd into it's directory
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

###########
# Plugins #
###########

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "MichaelAquilina/zsh-history-filter"

##################
# HELP           #
##################
autoload -Uz run-help
autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn


#######
# FZF #
#######

if [ -r /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
fi
if [ -r /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
fi


# ===================
#    MISC SETTINGS
# ===================

# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# Docker
if [[ -f "$HOME/.dockerfunc" ]]; then
    source "${HOME}/.dockerfunc"
fi

# Load keychain
eval $(keychain --eval --quiet --agents ssh,gpg id_rsa)

# load private things if there
[ -f "$HOME/.zsh_private" ] && source "$HOME/.zsh_private"

# load mac things if there
[ -f "$HOME/.zsh_mac" ] && source "$HOME/.zsh_mac"
