
set bell-style none
#set -o noclobber

shopt -s checkwinsize
shopt -s expand_aliases
shopt -s nullglob
shopt -s globstar
shopt -s dotglob
shopt -s extglob

# There really is no reason to *not* use the GNU utilities for your login
# shell but there are lot of reasons *to* use it. The only time it could
# present a problem is using other shell scripts written specifically for
# Mac (darwin/bsd). There are far more scripts written to use the GNU
# utilities in the world. Plus you finger muscle memory will be consistent
# across Linux and Mac.

if [[ $PLATFORM = mac ]]; then
  if ! havecmd gls; then
    echo 'Need to `brew install coreutils` for Mac to work.'
  fi 
fi

