## -*- default-directory: "~/.dotfiles/"; -*-

## Options
shopt -s checkwinsize
# set +o histexpand
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# bash 4 features
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar autocd dirspell
fi

bind '\C-w:backward-kill-word' 2>/dev/null
stty -ixon >/dev/null 2>&1 || true # disable flow control (XON/XOFF)

## Bash Utility Functions
# is $1 installed?
_have() { which "$1" &>/dev/null; }

_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_ismac=false
[[ "$(uname -s)" =~ Darwin ]] && _ismac=true

_isubuntu=false
[[ "$(uname -v)" =~ Ubuntu ]] && _isubuntu=true
_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

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
_source () {
    local file="$1"
    [[ -r "$file" ]] || return 1
    . "$file"
}

_load_bash_completion_files() {
    FILES="$HOME/.bash_completion/*.bash"
    for config_file in $FILES
    do
        if [[ -e ${config_file} ]]; then
            source $config_file
        fi
    done
}

# Get screen dpi
get_dpi() {
    r=$( (xrandr | \
             grep '\<connected\>' | \
             head -n 1 | \
             sed 's/[^0-9]/ /g' | \
             awk '{printf "%.0f\n", $2 / ($6 * 0.0394)}') \
           2>/dev/null)
    if [ -z "$r" ]; then
        echo 96  # fake it
    else
        echo "$r"
    fi
}

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
                                         -o "nospace" \
                                         -W "$(grep "^Host" ~/.ssh/config | \
grep -v "[?*]" | cut -d " " -f2 | \
tr ' ' '\n')" scp sftp ssh


## Completions
_systemctl() {
  _completion_loader systemctl
  _systemctl "${@}"
}
complete -F _systemctl d
complete -d cd

## Environment
source ~/.bash_prompt

export WINEDEBUG=-all

if [ -e ~/.dpi ]; then
  source ~/.dpi
fi

## Identity
export REALNAME="Daniel Newman"
export EMAIL="dwnewman78@gmail.com"
export GIT_COMMITTER_NAME="$REALNAME"
export GIT_AUTHOR_NAME="$REALNAME"
export KEYID="5EFF1854151D190122A702DFC7B1A7755550807C"

## Exports
export EDITOR="nvim";
export TERMINAL="urxvt";
export BROWSER="firefox";
export READER="zathura"
export FILE="ranger"
export SUDO_ASKPASS="$HOME/bin/tools/dmenupass"
export DOTFILES_PATH="$HOME/.dotfiles"
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd*";
export HISTCONTROL="ignoreboth:erasedups";
export HISTSIZE=9999
export HISTFILESIZE=9999
export HISTTIMEFORMAT="%c "
# For the fuzzy finder
if _have fzf; then
  export FZF_DEFAULT_OPTS='--color=bg+:24 --reverse'
fi

# standard in linux
if $_islinux; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.utf8
fi

# less
if _have less; then
    export PAGER=less

    LESS=-R # use -X to avoid sending terminal initialization
    LESS_TERMCAP_mb=$'\e[01;31m'
    LESS_TERMCAP_md=$'\e[01;36m'
    LESS_TERMCAP_me=$'\e[0m'
    LESS_TERMCAP_se=$'\e[0m'
    LESS_TERMCAP_so=$'\e[01;44;33m'
    LESS_TERMCAP_ue=$'\e[0m'
    LESS_TERMCAP_us=$'\e[01;32m'
    export ${!LESS@}
fi

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";

# Gtags
export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=ctags

if $_ismac; then
  export HOMEBREW_AUTO_UPDATE_SECS=86400
  export HOMEBREW_NO_ANALYTICS=true
  export HOMEBREW_INSTALL_BADGE="(ʘ‿ʘ)"
  export HOMEBREW_BUNDLE_FILE_PATH=~/.extra/homebrew/Brewfile
fi

# Let's keep a virtualenv workon directory
[[ -d "$HOME/.venvs/" ]] && export WORKON_HOME="$HOME/.venvs/"

_source /usr/bin/virtualenvwrapper_lazy.sh

## PATH variables
add() {
  # Prepend $1 to $2 if not in $2
  if [[ ":$2:" != *":$1:"* ]]; then
    if [ -z "$2" ]; then
      printf '%s' "$1"
    else
      printf '%s' "$1:$2"
    fi
  else
    printf '%s' "$2"
  fi
}

restore() {
  # Restore pre-configuration paths
  if [ "$ORIG_SAVED" = yes ]; then
    PATH="$ORIG_PATH"
    C_INCLUDE_PATH="$ORIG_C_INCLUDE_PATH"
    CPLUS_INCLUDE_PATH="$ORIG_CPLUS_INCLUDE_PATH"
    LIBRARY_PATH="$ORIG_LIBRARY_PATH"
    LD_LIBRARY_PATH="$ORIG_LD_LIBRARY_PATH"
    LD_RUN_PATH="$ORIG_LD_RUN_PATH"
    PKG_CONFIG_PATH="$ORIG_PKG_CONFIG_PATH"
  fi
  hash -r
}
if [ "$ORIG_SAVED" != yes ]; then
  # Save pre-configuration paths
  export ORIG_SAVED=yes
  export ORIG_PATH="$PATH"
  export ORIG_C_INCLUDE_PATH="$C_INCLUDE_PATH"
  export ORIG_CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH"
  export ORIG_LIBRARY_PATH="$LIBRARY_PATH"
  export ORIG_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
  export ORIG_LD_RUN_PATH="$LD_LD_RUN_PATH"
  export ORIG_PKG_CONFIG_PATH="$PKG_CONFIG_PATH"
