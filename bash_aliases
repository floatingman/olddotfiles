## -*- default-directory: "~/.dotfiles/"; -*-

# Misc
alias httpd='screen -S httpd python3 -m http.server 8001' # --bind 127.0.0.1
alias oct='octave-cli -q'
alias sr='screen -dr'
alias tmp='mkdir /tmp/$$ ; cd /tmp/$$'
alias untmp='rm -rf /tmp/$$'
alias hr='printf $(printf "\e[$(shuf -i 91-97 -n 1);1m%%%ds\e[0m\n" $(tput cols)) | tr " " ='
alias sql='sqlite3 -interactive :memory:'
alias writeback='watch -n0.5 grep Writeback: /proc/meminfo'

# Media
alias adump='mpv --untimed -vd=dummy -vo null -ao pcm'
alias m='mpv'
alias ms='mpv --shuffle'
alias npr='mpv http://wamu-1.streamguys.com'

# tmux
if _have tmux; then
    alias t='tmux attach || tmux'
    alias txl='tmux ls'
    alias txn='tmux new -s'
    alias txa='tmux a -t'
fi

if _have youtube-dl; then
    alias ytwlexp='youtube-dl --download-archive /mnt/SuperBig/Media/Video/YouTube/archive.txt --no-mtime --write-sub --sub-lang en_US --mark-watched --embed-subs -o "/mnt/SuperBig/Media/Video/YouTube/%(uploader)s-%(title)s.%(ext)s" https://www.youtube.com/playlist?list=PL5D8rBmak6B01Db6kNoGC7oNwL-nRoOFk'
    alias ytwl='youtube-dl --no-mtime --write-sub --sub-lang en_US --mark-watched --embed-subs -o "/mnt/SuperBig/Media/Video/YouTube/%(uploader)s-%(title)s.%(ext)s" :ytwatchlater'
    alias yt="youtube-dl --add-metadata -i"
    alias yta="yt -x -f bestaudio/best"
    alias YT="youtube-viewer"
    alias podcast='youtube-dl --no-mtime --verbose -x --audio-format mp3 --audio-quality 0 -o "/mnt/SuperBig/Media/Audio/podcast/%(uploader)s-%(upload_date)s-%(title)s.%(ext)s" https://www.youtube.com/playlist?list=PL5D8rBmak6B39tevwhz_LMTrEof7MeyQt'
fi

# emacs
alias em='emacs'
alias en='emacs -nw'
alias et='emacsclient -t'
alias ed='emacs --daemon'
alias ec='emacsclient -c -a emacs'
function ekill() { emacsclient -e '(kill-emacs)';}

# vim
alias e=$EDITOR
alias E='sudo $EDITOR'
alias f="vifm"
if _have nvim; then
  alias vim='nvim'
fi

if _have git; then
  alias gaa='git add -A'
  alias gf='git fetch --all --prune'
  alias gft='git fetch --all --prune --tags'
  alias gfv='git fetch --all --prune --verbose'
  alias gftv='git fetch --all --prune --tags --verbose'
  alias gus='git reset HEAD'
  alias gpristine='git reset --hard && git clean -dfx'
  alias gclean='git clean -fd'
  alias gs='git status'
  alias gss='git status -s'
  alias gsu='git submodule update --init --recursive'
  alias gpr='git pull --rebase'
  alias gpp='git pull && git push'
  alias gup='git fetch && git rebase'
  alias gps='git push'
  alias gpo='git push origin'
  alias gpsf='git push --force'
  alias gd='git diff --color'
  alias gc='git commit -v'
  alias gb='git branch'
  alias gcount='git shortlog -sn'
  alias gcp='git cherry-pick'
  alias gco='git checkout'
  alias gcom='git checkout master'
  alias gcob='git checkout -b'
  alias gexport='git archive --format zip --output'
  alias gll='git log --graph --pretty=oneline --abbrev-commit'
  alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
  alias ggs="gg --stat"
  alias gwc="git whatchanged"
  # From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
  # Show commits since last pull
  alias gnew="git log HEAD@{1}..HEAD@{0}"
  # Add uncommitted and unstaged changes to the last commit
  alias gstd="git stash drop"
  alias gstl="git stash list"
  alias gpl="git pull --rebase --autostash"
  grn() { git rebase -i HEAD~"$1"; }
  alias gh='cd "$(git rev-parse --show-toplevel)"'
  alias cara='git commit --amend --reset-author'
  alias gca='git add --all && git commit --amend --no-edit'
