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

  get_prompt_symbol() {
    [[ $UID == 0 ]] && echo "#" || echo "\$"
  }

  get_git_branch() {
    # On branches, this will return the branch name
    # On non-branches, (no branch)
    ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
    [[ -n $ref ]] && echo "$ref" || echo "(no branch)"
  }

  is_branch1_behind_branch2 () {
    # Find the first log (if any) that is in branch1 but not branch2
    first_log="$(git log $1..$2 -1 2> /dev/null)"
    # Exit with 0 if there is a first log, 1 if there is not
    [[ -n "$first_log" ]]
  }

  branch_exists () {
    # List remote branches | # Find our branch and exit with 0 or 1 if found/not found
    git branch --remote 2> /dev/null | grep --quiet "$1"
  }

  parse_git_ahead () {
    # Grab the local and remote branch
    branch="$(get_git_branch)"
    remote_branch=origin/"$branch"
    # If the remote branch is behind the local branch
    # or it has not been merged into origin (remote branch doesn't exist)
    (is_branch1_behind_branch2 $remote_branch $branch || ! branch_exists $remote_branch) && echo 1
  }

  parse_git_behind () {
    # Grab the branch
    branch=$(get_git_branch)
    remote_branch=origin/$branch
    # If the local branch is behind the remote branch
    is_branch1_behind_branch2 $branch $remote_branch && echo 1
  }

  parse_git_dirty () {
    # If the git status has *any* changes (i.e. dirty)
    [[ -n "$(git status --porcelain 2> /dev/null)" ]] && echo 1
  }

  function get_git_status() {
  # Grab the git dirty and git behind
  dirty_branch="$(parse_git_dirty)"
  branch_ahead="$(parse_git_ahead)"
  branch_behind="$(parse_git_behind)"

  # Iterate through all the cases and if it matches, then echo
  if [[ $dirty_branch == 1 && $branch_ahead == 1 && $branch_behind == 1 ]]; then
    echo "⬢"
  elif [[ $dirty_branch == 1 && $branch_ahead == 1 ]]; then
    echo "▲"
  elif [[ $dirty_branch == 1 && $branch_behind == 1 ]]; then
    echo "▼"
  elif [[ $branch_ahead == 1 && $branch_behind == 1 ]]; then
    echo "⬡"
  elif [[ $branch_ahead == 1 ]]; then
    echo "△"
  elif [[ $branch_behind == 1 ]]; then
    echo "▽"
  elif [[ $dirty_branch == 1 ]]; then
    echo "*"
  fi
}

get_git_info () {
  # Grab the branch
  branch="$(git branch --no-color 2> /dev/null | awk '{print $2}')"
  # If there are any branches
  if [[ -n $branch ]]; then
    # Add on the git status
    output=$(get_git_status)
    # Echo our output
    echo -e -n " $branch$output"
  fi
}

