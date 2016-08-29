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
# bash 4 features
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar autocd dirspell
fi

shopt -s cdspell extglob histverify no_empty_cmd_completion checkwinsize

shopt -s histappend
complete -cf sudo

if [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
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



### Added by the Heroku Toolbelt
# should've done this a long time ago
set -o vi

VBOX_USB=usbfs

### Bash exports {{{

#bash autojump
if $_isarch; then
    . /etc/profile.d/autojump.bash
else
    . /usr/share/autojump/autojump.sh
fi
# }}}