fi

# File and Directory Utilities
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
alias fixvideo="sudo chown -R dnewman /mnt/SuperBig/Media/Video/Movies/ && sudo chown -R dnewman /mnt/SuperBig/Media/Video/TV/"
alias prev='ls -t | head -l'
alias findbig="find . -type f -exec ls -s {} \; | sort -n -r | head -5"
# safety features
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ln='ln -i'
alias tp="fzf --preview 'bat --color \"always\" {}'"
alias rm30='find * -mtime +30 -exec rm {} \;' # remove files older than 30 days
alias r="ranger"
alias sr="sudo ranger"
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
alias count_files_recursive='find . -type f -print | wc -l'
alias count_files_recursive_per_directory='ls -d */ | xargs -I _ sh -c "find \"_\" -type f | wc -l | xargs echo _"'
alias flat_this_dir="sudo find . -mindepth 2 -type f -exec mv -i '{}' . ';'"
alias size_of_directory="ncdu --color dark -rr -x"
alias df='df -h'
alias ducks="du -sch .i[!.]* * |sort -rh |head -10" # print top 10 largest files in pwd

# run programs as root
if ! $_isroot; then
    alias svim='sudo e'
    alias reboot='sudo reboot'
    alias shutdown='sudo shutdown -hP now'
    alias scat='sudo cat'
    alias root='sudo su'
    alias windows='sudo grub-set-default 3 && sudo reboot'
    alias bb="sudo bleachbit --clean system.cache system.localizations system.trash system.tmp"
    alias SS='sudo systemctl'
fi

# pacman aliases
if $_isarch; then
    if ! $_isroot; then
        _have pacman-color && alias pacman='sudo pacman-color' || alias pacman='sudo pacman'
        _have powerpill && alias powerpill='sudo powerpill'
    else
        _have pacman-color && alias pacman='pacman-color'
    fi
    _have yay && alias y='yay'
    alias p="sudo pacman"
    alias pacorphans='pacman -Rs $(pacman -Qtdq)'
    alias paccorrupt='sudo find /var/cache/pacman/pkg -name '\''*.part.*'\''' # sudo so we can quickly add -delete
    alias pactesting='pacman -Q $(pacman -Sql {community-,multilib-,}testing) 2>/dev/null'
    alias remove='sudo pacman -Rsc'
    alias pacin='pacman -S'
    alias pacout='pacman -R'
    alias pacsearch='pacman -Ss'
    alias pacup='pacup.rb && sudo pacman -Suy'
    alias upp='sudo reflector -l 20 --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman -Syyu && cd /etc/ && sudo etckeeper commit "Auto Commit"; cd -'
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

    alias lsp="pacman -Qett --color=always | less"
fi

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

#NordVPN
alias nord='sudo openvpn ~/Dropbox/nordvpn/us1967.nordvpn.com.udp1194.ovpn'

alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"

#Misc Utilities
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias sps="ps aux | grep -v grep | grep"    # search and display processes by keyword
alias c='clear'
alias h='history'
alias j='jobs -l'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
#alias ping='ping -c 5'
alias fastping='ping -c 100 -s .2'
if _have prettyping; then
  alias ping='prettyping --nolegend'
fi
alias diff='colordiff'
alias ccat="highlight --out-format=ansi" # Color cat - print file
alias path='echo -e "${PATH//:/\n}"'
alias reload='source ~/.bash_profile'
alias ruler="echo .........1.........2.........3.........4.........5.........6.........7.........8"
if _have colortail; then
    alias tailirc='/usr/bin/colortail -q -k /etc/colortail/conf.irc'
    alias colortail='colortail -q -k /etc/colortail/conf.messages'
fi
alias sdn="sudo shutdown now"
alias psref="gpg-connect-agent RELOADAGENT /bye" # Refresh gpg