export PS1="$GY[$Y\u$GY@$P\h$GY:$B\W$LB\$(get_git_info)$GY]$W\$(get_prompt_symbol) "
  else
    export TERM='xterm-color'
  fi
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

  #Ruby support
  #if which ruby &>/dev/null; then
  #  GEM_DIR=$(ruby -rubygems -e 'puts Gem.user_dir')/bin
  #  if [[ -d "$GEM_DIR" ]]; then
  #    export PATH=$GEM_DIR:$PATH
  #  fi
  #fi

  #PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

  #}}}

  #RVM stuff

  # RVM bash completion
  [[ -r "$HOME/.rvm/scripts/completion" ]] && source "$HOME/.rvm/scripts/completion"

  if [[ -f "$HOME/.lscolors" ]] && [[ $(tput colors) == "256" ]]; then
    # https://github.com/trapd00r/LS_COLORS
    _have dircolors && eval $( dircolors -b $HOME/.lscolors )
  fi


  # should've done this a long time ago
  set -o vi

  # list of apps to be tried in order
  xbrowsers='firefox:google-chrome'
  browsers='elinks:lynx:links:w3m'
  editors='vim'
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

  # Node
  _add_to_path "$HOME/node_modules/.bin"

  # Haskell
  _add_to_path "$HOME/.cabal/bin"

  #pyroscope and other custom programs
  _add_to_path "$HOME/bin"
  
  # set browser
  $_isxrunning && _set_browser "$xbrowsers" || _set_browser "$browsers"

  #bash autojump
  . /etc/profile.d/autojump.bash

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

  # dmenu options
  if _have dmenu; then
    # dmenu-xft required
    export DMENU_OPTIONS='-i -fn Verdana-8 -nb #303030 -nf #909090 -sb #909090 -sf #303030'
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

  if _have rtorrent; then
    alias rthot="watch -n10 'rtcontrol -rs up,down,name xfer=+0 2>&1'"
    alias rtmsg="rtcontrol -s alias,message,name 'message=?*' message=\!*Tried?all?trackers*"
    alias rtmsgstats="rtcontrol -q -s alias,message -o alias,message 'message=?*' message=\!*Tried?all?trackers* | uniq -c"
    alias rt2days="rtcontrol -scompleted -ocompleted,is_open,up.sz,ratio,alias,name completed=-2d"
    alias rt2months="rtcontrol -scompleted -ocompleted,is_open,up.sz,ratio,alias,name completed=+2m"
  fi

  alias blankoff='xset -dpms; xset s off'
  alias blankon='xset dpms; xset s on'
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
  alias starscreamer='ssh dnewman@starscreamer'
  alias mybook='ssh dnewman@mybook'
  alias myrouter='ssh root@192.168.0.1'
  alias frank='ssh dwnewman@frank.mtsu.edu'
  alias schoollinux='ssh dwnewman@linux.cs.mtsu.edu'
  alias vnc='x11vnc -display :0 -forever -noxdamage -usepw -httpdir /usr/share/vnc-java/ -httpport 5800 &'
  alias lisp='/usr/bin/sbcl'

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

  if _have ossvol; then
    alias u='ossvol -i 3'
    alias d='ossvol -d 3'
    alias m='ossvol -t'
  fi

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

  alias silent='echo "silent" | sudo tee /sys/devices/platform/sony-laptop/thermal_control'
  alias balanced='echo "balanced" | sudo tee /sys/devices/platform/sony-laptop/thermal_control'
  alias performance='echo "performance" | sudo tee /sys/devices/platform/sony-laptop/thermal_control'

  # wipro proxy
  function wiproproxyon() {
  echo -n "username:"
  read -e username
  echo -n "password:"
  read -es password
  export http_proxy="http://$username:$password@proxy4.wipro.com:8080"
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy
  export rsync_proxy=$http_proxy
  export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
  echo -e "\nProxy environment variable set."
}

function wiproproxyoff() {
unset HTTP_PROXY
unset http_proxy
unset HTTPS_PROXY
unset https_proxy
unset FTP_PROXY
unset ftp_proxy
unset RSYNC_PROXY
unset rsync_proxy
echo -e "\nProxy environment variable removed"
}


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
  alias svim='sudo vim'
  alias reboot='sudo reboot'
  alias shutdown='sudo shutdown -hP now'
  alias scat='sudo cat'
  alias root='sudo su'
  alias windows='sudo grub-set-default 3 && sudo reboot'
  alias pacin='pacman -S'
  alias pacout='pacman -R'
  alias pacsearch='pacman -Ss'
  alias pacup='pacup.rb && sudo pacman -Suy'
  alias bb="sudo bleachbit --clean system.cache system.localizations system.trash system.tmp"
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

### Titlebar and Prompt {{{
#
# /[0]/[1]/[2]/[3]/
#
# 0: % batt remaining (if BAT0 exists)
# 1: host name
# 2: last exit status
# 3: git/svn summary or current directory
#
###

# colors setup {{{

# element colors
batt_color=WHITE
batt_med_color=YELLOW
batt_low_color=RED
host_color=WHITE
dir_color=WHITE
retval_color=WHITE
retval_nonzero_color=MAGENTA
sep_color=BLUE
root_sep_color=RED

# vcs colors
init_vcs_color=white
clean_vcs_color=white
modified_vcs_color=magenta
added_vcs_color=green
addmoded_vcs_color=yellow
untracked_vcs_color=cyan
op_vcs_color=magenta
detached_vcs_color=red
hex_vcs_color=white

