#
# Utilities
#

# is $1 installed?
_have() { which "$1" &>/dev/null; }

# Detect which platform we are on
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_ismac=false
[[ "$(uname -s)" =~ Darwin ]] && _ismac=true

_isubuntu=false
[[ "$(uname -v)" =~ Ubuntu ]] && _isubuntu=true
_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

# Detect if gui is running
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

#
# Path
#
if $_ismac; then
  [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/bin" | cut -f2 | tr '\n' ':')"
  [[ -r "$HOME/.bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/.bin" | cut -f2 | tr '\n' ':')"
else
    [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/bin" | cut -f2 | tr '\n' ':')"
    [[ -r "$HOME/.local/bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/.local/bin" | cut -f2 | tr '\n' ':')"
fi
#
# Terminal
#

export TERMINAL='st'

#
# Editors
#
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export BROWSER="firefox"
export READER="zathura"
export FILE="vifm"

#
# DPI
#
if [ -e ~/.dpi ]; then
  source ~/.dpi
fi

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"; a="${a%_}"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"; a="${a%_}"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; a="${a%_}"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"; a="${a%_}"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"; a="${a%_}"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"; a="${a%_}"

#
# Language
#
export LANG='en_US.UTF-8'

#
# Temporary Files
#
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

#
# Python
#

# Set the default environment directory for virtualenvwrapper.
export WORKON_HOME="$HOME/.virtualenvs"

# Set the default project directory for virtualenvwrapper.
#export PROJECT_HOME="$HOME/projects"

# Load virtualenvwrapper (lazy).
#source /usr/bin/virtualenvwrapper_lazy.sh

#
# Notes
#

# Set the default note directory.
export NOTEDIR=~/library/notes

# Open spreadsheet notes in visidata
export NOTEXDGEXT="csv tsv"

#
# Journal
#

# Set the default journal directory.
export JOURNALDIR=~/library/journal

#
# Passwords
#

# Set the alternative pass directory.
export ALTPASSDIR=~/projects/tad/pass

# Set the access pass directory.
export ACCESSPASSDIR=~/projects/tad/access

# Set the finance pass directory.
export FINPASSDIR=~/library/finance

#
# Misc
#

# Set the dmenu font.
#export DMENU_OPTIONS="-fn -inconsolata-medium-r-*-*-14-*"

# Source credentials.
if [ -f ~/.keys/creds.sh ]; then
    source ~/.keys/creds.sh
fi

# Disable QT5 DPI scaling
export QT_AUTO_SCREEN_SCALE_FACTOR=0

# Set GPG TTY
export GPG_TTY=$(tty)

# Contain the toxic JavaScript ecosystem.
