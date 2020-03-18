
############################# Go Development #############################

# Not being able to use private repos by default with Go is really
# annoying. This is the standard way to overcome that.

export GOPRIVATE="github.com/$GITUSER/*,gitlab.com/$GITUSER/*"
export GOBIN="$HOME/go/bin"
mkdir -p $GOBIN

# Changes into the first Go directory (from GOPATH) matching the name
# passed by looking up the package by specifying the ending string of the
# package name. Prompts for selection if more than one match.  Useful for
# quickly examining the source code of any Go package on the local system.

# (Use of gocd is largely deprecated along with "GOPATH mode" in general.
# Instead keep your go code with all your other repos and use "module
# mode" with `replace` when needed.

gocd () {
  declare q="$1"
  declare list=$(go list -f '{{.Dir}}' ...$q 2>/dev/null)
  IFS=$'\n' declare lines=($list) # split lines
  case "${#lines}" in
    0) tell 'Nothing found for "`'$q'`"' ;;
    1) cd $n ;;
    *) select path in "${lines[@]}"; do cd $path; break; done ;;
  esac
}

# Can be run from TMUX pane to simply watch the tests without having to
# explicitely run them constantly. When combined with a dump() Go utility
# function provides immediate, real-time insight without complicating
# development with a bloated IDE. (Also see Monitoring for other ideas for
# running real-time evaluations during development)

alias goi='go install'
alias gor='go run main.go'
alias got='go test'

gott () {
  declare seconds="$1"
  while true; do 
    go test
    sleep ${seconds:-3}
  done
}

# Builds the passed Go package or command for every supported operating
# system and architecture into directories named for such and logs.

godistbuild () {
  declare relpath="${1-.}"
  declare log="$PWD/build.log"
  >| $log # truncate
  for dist in $(go tool dist list); do
    [[ ! -d $dist ]] && mkdir -p $dist
      declare os=${dist%/*}
      declare arch=${dist#*/}
      echo "BUILDING: $os-$arch" |tee -a $log
      cd $dist
      GOOS=$os GOARCH=$arch go build $relpath  >> $log 2>&1
      echo >> $log
      cd - &>/dev/null
  done
}