# term color codes
black='\['`tput sgr0; tput setaf 0`'\]'
red='\['`tput sgr0; tput setaf 1`'\]'
green='\['`tput sgr0; tput setaf 2`'\]'
yellow='\['`tput sgr0; tput setaf 3`'\]'
blue='\['`tput sgr0; tput setaf 4`'\]'
magenta='\['`tput sgr0; tput setaf 5`'\]'
cyan='\['`tput sgr0; tput setaf 6`'\]'
white='\['`tput sgr0; tput setaf 7`'\]'

BLACK='\['`tput setaf 0; tput bold`'\]'
RED='\['`tput setaf 1; tput bold`'\]'
GREEN='\['`tput setaf 2; tput bold`'\]'
YELLOW='\['`tput setaf 3; tput bold`'\]'
BLUE='\['`tput setaf 4; tput bold`'\]'
MAGENTA='\['`tput setaf 5; tput bold`'\]'
CYAN='\['`tput setaf 6; tput bold`'\]'
WHITE='\['`tput setaf 7; tput bold`'\]'

colors_reset='\['`tput sgr0`'\]'

# replace symbolic colors names to raw terminfo strings
batt_color=${!batt_color}
batt_med_color=${!batt_med_color}
batt_low_color=${!batt_low_color}
host_color=${!host_color}
dir_color=${!dir_color}
retval_color=${!retval_color}
retval_nonzero_color=${!retval_nonzero_color}
sep_color=${!sep_color}
root_sep_color=${!root_sep_color}

init_vcs_color=${!init_vcs_color}
modified_vcs_color=${!modified_vcs_color}
untracked_vcs_color=${!untracked_vcs_color}
clean_vcs_color=${!clean_vcs_color}
added_vcs_color=${!added_vcs_color}
op_vcs_color=${!op_vcs_color}
addmoded_vcs_color=${!addmoded_vcs_color}
detached_vcs_color=${!detached_vcs_color}
hex_vcs_color=${!hex_vcs_color}

# }}}

_update_title() { # {{{
  case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*) echo -en "\033]0;${PWD/$HOME/~}\007" ;;
  esac
}
#}}}

_battery_info() { # {{{
  local bat='/sys/class/power_supply/BAT0' batt_level _batt_color

  unset batt_info

  if [[ -d "$bat" ]]; then
    rem=$(cat "$bat/energy_now")
    max=$(cat "$bat/energy_full")
    batt_level=`awk 'BEGIN{printf("%d", '$rem' / '$max' * 100)}'`
    # set color based on level
    if [[ batt_level -le 10 ]]; then
      _batt_color=$batt_low_color
    elif [[ $batt_level -le 30 ]]; then
      _batt_color=$batt_med_color
    else
      _batt_color=$batt_color
    fi

    batt_info="${batt_color}~${_batt_color}${batt_level}${batt_color}%${colors_reset}"
  fi
}
# }}}