fi
if $_ismac; then
  [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/bin" | cut -f2 | tr '\n' ':')"
  [[ -r "$HOME/.bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/.bin" | cut -f2 | tr '\n' ':')"
else
  [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/bin" | cut -f2 | tr '\n' ':')"
  [[ -r "$HOME/.bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/.bin" | cut -f2 | tr '\n' ':')"
fi

[[ -r "$HOME/.local/bin" ]] && _add_to_path "$HOME/.local/bin"
[[ -r "/urs/sbin" ]] && _add_to_path "/usr/sbin"
[[ -r "/sbin" ]] && _add_to_path "/sbin"
[[ -r "/usr/local/sbin" ]] && _add_to_path "/usr/local/sbin"


# Check this if Make fails
if $_islinux; then
  C_INCLUDE_PATH=$(add ~/.local/include "$C_INCLUDE_PATH")
  CPLUS_INCLUDE_PATH=$(add ~/.local/include "$CPLUS_INCLUDE_PATH")
  LIBRARY_PATH=$(add ~/.local/lib "$LIBRARY_PATH")
  LD_LIBRARY_PATH=$(add ~/.local/lib "$LD_LIBRARY_PATH")
  LD_RUN_PATH=$(add ~/.local/lib "$LD_RUN_PATH")
  if [[ "$(uname -m)" == *64* ]]; then
    LIBRARY_PATH=$(add ~/.local/lib64 "$LIBRARY_PATH")
    LD_LIBRARY_PATH=$(add ~/.local/lib64 "$LD_LIBRARY_PATH")
    LD_RUN_PATH=$(add ~/.local/lib64 "$LD_RUN_PATH")
  else
    LIBRARY_PATH=$(add ~/.local/lib32 "$LIBRARY_PATH")
    LD_LIBRARY_PATH=$(add ~/.local/lib32 "$LD_LIBRARY_PATH")
    LD_RUN_PATH=$(add ~/.local/lib32 "$LD_RUN_PATH")
  fi
  PKG_CONFIG_PATH=$(add ~/.local/lib/pkgconfig "$PKG_CONFIG_PATH")
  export C_INCLUDE_PATH
  export CPLUS_INCLUDE_PATH
  export LIBRARY_PATH
  export LD_LIBRARY_PATH
  export LD_RUN_PATH
  export PKG_CONFIG_PATH
fi

## Agents
if command -v keychain > /dev/null 2>&1; then
    eval $(keychain --eval --quiet)
fi

## Custom Colors
colorscheme() {
  if [[ "$-" == *"i"* ]] && [[ "$TERM" != "dumb" ]]; then
    echo -ne '\e]4;0;#2E3436\a'   # black
    echo -ne '\e]4;1;#CC0000\a'   # red
    echo -ne '\e]4;2;#4E9A06\a'   # green
    echo -ne '\e]4;3;#C4A000\a'   # yellow
    echo -ne '\e]4;4;#3465A4\a'   # blue
    echo -ne '\e]4;5;#75507B\a'   # magenta
    echo -ne '\e]4;6;#06989A\a'   # cyan
    echo -ne '\e]4;7;#BABDB6\a'   # white
    echo -ne '\e]4;8;#555753\a'   # bright black
    echo -ne '\e]4;9;#EF2929\a'   # bright red
    echo -ne '\e]4;10;#8AE234\a'  # bright green
    echo -ne '\e]4;11;#FCE94F\a'  # bright yellow
    echo -ne '\e]4;12;#729FCF\a'  # bright blue
    echo -ne '\e]4;13;#D15CD1\a'  # bright magenta
    echo -ne '\e]4;14;#34E2E2\a'  # bright cyan
    echo -ne '\e]4;15;#EEEEEC\a'  # bright white
    echo -ne '\e]10;#FFFFFF\a'    # default foreground
    echo -ne '\e]11;#1D1F21\a'    # default background
  fi
}
colorscheme

## Functions
source ~/.functions

## Aliases
source ~/.bash_aliases
if [ -e /etc/bash_completion ]; then
  source /etc/bash_completion
fi

if [ -d "$HOME/.asdf" ]; then
   . $HOME/.asdf/asdf.sh
   . $HOME/.asdf/completions/asdf.bash
fi

export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

## Kerberos authentication if available
if [ ! -f "/mnt/keytabs/${USER}.keytab" ]; then
    if [ -x /mnt/keytabs/generate_user_keytab.sh ]; then
        /mnt/keytabs/generate_user_keytab.sh &> /dev/null
    fi
fi

if [ -f "/mnt/keytabs/${USER}.keytab" ]; then
    kinit -kt "/mnt/keytabs/${USER}.keytab ${USER}/$(hostname -f)"
fi

## Any last local overrides
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi
