#############
# Utilities #
#############

source "$HOME/.functions"

# is $1 installed?
_have() { which "$1" &>/dev/null; }

# Detect which platform we are on
_islinux=false
[[ "$(uname -s)" =~ Linux ]] && _islinux=true
_ismac=false
[[ "$(uname -s)" =~ Darwin ]] && _ismac=true
_isubuntu=false
[[ "$(uname -v)" =~ Ubuntu ]] && _isubuntu=true
_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true
_iswsl=false
[[ "$(uname -v)" =~ Microsoft ]] && _iswsl=true
# Detect if gui is running
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true
# Detect if root
_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

# add directories to $PATH
_add_to_path() {
    local path

    for path; do
        [[ -d "$path" ]] && [[ ! ":${PATH}:" =~ :${path}: ]] && export PATH=${path}:$PATH
    done
}

# source a file if readable
_source() {
    local file="$1"
    [[ -r "$file" ]] || return 1
    . "$file"
}

# We need to load homebrew pretty early
if $_ismac; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

########
# Path #
########
if $_ismac; then
  [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/bin" | cut -f2 | tr '\n' ':')"
  [[ -r "$HOME/.bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/.bin" | cut -f2 | tr '\n' ':')"
  _add_to_path "/usr/local/sbin"
else
    [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/bin" | cut -f2 | tr '\n' ':')"
    [[ -r "$HOME/.local/bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/.local/bin" | cut -f2 | tr '\n' ':')"
fi

######################
# Local Applications #
######################
[[ -r "$HOME/apps/apache-jmeter-5.4/bin" ]] && _add_to_path "$HOME/apps/apache-jmeter-5.4/bin"

####################
# Default programs #
####################
export TERMINAL='alacritty'
export BROWSER="firefox"
export FILE="ranger"
export TERM="xterm-256color"    # For getting proper colors
export EDITOR="nvim"      # $EDITOR use Emacs in terminal
export VISUAL="emacsclient -c -a emacs"   # $VISUAL use Emacs in GUI mode

#######
# FZF #
#######
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
export FZF_DEFAULT_OPTS="--height 60% --border sharp"
# export FZF_DEFAULT_COMMAND='rg --files --ignore --hidden --follow --glob "!.git/*"'
#export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"

#############################
# CHANGE TITLE OF TERMINALS #
#############################
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

#######################
# Default directories #
#######################
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"

###########
# Android #
###########
if $_islinux; then
    export ANDROID_HOME=$HOME/Android/Sdk
    export PATH=$PATH:$ANDROID_HOME/emulator
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/tools/bin
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

if $_ismac; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

###########
# Vagrant #
###########
if $_iswsl; then
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
  export PATH="${PATH}:/mnt/c/Program Files/Oracle/VirtualBox"
fi

######
# Go #
######
 if [ -d "/usr/local/go" ] ; then
     export PATH=$PATH:/usr/local/go/bin
     export GOPATH=$HOME/go
     export GOBIN=$GOPATH/bin
     PATH="$GOBIN:$PATH"
     export GOPROXY=https://goproxy.io,direct
 fi

# Set the default environment directory for virtualenvwrapper.
export WORKON_HOME="$HOME/.virtualenvs"

# Set the default project directory for virtualenvwrapper.
export PROJECT_HOME="$HOME/projects"

# Load virtualenvwrapper (lazy).
#source /usr/bin/virtualenvwrapper_lazy.sh

#########
# pyenv #
#########
if $_ismac; then
    eval "$(pyenv init --path)"
elif [[ -r "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

# Rbenv
if [[ -r "$HOME/.rbenv" ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

# NVM
if [[ -d "$HOME/.nvm" ]] ; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


#######
# DPI #
#######
if [[ -e $HOME/.dpi ]]; then
  source $HOME/.dpi
fi

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

# Other program settings
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
