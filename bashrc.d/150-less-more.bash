############################# Editor / Pager #############################

# The first and only visual editor that matters. It's on everything. Stop
# complaining and apologizing for it and learn the fucking thing. Then vi
# all the things and make sure to not fuck up your vi muscle memory with
# arrows and shit you cannot use with an old vi you might be forced to use
# someday. There's really no reason. Learn home row and CTRL-[ for escape.

havecmd vim && alias vi=vim

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
alias more='less -R'

# Here's your colored man pages right here.

export LESS_TERMCAP_mb=$magen
export LESS_TERMCAP_md=$yellow
export LESS_TERMCAP_me=$reset
export LESS_TERMCAP_se=$reset
export LESS_TERMCAP_so=$blue
export LESS_TERMCAP_ue=$reset
export LESS_TERMCAP_us=$violet

