# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments


# tab completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files

###########
# plugins #
###########
source ~/.zsh_plugins.sh

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

###########
# History #
###########

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt pushd_ignore_dups

# History Substring Search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Share history across all terminals.
setopt share_history

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history
export HISTORY_IGNORE="(ls|l|ll|lt|[bf]g|exit|reset|clear|cd|cd ..|cd ../|pwd|date|* --help)"


########
# Misc #
########

source ~/.aliases

# Use SSH completion for Mosh.
compdef mosh=ssh

# Menu completion
zstyle ':completion:*' menu select

# Prevent Pure from auto-pulling git repos.
PURE_GIT_PULL=0

# Activate dircolors
test -r "~/.dir_colors" && eval $(dircolors ~/.dir_colors)


######
# Vi #
######
bindkey -v
export KEYTIMEOUT=1
# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey -M viins 'kj' vi-cmd-mode
bindkey -M vicmd "?" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-forward
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

bindkey -s '^a' 'bc -lq\n'

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

#######
# FZF #
#######

if [ -r /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
fi
if [ -r /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
fi

rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX $@" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --bind=tab:down,btab:up \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
    )" &&
    echo "opening $file" &&
    xdg-open "$file"
}


########
# Pass #
########

# Setup alternative pass.
wpass() {
    PASSWORD_STORE_DIR="$ALTPASSDIR" pass "$@"
}
compdef -e 'PASSWORD_STORE_DIR=$ALTPASSDIR _pass' wpass

# Access pass
access() {
    PASSWORD_STORE_DIR="$ACCESSPASSDIR" pass "$@"
}
compdef -e 'PASSWORD_STORE_DIR=$ACCESSPASSDIR _pass' access

# Finance pass
fin() {
    PASSWORD_STORE_DIR="$FINPASSDIR" pass "$@"
}
compdef -e 'PASSWORD_STORE_DIR=$FINPASSDIR _pass' fin


#########
# pyenv #
#########

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
#  eval "$(register-python-argcomplete pipx)"
fi


# mac exports
if command -v brew 1>/dev/null 2>&1; then
    export HOMEBREW_AUTO_UPDATE_SECS=86400
    export HOMEBREW_NO_ANALYTICS=true
    export HOMEBREW_INSTALL_BADGE="(ʘ‿ʘ)"
    export HOMEBREW_BUNDLE_FILE_PATH=~/.homebrew/Brewfile
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/dnewman/gitrepos/vision-stratus/vision-nx-mobile-combined/node_modules/tabtab/.completions/serverless.bash ] && . /Users/dnewman/gitrepos/vision-stratus/vision-nx-mobile-combined/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/dnewman/gitrepos/vision-stratus/vision-nx-mobile-combined/node_modules/tabtab/.completions/sls.bash ] && . /Users/dnewman/gitrepos/vision-stratus/vision-nx-mobile-combined/node_modules/tabtab/.completions/sls.bash
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /Users/dnewman/gitrepos/vision-stratus/vision-nx-share/node_modules/tabtab/.completions/slss.bash ] && . /Users/dnewman/gitrepos/vision-stratus/vision-nx-share/node_modules/tabtab/.completions/slss.bash

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/dnewman/gitrepos/vision-web/node_modules/tabtab/.completions/serverless.bash ] && . /Users/dnewman/gitrepos/vision-web/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/dnewman/gitrepos/vision-web/node_modules/tabtab/.completions/sls.bash ] && . /Users/dnewman/gitrepos/vision-web/node_modules/tabtab/.completions/sls.bash
# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"

# *- set by XOI script [/Users/dnewman/gitrepos/vision-web/scripts/setup-web-dev-env]
# alias for vision-web, to be used for local development
export VISION_WEB_ALIAS=***REMOVED***

# Setup browserstack credintials
export BROWSERSTACK_USERNAME=***REMOVED***
export BROWSERSTACK_ACCESS_KEY=***REMOVED***
export BROWSERSTACK_APP_ID=DanielTest
#export FILE_PATH_TO_IPA="~/Repos/VisionNxMobile/ios/VisionNxMobile.dev.ipa"
export BUILD_TAG=DanielTest
export IPHONE_PLATFORM_VERSION=14.0
export IPHONE_DEVICENAME="iPhone 11"
# Setup Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools/adb:$ANDROID_HOME/build-tools:$JAVA_HOME/bin
# This one is used for the `start.android.emulator` script
export emulator="$HOME/Library/Android/sdk/emulator"
fi


if [[ -r "$HOME/.rbenv" ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

#NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#SDKMAN
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
