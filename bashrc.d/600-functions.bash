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
    _have mpv || return 1

    local word="$*"

    w3m -dump "http://www.google.com/search?q=define%20${word// /_}" | awk '/^     1./,/^        More info >>/'
    mpv "http://ssl.gstatic.com/dictionary/static/sounds/de/0/${word// /_}.mp3" &>/dev/null
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

# Simple calculator
calc() {
	  local result=""
	  result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
	  #						└─ default (when `--mathlib` is used) is 20

	  if [[ "$result" == *.* ]]; then
		    # improve the output for decimal numbers
		    printf "$result" |
		        sed -e 's/^\./0./'		  `# add "0" for cases like ".5"` \
			          -e 's/^-\./-0./'	  `# add "0" for cases like "-.5"`\
			          -e 's/0*$//;s/\.$//';  # remove trailing zeros
	  else
		    printf "$result"
	  fi
	  printf "\n"
}

# Create a new directory and enter it
mkd() {
	  mkdir -p "$@" && cd "$@"
}

# Make a temporary directory and enter it
tmpd() {
	  if [ $# -eq 0 ]; then
		    dir=`mktemp -d` && cd $dir
	  else
		    dir=`mktemp -d -t $1.XXXXXXXXXX` && cd $dir
	  fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
	  local tmpFile="${@%/}.tar"
	  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

	  size=$(
	      stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
	      stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	      )

	  local cmd=""
	  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		    # the .tar file is smaller than 50 MB and Zopfli is available; use it
		    cmd="zopfli"
	  else
		    if hash pigz 2> /dev/null; then
			      cmd="pigz"
		    else
			      cmd="gzip"
		    fi
	  fi

	  echo "Compressing .tar using \`${cmd}\`…"
	  "${cmd}" -v "${tmpFile}" || return 1
	  [ -f "${tmpFile}" ] && rm "${tmpFile}"
	  echo "${tmpFile}.gz created successfully."
}

# Determine size of a file or total size of a directory
fs() {
	  if du -b /dev/null > /dev/null 2>&1; then
		    local arg=-sbh
	  else
		    local arg=-sh
	  fi
	  if [[ -n "$@" ]]; then
		    du $arg -- "$@"
	  else
		    du $arg .[^.]* *
	  fi
}

# Create a data URL from a file
dataurl() {
	  local mimeType=$(file -b --mime-type "$1")
	  if [[ $mimeType == text/* ]]; then
		    mimeType="${mimeType};charset=utf-8"
	  fi
	  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Create a git.io short URL
gitio() {
	  if [ -z "${1}" -o -z "${2}" ]; then
		    echo "Usage: \`gitio slug url\`"
		    return 1
	  fi
	  curl -i http://git.io/ -F "url=${2}" -F "code=${1}"
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
	  local port="${1:-8000}"
	  sleep 1 && open "http://localhost:${port}/" &
	  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Compare original and gzipped file size
gz() {
	  local origsize=$(wc -c < "$1")
	  local gzipsize=$(gzip -c "$1" | wc -c)
	  local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
	  printf "orig: %d bytes\n" "$origsize"
	  printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json() {
	  if [ -t 0 ]; then # argument
		    python -mjson.tool <<< "$*" | pygmentize -l javascript
	  else # pipe
		    python -mjson.tool | pygmentize -l javascript
	  fi
}

# Run `dig` and display the most useful info
digga() {
	  dig +nocmd "$1" any +multiline +noall +answer
}

# Query Wikipedia via console over DNS
mwiki() {
	  dig +short txt "$*".wp.dg.cx
}

# UTF-8-encode a string of Unicode symbols
escape() {
	  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	  # print a newline unless we’re piping the output to another program
	  if [ -t 1 ]; then
		    echo ""; # newline
	  fi
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
	  perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	  # print a newline unless we’re piping the output to another program
	  if [ -t 1 ]; then
		    echo ""; # newline
	  fi
}

# Get a character’s Unicode code point
codepoint() {
	  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
	  # print a newline unless we’re piping the output to another program
	  if [ -t 1 ]; then
		    echo ""; # newline
	  fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames() {
	  if [ -z "${1}" ]; then
		    echo "ERROR: No domain specified."
		    return 1
	  fi

	  local domain="${1}"
	  echo "Testing ${domain}…"
	  echo ""; # newline

	  local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		                   | openssl s_client -connect "${domain}:443" 2>&1)

	  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		    local certText=$(echo "${tmp}" \
			                          | openssl x509 -text -certopt "no_header, no_serial, no_version, \
			no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
		    echo "Common Name:"
		    echo ""; # newline
		    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
		    echo ""; # newline
		    echo "Subject Alternative Name(s):"
		    echo ""; # newline
		    echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			      | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
		    return 0
	  else
		    echo "ERROR: Certificate not found."
		    return 1
	  fi
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
v() {
	  if [ $# -eq 0 ]; then
		    vim .
	  else
		    vim "$@"
	  fi
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
o() {
	  if [ $# -eq 0 ]; then
		    xdg-open .	> /dev/null 2>&1
	  else
		    xdg-open "$@" > /dev/null 2>&1
	  fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
	  tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

# Call from a local repo to open the repository on github/bitbucket in browser
repo() {
	  local giturl=$(git config --get remote.origin.url | sed 's/git@/\/\//g' | sed 's/.git$//' | sed 's/https://g' | sed 's/:/\//g')
	  if [[ $giturl == "" ]]; then
		    echo "Not a git repository or no remote.origin.url is set."
	  else
		    local gitbranch=$(git rev-parse --abbrev-ref HEAD)
		    local giturl="http:${giturl}"

		    if [[ $gitbranch != "master" ]]; then
			      if echo "${giturl}" | grep -i "bitbucket" > /dev/null ; then
				        local giturl="${giturl}/branch/${gitbranch}"
			      else
				        local giturl="${giturl}/tree/${gitbranch}"
			      fi
		    fi

		    echo $giturl
		    open $giturl
	  fi
}

# Get colors in manual pages
man() {
	  env \
		    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		    LESS_TERMCAP_md=$(printf "\e[1;31m") \
		    LESS_TERMCAP_me=$(printf "\e[0m") \
		    LESS_TERMCAP_se=$(printf "\e[0m") \
		    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		    LESS_TERMCAP_ue=$(printf "\e[0m") \
		    LESS_TERMCAP_us=$(printf "\e[1;32m") \
		    man "$@"
}

# Use feh to nicely view images
openimage() {
	  local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	  cd $(dirname "$1")
	  local file=$(basename "$1")

	  feh -q $types --auto-zoom \
		    --sort filename --borderless \
		    --scale-down --draw-filename \
		    --image-bg black \
		    --start-at "$file"
}

# get dbus session
dbs() {
	  local t=$1
	  if [[  -z "$t" ]]; then
		    local t="session"
	  fi

	  dbus-send --$t --dest=org.freedesktop.DBus \
		          --type=method_call	--print-reply \
		          /org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

# check if uri is up
isup() {
	  local uri=$1

	  if curl -s --head  --request GET "$uri" | grep "200 OK" > /dev/null ; then
		    notify-send --urgency=critical "$uri is down"
	  else
		    notify-send --urgency=low "$uri is up"
	  fi
}

# build go static binary from root of project
gostatic(){
	  local dir=$1
	  local arg=$2

	  if [[ -z $dir ]]; then
		    dir=$(pwd)
	  fi

	  local name=$(basename "$dir")
	  (
	      cd $dir
	      export GOOS=linux
	      echo "Building static binary for $name in $dir"

	      case $arg in
		        "netgo")
			          set -x
			          go build -a \
				           -tags 'netgo static_build' \
				           -installsuffix netgo \
				           -ldflags "-w" \
				           -o "$name" .
			          ;;
		        "cgo")
			          set -x
			          CGO_ENABLED=1 go build -a \
				                   -tags 'cgo static_build' \
				                   -ldflags "-w -extldflags -static" \
				                   -o "$name" .
			          ;;
		        *)
			          set -x
			          CGO_ENABLED=0 go build -a \
				                   -installsuffix cgo \
				                   -ldflags "-w" \
				                   -o "$name" .
			          ;;
	      esac
	  )
}

# go to a folder easily in your gopath
gogo(){
	  local d=$1

	  if [[ -z $d ]]; then
		    echo "You need to specify a project name."
		    return 1
	  fi

	  if [[ "$d" == github* ]]; then
		    d=$(echo $d | sed 's/.*\///')
	  fi
	  d=${d%/}

	  # search for the project dir in the GOPATH
	  local path=( `find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

	  if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
		    echo "Could not find a directory named $d in $GOPATH"
		    echo "Maybe you need to 'go get' it ;)"
		    return 1
	  fi

	  # enter the first path found
	  cd "${path[0]}"
}

golistdeps(){
	  (
	      if [[ ! -z "$1" ]]; then
		        gogo $@
	      fi

	      go list -e -f '{{join .Deps "\n"}}' ./... | xargs go list -e -f '{{if not .Standard}}{{.ImportPath}}{{end}}'
	  )
}

# get the name of a x window
xname(){
	  local window_id=$1

	  if [[ -z $window_id ]]; then
		    echo "Please specifiy a window id, you find this with 'xwininfo'"

		    return 1
	  fi

	  local match_string='".*"'
	  local match_int='[0-9][0-9]*'
	  local match_qstring='"[^"\\]*(\\.[^"\\]*)*"' # NOTE: Adds 1 backreference

	  # get the name
	  xprop -id $window_id | \
		    sed -nr \
		        -e "s/^WM_CLASS\(STRING\) = ($match_qstring), ($match_qstring)$/instance=\1\nclass=\3/p" \
		        -e "s/^WM_WINDOW_ROLE\(STRING\) = ($match_qstring)$/window_role=\1/p" \
		        -e "/^WM_NAME\(STRING\) = ($match_string)$/{s//title=\1/; h}" \
		        -e "/^_NET_WM_NAME\(UTF8_STRING\) = ($match_qstring)$/{s//title=\1/; h}" \
		        -e '${g; p}'
}

dell_monitor() {
	  xrandr --newmode "3840x2160_30.00"  338.75  3840 4080 4488 5136  2160 2163 2168 2200 -hsync +vsync
	  xrandr --addmode  DP1 "3840x2160_30.00"
	  xrandr --output eDP1 --auto --primary --output DP1 --mode 3840x2160_30.00 --above eDP1 --rate 30
}

shdl() { curl -O $(curl -s http://sci-hub.tw/"$@" | grep location.href | grep -o http.*pdf) ;}
se() { du -a ~/bin/* ~/.dotfiles/* | awk '{print $2}' | fzf | xargs -r $EDITOR ;}
sv() { vcopy "$(du -a ~/bin/* ~/.dotfiles/* | awk '{print $2}' | fzf)" ;}
vf() { fzf | xargs -r -I % $EDITOR % ;}

# Return the number of processors available
nproc() {
  if $(which nproc >/dev/null 2>&1); then
    command nproc
  elif [ -e /proc/cpuinfo ]; then
    grep ^processor < /proc/cpuinfo | wc -l
  else
    sysctl -n hw.ncpu
  fi
}

function yta() {
    mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*"
}