# a simplification on http://volnitsky.com/project/git-prompt/ {{{
_parse_git_status() {
  local git_dir file_regex added_files modified_files untracked_files file_list
  local freshness clean init added modified untracked detached
  local op rawhex branch vcs_info status vcs_color

  unset git_info

  git_dir="$(git rev-parse --git-dir 2> /dev/null)"

  if [[ -n ${git_dir/./} ]]; then
    file_regex='\([^/ ]*\/\{0,1\}\).*'
    added_files=()
    modified_files=()
    untracked_files=()

    eval "$(
    git status 2>/dev/null |
    sed -n '
    s/^# On branch /branch=/p
    s/^nothing to commi.*/clean=clean/p
    s/^# Initial commi.*/init=init/p

    s/^# Your branch is ahead of .[/[:alnum:]]\+. by [[:digit:]]\+ commit.*/freshness=\" ${WHITE}↑\"/p
    s/^# Your branch is behind .[/[:alnum:]]\+. by [[:digit:]]\+ commit.*/  freshness=\" ${YELLOW}↓\"/p
    s/^# Your branch and .[/[:alnum:]]\+. have diverged.*/freshness=${YELLOW}↕/p

    /^# Changes to be committed:/,/^# [A-Z]/ {
    s/^# Changes to be committed:/added=added;/p
    s/^#	modified:   '"$file_regex"'/    [[ \" ${added_files[*]} \" =~ \" \1 \" ]] || added_files+=(\"\1\")/p
    s/^#	new file:   '"$file_regex"'/    [[ \" ${added_files[*]} \" =~ \" \1 \" ]] || added_files+=(\"\1\")/p
    s/^#	renamed:[^>]*> '"$file_regex"'/ [[ \" ${added_files[*]} \" =~ \" \1 \" ]] || added_files+=(\"\1\")/p
    s/^#	copied:[^>]*> '"$file_regex"'/  [[ \" ${added_files[*]} \" =~ \" \1 \" ]] || added_files+=(\"\1\")/p
  }

  /^# Changed but not updated:/,/^# [A-Z]/ {
  s/^# Changed but not updated:/modified=modified;/p
  s/^#	modified:   '"$file_regex"'/ [[ \" ${modified_files[*]} \" =~ \" \1 \" ]] || modified_files+=(\"\1\")/p
  s/^#	unmerged:   '"$file_regex"'/ [[ \" ${modified_files[*]} \" =~ \" \1 \" ]] || modified_files+=(\"\1\")/p
}

/^# Changes not staged for commit:/,/^# [A-Z]/ {
s/^# Changes not staged for commit:/modified=modified;/p
s/^#	modified:   '"$file_regex"'/ [[ \" ${modified_files[*]} \" =~ \" \1 \" ]] || modified_files+=(\"\1\")/p
s/^#	unmerged:   '"$file_regex"'/ [[ \" ${modified_files[*]} \" =~ \" \1 \" ]] || modified_files+=(\"\1\")/p
      }

      /^# Unmerged paths:/,/^[^#]/ {
      s/^# Unmerged paths:/modified=modified;/p
      s/^#	both modified:\s*'"$file_regex"'/ [[ \" ${modified_files[*]} \" =~ \" \1 \" ]] || modified_files+=(\"\1\")/p
    }

    /^# Untracked files:/,/^[^#]/{
    s/^# Untracked files:/untracked=untracked;/p
    s/^#	'"$file_regex"'/ [[ \" ${untracked_files[*]} ${modified_files[*]} ${added_files[*]} \" =~ \" \1 \" ]] || untracked_files+=(\"\1\")/p
  }
  '
  )"

  grep -q "^ref:" $git_dir/HEAD 2>/dev/null || detached=detached

  if [[ -d "$git_dir/.dotest" ]] ;  then
    if [[ -f "$git_dir/.dotest/rebasing" ]]; then
      op="rebase"
    elif [[ -f "$git_dir/.dotest/applying" ]]; then
      op="am"
    else
      op="am/rebase"
    fi
  elif [[ -f "$git_dir/.dotest-merge/interactive" ]]; then
    op="rebase -i"
  elif [[ -d "$git_dir/.dotest-merge" ]]; then
    op="rebase -m"
  elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
    op="merge"
  elif [[ -f "$git_dir/index.lock" ]]; then
    op="locked"
  elif [[ -f "$git_dir/BISECT_LOG" ]]; then
    op="bisect"
  fi

  rawhex=$(git rev-parse HEAD 2>/dev/null)
  rawhex=${rawhex/HEAD/}
  rawhex="$hex_vcs_color${rawhex:0:5}"

  if [[ $init ]]; then
    vcs_info=${white}init
  else
    if [[ "$detached" ]]; then
      branch="<detached:`git name-rev --name-only HEAD 2>/dev/null`"
    elif [[ "$op" ]]; then
      branch="$op:$branch"
      [[ "$op" == 'merge' ]] && branch+="<--$(git name-rev --name-only $(<$git_dir/MERGE_HEAD))"
    fi

    vcs_info="$branch${white}[$rawhex${white}]$fresshness"
  fi

  status=${op:+op}
  status=${status:-$detached}
  status=${status:-$clean}
  status=${status:-$modified}
  status=${status:-$added}
  status=${status:-$untracked}
  status=${status:-$init}
  eval vcs_color="\${${status}_vcs_color}"

  [[ ${added_files[0]}     ]] && file_list+=" $added_vcs_color${added_files[@]}"
  [[ ${modified_files[0]}  ]] && file_list+=" $modified_vcs_color${modified_files[@]}"
  [[ ${untracked_files[0]} ]] && file_list+=" $untracked_vcs_color${untracked_files[@]}"

  # real git info
  git_info="${vcs_color}${vcs_info}${vcs_color}${file_list}${colors_reset}"
