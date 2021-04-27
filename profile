#############
# Utilities #
#############

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
export FILE="lf"
export TERM="xterm-256color"    # For getting proper colors
export EDITOR="emacsclient -t -a ''"      # $EDITOR use Emacs in terminal
export VISUAL="emacsclient -c -a emacs"   # $VISUAL use Emacs in GUI mode

### CHANGE TITLE OF TERMINALS
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

######
# Go #
######
export GOBIN="$HOME/go/bin"
export PATH="$GOBIN:$HOME/.cargo/bin:$PATH"

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
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

# This is the list for lf icons:
export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
ow=📂:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=🎨:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.tex=📜:\
*.md=📘:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.flac=🎼:\
*.wav=🎼:\
*.mkv=🎥:\
*.mp4=🎥:\
*.webm=🎥:\
*.mpeg=🎥:\
*.avi=🎥:\
*.mov=🎥:\
*.mpg=🎥:\
*.wmv=🎥:\
*.m4b=🎥:\
*.flv=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.iso=📀:\
*.img=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
*.jar=♨:\
*.java=♨:\
"

[ ! -f ${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc ] && shortcuts >/dev/null 2>&1 &

#
# Language
#
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

#
# Python
#

# Set the default environment directory for virtualenvwrapper.
export WORKON_HOME="$HOME/.virtualenvs"

### ARCHIVE EXTRACTION
# usage: ex <file>
ex()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function findCurrentOSType()
{
    echo "Finding the current os type"
    echo
    osType=$(uname)
    case "$osType" in
            "Darwin")
            {
                echo "Running on Mac OSX."
                CURRENT_OS="OSX"
            } ;;
            "Linux")
            {
                # If available, use LSB to identify distribution
                if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
                    DISTRO=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
                else
                    DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
                fi
                CURRENT_OS=$(echo $DISTRO | tr 'a-z' 'A-Z')
            } ;;
            *)
            {
                echo "Unsupported OS, exiting"
                exit
            } ;;
    esac
}

### SOURCING BROOT ###
#source $HOME/.config/broot/launcher/bash/br

### BASH INSULTER ###
if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi
