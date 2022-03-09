# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dnewman/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/dnewman/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/dnewman/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/dnewman/.fzf/shell/key-bindings.zsh"