fi
}

_parse_svn_status() {
  local repo_dir rev branch vcs_info

  unset svn_info # default

  if [[ -d ./.svn  ]]; then
    eval $(sed -n '
    s@^URL[^/]*//@repo_dir=@p
    s/^Revision: /rev=/p
    ' < <(svn info)
    )

    if [[ "$repo_dir" =~ trunk ]]; then
      branch='trunk'
    elif [[ "$repo_dir" =~ branches/(.*) ]]; then
      branch="${BASH_REMATCH[1]}"
    fi

    vcs_info=svn:$branch:r$rev
    svn_info="${clean_vcs_color}${vcs_info}${colors_reset}"
  fi
}

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

### Starting X {{{

if [[ $(tty) = /dev/tty1 ]] && ! $_isroot && ! $_isxrunning; then
  _set_browser "$xbrowsers"
  #  exec startx
fi

# }}}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#systemctl --user import-environment PATH

# }}}

#prompt_command_function() {
#local retval="$?" _sep_color host_info retval_info ps

## sep changes colors for root
#$_isroot && _sep_color=$root_sep_color || _sep_color=$sep_color

#_battery_info
#_parse_git_status
#_parse_svn_status

#if [[ -n "$git_info" ]]; then
## Git
#vcs_info="$git_info"
#elif [[ -n "$svn_info" ]]; then
## SVN
#vcs_info="$svn_info"
#else
## directory display
#vcs_info="${dir_color}${PWD/$HOME/~}${colors_reset}"
#fi

#host_info="$host_color${HOSTNAME/.local/}"

#if [[ $retval -eq 0 ]]; then
#retval_info="$retval_color$retval"
#else
#retval_info="$retval_nonzero_color$retval"
#fi

## add control characters for screen
#[[ -n "$STY" ]] && ps='\[\ek\e\\\]\[\ek\w\e\\\]' || ps=''

## build that prompt
#ps+="$_sep_color/$batt_info"
#ps+="$_sep_color/$host_info"
#ps+="$_sep_color/$retval_info"
#ps+="$_sep_color/$vcs_info"
#ps+="$_sep_color/ $colors_reset"

#PS1="$ps"
#PS2="$_sep_color// $colors_reset"
#PS3="$_sep_color// $colors_reset"

#_update_title
#}

#unset PROMPT_COMMAND
#PROMPT_COMMAND=prompt_command_function
# }}}

# ssh-agent stuff
#_ssh_env="$HOME/.ssh/environment"

#_start_agent() {
#  [[ -d "$HOME/.ssh" ]] || return 1
#  _have ssh-agent       || return 1

#  local key keyfile

#  ssh-agent | sed 's/^echo/#echo/g' > "$_ssh_env"

#  chmod 600 "$_ssh_env"
#  . "$_ssh_env" >/dev/null

#  for key in id_rsa id_rsa.github; do
#    keyfile="$HOME/.ssh/$key"
#    if [[ -r "$keyfile" ]]; then
#      ssh-add "$keyfile"
#    fi
#  done
#}

#if [[ -f "$_ssh_env" ]]; then
#  . "$_ssh_env" >/dev/null
#  if ! ps "$SSH_AGENT_PID" | grep -q 'ssh-agent$'; then
#    _start_agent
#  fi
#else
#  _start_agent
#fi

### Starting X {{{

if [[ $(tty) = /dev/tty1 ]] && ! $_isroot && ! $_isxrunning; then
  _set_browser "$xbrowsers"
  exec startx
fi

# }}}

# }}}
