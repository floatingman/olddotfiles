
################################# History ################################

# This history configuration assume a reasonably conservative system on
# which saving the session history after the session is fine because
# sessions are very frequently started and stopped due to extensive TMUX
# pane usage. Some may prefer to add a `history -a; history -c; history
# -r` to their PROMPT_COMMAND if they tend to stay in the same session for
# a long time and want the history to be updated for all to see.

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000
