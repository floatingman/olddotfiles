# ~/.bashrc
# Daniel Newman 2014
#
# an attempt at a monolithic/portable bashrc
# taken from pbrisbin and helmuthdu and other sources
#
###

# get out if non-interactive
[[ $- != *i* ]] && return

### General options {{{

# is $1 installed?
_have() { which "$1" &>/dev/null; }

_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true

_isubuntu=false
[[ "$(uname -v)" =~ Ubuntu ]] && _isubuntu=true
_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

# }}}
## PS1 CONFIG {{{
[[ -f $HOME/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)
if $_isxrunning; then
  [[ -f $HOME/.dircolors_256 ]] && eval $(dircolors -b $HOME/.dircolors_256)

  export TERM='xterm-256color'

  B='\[\e[1;38;5;33m\]'
  LB='\[\e[1;38;5;81m\]'
  GY='\[\e[1;38;5;242m\]'
  G='\[\e[1;38;5;82m\]'
  P='\[\e[1;38;5;161m\]'
  PP='\[\e[1;38;5;93m\]'
  R='\[\e[1;38;5;196m\]'
  Y='\[\e[1;38;5;214m\]'
  W='\[\e[0m\]'

else
  export TERM='xterm-color'
fi

## set xterm for tmux
[ -z "$TMUX" ] && export TERM=xterm-256color

# Using bash-git-prompt to set prompt
  source ~/.bash-git-prompt/gitprompt.sh
  GIT_PROMPT_ONLY_IN_REPO=1
  #}}}

  ## BASH OPTIONS {{{
  # bash 4 features
  if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar autocd dirspell
  fi

  shopt -s cdspell extglob histverify no_empty_cmd_completion checkwinsize


  HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd*"
  HISTCONTROL="ignoreboth:erasedups"
  HISTSIZE=1000000
  HISTFILESIZE=1000000
  shopt -s histappend
  export ${!HIST@}
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

  #Composer
  if [[ -f /home/dnewman/.bin/composer ]]; then
    export PATH=/home/dnewman/.composer/vendor/bin/:$PATH
  fi

  if [[ -f "$HOME/.lscolors" ]] && [[ $(tput colors) == "256" ]]; then
    # https://github.com/trapd00r/LS_COLORS
    _have dircolors && eval $( dircolors -b $HOME/.lscolors )
  fi

  #GO Language
  if [[ -r "$HOME/golang" ]]; then
    export GOPATH=$HOME/golang
  fi
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

  ### Added by the Heroku Toolbelt
  export PATH="/usr/local/heroku/bin:$PATH"
  # should've done this a long time ago
  set -o vi

  # list of apps to be tried in order
  xbrowsers='google-chrome-stable'
  browsers='elinks:lynx:links:w3m'
  editors='emacs -nw'
  export TERMINAL=terminator
  # }}}
  VBOX_USB=usbfs
  ### Overall conditionals/functions {{{
  # set $EDITOR
  _set_editor() {
    local IFS=':' editor

    for editor in $editors; do
      editor="$(which $editor 2>/dev/null)"

      if [[ -x "$editor" ]]; then
        export EDITOR="$editor"
        export VISUAL="$EDITOR"
        break
      fi
    done
  }

  # set $BROWSER
  _set_browser() {
    local IFS=':' _browsers="$*" browser

    for browser in $_browsers; do
      browser="$(which $browser 2>/dev/null)"

      if [[ -x "$browser" ]]; then
        export BROWSER="$browser"
        break
      fi
    done
  }

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


  ### Bash exports {{{

  # set path
  _add_to_path "$HOME/.bin"

  _add_to_path "$HOME/bin"

  # Node
  _add_to_path "$HOME/node_modules/.bin"

  # Haskell
  _add_to_path "$HOME/.cabal/bin"

  #misc apps
  _add_to_path "$HOME/apps"

  _add_to_path ${GOPATH//://bin:}/bin

  # if eclipse is installed
  [[ -f "$HOME/apps/eclipse/eclipse" ]] && _add_to_path "$HOME/apps/eclipse"

  # if intellij is installed
  [[ -f "$HOME/apps/intellij/bin/idea.sh" ]] && _add_to_path "$HOME/apps/intellij/bin"

  # set browser
  $_isxrunning && _set_browser "$xbrowsers" || _set_browser "$browsers"

  #bash autojump
  if $_isarch; then
    . /etc/profile.d/autojump.bash
  else
  . /usr/share/autojump/autojump.sh
  fi

  # set editor
  _set_editor


  # custom ip var
  [[ -f "$HOME/.myip" ]] && export MYIP=$(cat "$HOME/.myip")

  # custom log directory
  [[ -d "$HOME/.logs" ]] && export LOGS="$HOME/.logs" || export LOGS='/tmp'

  # screen tricks
  _source "$HOME/.screen/bashrc.screen"

  # raw AWS keys stored and exported in separate file
  _source "$HOME/.aws_keys"

  # docker options
  if _have docker; then

    # Kill all running containers
    alias dockerkillall='docker kill $(docker ps -q)'

    # Delete all stopped containers.
    alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

    # Delete all untagged images.
    alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

    # Delete all stopped conatiners and untagged images.
    alias dockerclean='dockercleanc || true && dockercleani'
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
    LESS_TERMCAP_md=$'\e[01;31m'
    LESS_TERMCAP_me=$'\e[0m'
    LESS_TERMCAP_se=$'\e[0m'
    LESS_TERMCAP_so=$'\e[01;44;33m'
    LESS_TERMCAP_ue=$'\e[0m'
    LESS_TERMCAP_us=$'\e[01;32m'
    export ${!LESS@}
  fi

  if _have mpc; then
    export MPD_HOST=192.168.0.2
    export MPD_PORT=6600
  fi
  # }}}

  ### Bash aliases {{{
  if _have youtube-dl; then
    alias ytwl='youtube-dl -o "/mnt/SuperBigMama/Media/Video/YouTube/%(uploader)s-%(title)s.%(ext)s" https://www.youtube.com/playlist?list=WL'
    alias podcast='youtube-dl --verbose -x --audio-format mp3 --audio-quality 0 -o "/mnt/SuperBigMama/Media/Audio/podcast/%(uploader)s-%(upload_date)s-%(title)s.%(ext)s" https://www.youtube.com/playlist?list=PL5D8rBmak6B39tevwhz_LMTrEof7MeyQt'
  fi

 alias tigervncserver='x0vncserver --Geometry=1440x900 -display :0 -passwordfile ~/.vnc/passwd'

  if _have rtorrent; then
    alias rtunlock="rm -f /mnt/Extra2/mediadownload/torrents/session/rtorrent.lock"
  fi

  alias blankoff='xset -dpms; xset s off'
  alias blankon='xset dpms; xset s on'
  # emacs
  alias emacs='TERM=xterm-256color /usr/bin/emacs -nw'
  alias ec='emacsclient'

  function ekill() { emacsclient -e '(kill-emacs)';}

  # git alias
  alias gcl='git clone'
  alias ga='git add'
  alias gall='git add .'
  alias gus='git reset HEAD'
  alias gm="git merge"
  alias g='git'
  alias get='git'
  alias gst='git status'
  alias gs='git status'
  alias gss='git status -s'
  alias gl='git pull'
  alias gpr='git pull --rebase'
  alias gpp='git pull && git push'
  alias gup='git fetch && git rebase'
  alias gp='git push'
  alias gpo='git push origin'
  alias gdv='git diff -w "$@" | vim -R -'
  alias gc='git commit -v'
  alias gca='git commit -v -a'
  alias gcm='git commit -v -m'
  alias gci='git commit --interactive'
  alias gb='git branch'
  alias gba='git branch -a'
  alias gcount='git shortlog -sn'
  alias gcp='git cherry-pick'
  alias gco='git checkout'
  alias gexport='git archive --format zip --output'
  alias gdel='git branch -D'
  alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
  alias gll='git log --graph --pretty=oneline --abbrev-commit'
  alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
  alias ggs="gg --stat"
  alias gsl="git shortlog -sn"
  alias gw="git whatchanged"
  alias gd='git diff | vim -R -'

  #vagrant
  alias vup="vagrant up"
  alias vh="vagrant halt"
  alias vs="vagrant suspend"
  alias vr="vagrant resume"
  alias vrl="vagrant reload"
  alias vssh="vagrant ssh"
  alias vst="vagrant status"
  alias vp="vagrant provision"
  alias vdstr="vagrant destroy"
  # requires vagrant-list plugin
  alias vl="vagrant list"
  # requires vagrant-hostmanager plugin
  alias vhst="vagrant hostmanager"

  # ssh
  alias sql='mysql -p -u root'
  alias mybook='ssh dnewman@mybook'
  alias myrouter='ssh root@192.168.0.1'
  #alias shockwave='ssh dnewman@thenewmans.no-ip.org -p2222'

  alias vnc='x11vnc -display :0 -forever -noxdamage -usepw -httpdir /usr/share/vnc-java/ -httpport 5800 &'
  alias lisp='/usr/bin/sbcl'

  #update dotfiles
  if [ -d "$HOME/.dotfiles" ]; then
    alias ud='cd $HOME/.dotfiles && git pull origin master && rcup -v && cd -'
  fi

  # only for linux
  if $_islinux; then
    alias dir='dir --color'
    alias ls='ls -h --group-directories-first --color=auto'


  else
    alias ls='ls -h'
  fi

  # standard
  alias la='ls -la'
  alias ll='ls -l'
  alias lr='ls -R'
  alias laa='ls --color=auto -la'
  alias lx='ll -BX'                   # sort by extension
  alias lz='ll -rS'                   # sort by size
  alias lt='ll -rt'                   # sort by date
  alias li="ls -li | sort -n | more" #lists all files with their inode numbers
  alias lm="ls -al | more" #lists your files a screen at a time
  alias l.="ls -d .* --color=auto"  #list all hidden files and directories
  alias usage="du -skc * | sort -rn | more" #lists the sizes in blocks of all your files and sorts them in size order
  alias total="du -ch | grep total" #find total size of directory and subdirectories
  alias lsDir='ls -d */' #lisitng directories only
  alias again="vim `ls -t | head -1`"
  alias fixdirs="find . -type d -exec chmod o-rwx {} \;"
  alias prev='ls -t | head -l'
  alias findbig="find . -type f -exec ls -s {} \; | sort -n -r | head -5"
  # safety features
  alias cp='cp -i'
  alias mv='mv -i'
  alias rm='rm -I --preserve-root'
  alias ln='ln -i'
  alias chown='chown --preserve-root'
  alias chmod='chmod --preserve-root'
  alias chgrp='chgrp --preserve-root'

  alias bc='bc -l' # start calculator with math support
  alias sha1='openssl sha1' # generate sha1 digest
  alias ports='netstat -tulanp' # show open ports

  #default interfaces for network commands
  alias ednstop='dnstop -l 5 eth0'
  alias evnstat='vnstat -i eth0'
  alias eiftop='iftop -i eth0'
  alias etcpdump='tpdump -i eth0'
  alias ethtool='ethtool eth0'

  alias iwconfig='iwconfig wlan0'

  alias locate='locate -e -L'
  alias mkdir='mkdir -pv'
  alias tree='tree -L 2 -d -l'
  alias tree2="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
  alias up="cd .."
  alias cd..='cd ..'
  alias ..='cd ..'
  alias ...='cd ../../../'
  alias ....='cd ../../../../'
  alias .....='cd ../../../../../'
  alias .4='cd ../../../../'
  alias .5='cd ../../../../../'
  alias diff='colordiff'
  alias mount='mount |column -t'
  alias c='clear'
  alias h='history'
  alias j='jobs -l'
  alias now='date +"%T"'
  alias nowtime=now
  alias nowdate='date +"%d-%m-%Y"'
  alias ping='ping -c 5'
  alias fastping='ping -c 100 -s.2'

  alias ducks="du -cks * |sort -rn |head -10" # print top 10 largest files in pwd
  alias free="free -m"                        # show sizes in MB
  alias sps="ps aux | grep -v grep | grep"    # search and display processes by keyword

  alias df='df -h'
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias mkdir='mkdir -p'
  alias myip='printf "%s\n" "$(curl --silent http://tnx.nl/ip)"'
  alias path='echo -e "${PATH//:/\n}"'
  alias reload='source ~/.bashrc'
  alias ruler="echo .........1.........2.........3.........4.........5.........6.........7.........8"
  alias psm="echo '%CPU %MEM   PID COMMAND' && ps hgaxo %cpu,%mem,pid,comm | sort -nrk1 | head -n 10 | sed -e 's/-bin//' | sed -e 's/-media-play//'"
  alias blankcd="wodim -v dev=/dev/cdrw -blank=fast -eject"
  # a good overview of a yesod application
  alias apptree='tree -I "dist|config|static|pandoc|tmp"'

  # setup dual-montiors when plugged in
  alias dual='xrandr --output LVDS-0 --auto --output HDMI-0 --auto --right-of LVDS-0'


  # only if we have mpc
  if _have mpc; then
    alias addall='mpc --no-status clear && mpc listall | mpc --no-status add && mpc play'
    alias n='mpc next'
    alias p='mpc prev'
  fi

  _have albumbler && alias a='albumbler'

  if _have colortail; then
    alias tailirc='/usr/bin/colortail -q -k /etc/colortail/conf.irc'
    alias colortail='colortail -q -k /etc/colortail/conf.messages'
  fi



  # only if we have a disc drive
  if [[ -b '/dev/sr0' ]]; then
    alias eject='eject -T /dev/sr0'
    alias mountdvd='sudo mount -t iso9660 -o ro /dev/sr0 /media/dvd/'
    alias backupdvd='dvdbackup -M -i /dev/sr0 -o ~/ripped/'
  fi

  # only if we have xmonad
  [[ -f "$HOME/.xmonad/xmonad.hs" ]] && alias checkmonad='(cd ~/.xmonad && ghci -ilib xmonad.hs)'

  # only for mplayer
  if _have mplayer; then
    alias playiso='mplayer dvd://1 -dvd-device'
    alias playdvd='mplayer dvdnav:// /dev/sr0'
    alias playcda='mplayer cdda:// -cdrom-device /dev/sr0 -cache 10000'
  fi

  # mount an iso
  function mountiso() { sudo mount -t iso9660 -o loop "$@" /media/iso ;}


  alias silent='echo "silent" | sudo tee /sys/devices/platform/sony-laptop/thermal_control'
  alias balanced='echo "balanced" | sudo tee /sys/devices/platform/sony-laptop/thermal_control'
  alias performance='echo "performance" | sudo tee /sys/devices/platform/sony-laptop/thermal_control'

# root aliases
if ! $_isroot; then
  alias svim='sudo vim'
  alias reboot='sudo reboot'
  alias shutdown='sudo shutdown -hP now'
  alias scat='sudo cat'
  alias root='sudo su'
  alias windows='sudo grub-set-default 3 && sudo reboot'
  alias bb="sudo bleachbit --clean system.cache system.localizations system.trash system.tmp"
fi

# ubuntu aliases
if $_isubuntu; then
  if ! $_isroot; then
    alias upgrade='sudo apt-get update && sudo apt-get upgrade -y'
    alias apt='sudo apt'
  fi
fi

# pacman aliases
if $_isarch; then
  if ! $_isroot; then
    _have pacman-color && alias pacman='sudo pacman-color' || alias pacman='sudo pacman'
    _have powerpill && alias powerpill='sudo powerpill'
  else
    _have pacman-color && alias pacman='pacman-color'
  fi

  alias y='LD_PRELOAD= yaourt'
  alias yaourt='LD_PRELOAD= yaourt'
  alias upgrade='yaourt -Syu --aur --devel && sudo pacdiffviewer && cd /etc/ && sudo etckeeper commit "Auto Commit"; cd -'
  alias pacorphans='pacman -Rs $(pacman -Qtdq)'
  alias paccorrupt='sudo find /var/cache/pacman/pkg -name '\''*.part.*'\''' # sudo so we can quickly add -delete
  alias pactesting='pacman -Q $(pacman -Sql {community-,multilib-,}testing) 2>/dev/null'
  alias remove='sudo pacman -Rsc'
  alias pacin='pacman -S'
  alias pacout='pacman -R'
  alias pacsearch='pacman -Ss'
  alias pacup='pacup.rb && sudo pacman -Suy'
  alias upp='sudo reflector -c "United States" -a 1 -f 3 --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman -Syyu'
  # Pacman alias examples
  alias pacupg='sudo pacman -Syu'		# Synchronize with repositories and then upgrade packages that are out of date on the local system.
  alias pacdl='pacman -Sw'		# Download specified package(s) as .tar.xz ball
  alias pacin='sudo pacman -S'		# Install specific package(s) from the repositories
  alias pacins='sudo pacman -U'		# Install specific package not from the repositories but from a file
  alias pacre='sudo pacman -R'		# Remove the specified package(s), retaining its configuration(s) and required dependencies
  alias pacrem='sudo pacman -Rns'     	# Remove the specified package(s), its configuration(s) and unneeded dependencies
  alias pacrep='pacman -Si'		# Display information about a given package in the repositories
  alias pacreps='pacman -Ss'		# Search for package(s) in the repositories
  alias pacloc='pacman -Qi'		# Display information about a given package in the local database
  alias paclocs='pacman -Qs'		# Search for package(s) in the local database
  alias paclo="pacman -Qdt"		# List all packages which are orphaned
  alias pacc="sudo pacman -Scc"		# Clean cache - delete all the package files in the cache
  alias paclf="pacman -Ql"		# List all files installed by a given package
  alias pacown="pacman -Qo"		# Show package(s) owning the specified file(s)
  alias pacexpl="pacman -D --asexp"	# Mark one or more installed packages as explicitly installed
  alias pacimpl="pacman -D --asdep"	# Mark one or more installed packages as non explicitly installed

  # Additional pacman alias examples
  alias pacupd='sudo pacman -Sy && sudo abs'         # Update and refresh the local package and ABS databases against repositories
  alias pacinsd='sudo pacman -S --asdeps'            # Install given package(s) as dependencies
  alias pacmir='sudo pacman -Syy'                    # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

  # dealing with the following message from pacman:
  #
  #     error: couldnt lock database: file exists
  #     if you are sure a package manager is not already running, you can remove /var/lib/pacman/db.lck

  alias pacunlock="sudo rm /var/lib/pacman/db.lck"   # Delete the lock file /var/lib/pacman/db.lck
  alias paclock="sudo touch /var/lib/pacman/db.lck"  # Create the lock file /var/lib/pacman/db.lck

  # Show directory not owned by any package
  alias pacman-disowned-dirs="comm -23 <(sudo find / \( -path '/dev' -o -path '/sys' -o -path '/run' -o -path '/tmp' -o -path '/mnt' -o -path '/srv' -o -path '/proc' -o -path '/boot' -o -path '/home' -o -path '/root' -o -path '/media' -o -path '/var/lib/pacman' -o -path '/var/cache/pacman' \) -prune -o -type d -print | sed 's/\([^/]\)$/\1\//' | sort -u) <(pacman -Qlq | sort -u)"

  # Show files not owned by any packages
  alias pacman-disowned-files="comm -23 <(sudo find / \( -path '/dev' -o -path '/sys' -o -path '/run' -o -path '/tmp' -o -path '/mnt' -o -path '/srv' -o -path '/proc' -o -path '/boot' -o -path '/home' -o -path '/root' -o -path '/media' -o -path '/var/lib/pacman' -o -path '/var/cache/pacman' \) -prune -o -type f -print | sort -u) <(pacman -Qlq | sort -u)"


fi
# ghc aliases
if _have ghc-pkg; then
  alias gc='ghc-pkg check'
  alias gl='ghc-pkg list'
  alias gu='ghc-pkg unregister'
fi

# }}}

# iptables
alias ipt='sudo /sbin/iptables'

# display all rules
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# Debugging web servers
# get web server headers
alias header='curl -I'

# find out if remote server supports gzip or mod_deflate
alias headerc='curl -I --compress'

# get computer stats asap
alias meminfo='free -m -l -t'

#get top processes eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

#get top processes eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

#get cpu info
alias cpuinfo='lscpu'

#get GPU ram
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# resume wget downloads by default
alias wget='wget -c'

alias top='atop'

# ruby rvm veewee
alias veewee='bundle exec veewee'
### Bash functions {{{

# demolish any --user installed cabal packages.
cabalwipe() {
  rm -rf "$HOME/.cabal/packages"/*/*
  rm -rf "$HOME/.cabal/bin"/*
  rm -rf "$HOME/.ghc"
}

# filegrep 'foo.*' ./some/dir, greps all files in the given dir for the
# given regex
filegrep() {
  local dir="$2" regex="$1"
  find "$dir" -type f ! -wholename '*/.svn/*' ! -wholename '*/.git/*' -exec grep --color=auto -- "$regex" {} \+
}

# combine pdfs into one using ghostscript
combinepdf() {
  _have gs       || return 1
  [[ $# -ge 2 ]] || return 1

  local out="$1"; shift

  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$out" "$@"
}

# add by artist to mpc
addartist() {
  _have mpc || return 1

  mpc search artist "$*" | mpc add &>/dev/null
  mpc play
}

# make a thumb %20 the size of a pic
thumbit() {
  _have mogrify || return 1

  for pic; do
    case "$pic" in
      *.jpg)  thumb="${pic/.jpg/-thumb.jpg}"   ;;
      *.jpeg) thumb="${pic/.jpeg/-thumb.jpeg}" ;;
      *.png)  thumb="${pic/.png/-thumb.png}"   ;;
      *.bmp)  thumb="${pic/.bmp/-thumb.bmp}"   ;;
    esac

    [[ -z "$thumb" ]] && return 1

    cp "$pic" "$thumb" && mogrify -resize 10% "$thumb"
  done
}

# rip a dvd with handbrake
hbrip() {
  _have HandBrakeCLI || return 1
  [[ -n "$1" ]]      || return 1

  local name="$1" out drop="$HOME/Videos"; shift
  [[ -d "$drop" ]] || mkdir -p "$drop"

  out="$drop/$name.m4v"

  echo "rip /dev/sr0 --> $out"
  HandBrakeCLI --main-feature -m -s scan -F -N eng -Z High Profile "$@" -i /dev/sr0 -o "$out" 2>/dev/null
  echo
}

# convert media to ipad format with handbrake
hbconvert() {
  _have HandBrakeCLI || return 1
  [[ -n "$1" ]]      || return 1

  local in="$1" out drop="$HOME/Videos/converted"; shift
  [[ -d "$drop" ]] || mkdir -p "$drop"

  out="$drop/$(basename "${in%.*}").mp4"

  echo "convert $in --> $out"
  HandBrakeCLI -Z iPad "$@" -i "$in" -o "$out" 2>/dev/null
  echo
}

# simple spellchecker, uses /usr/share/dict/words
spellcheck() {
  [[ -f /usr/share/dict/words ]] || return 1

  for word; do
    if grep -Fqx "$word" /usr/share/dict/words; then
      echo -e "\e[1;32m$word\e[0m" # green
    else
      echo -e "\e[1;31m$word\e[0m" # red
    fi
  done
}

# go to google for anything
google() {
  [[ -z "$BROWSER" ]] && return 1

  local term="${*:-$(xclip -o)}"

  $BROWSER "http://www.google.com/search?q=${term// /+}" &>/dev/null &
}

# go to google for a definition
define() {
  _have w3m     || return 1
  _have mplayer || return 1

  local word="$*"

  w3m -dump "http://www.google.ca/search?q=define%20${word// /_}" | awk '/^     1./,/^        More info >>/'
  mplayer "http://ssl.gstatic.com/dictionary/static/sounds/de/0/${word// /_}.mp3" &>/dev/null
}

# grep by paragraph
grepp() { perl -00ne "print if /$1/i" < "$2"; }

# pull a single file out of an achive, stops on first match. useful for
# .PKGINFO files in .pkg.tar.[gx]z files.
pullout() {
  _have bsdtar || return 1

  local opt

  case "$2" in
    *gz) opt='-qxzf' ;;
    *xz) opt='-qxJf' ;;
    *)   return 1    ;;
  esac

  bsdtar $opt "$2" "$1"
}

# recursively 'fix' dir/file perm
fix() {
  local dir

  for dir; do
    find "$dir" -type d -exec chmod 755 {} \;
    find "$dir" -type f -exec chmod 644 {} \;
  done
}

# print docs to default printer in reverse page order
printr() {
  _have enscript || return 1

  # stdin?
  if [[ -z "$*" ]]; then
    cat | enscript -p - | psselect -r | lp
    return 0
  fi

  local file

  for file; do
    enscript -p - "$file" | psselect -r | lp
  done
}

# set an ad-hoc GUI timer
timer() {
  $_isxrunning || return 1
  _have zenity || return 1

  local N="${1:-5m}"; shift

  (sleep $N && zenity --info --title="Time's Up" --text="${*:-DING}") &
  echo "timer set for $N"
}

# send an attachment from CLI
send() {
  _have mutt    || return 1
  [[ -f "$1" ]] || return 1
  [[ -z "$2" ]] || return 1

  echo 'Please see attached.' | mutt -s "File: $1" -a "$1" -- "$2"
}

# run a bash script in 'debug' mode
debug() {
  local script="$1"; shift

  if _have "$script"; then
    PS4='+$LINENO:$FUNCNAME: ' bash -x "$script" "$@"
  fi
}

# go to a directory or file's parent
goto() { [[ -d "$1" ]] && cd "$1" || cd "$(dirname "$1")"; }

# copy and follow
cpf() { cp "$@" && goto "$_"; }

# move and follow
mvf() { mv "$@" && goto "$_"; }

# print the url to a manpage
webman() { echo "http://unixhelp.ed.ac.uk/CGI/man-cgi?$1"; }

# }}}

# extract - archive extractor
# usage: extract <file>
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1" ;;
      *.tar.gz) tar xvzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xvf "$1" ;;
      *.tbz2) tar xvjf "$1" ;;
      *.tgz) tar xvzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *)
        echo "$1 is not a valid archive"
        return 1
        ;;
    esac
  else
    echo "$1 is not a valid file"
    return 1
  fi
  return 0
}


# }}}

