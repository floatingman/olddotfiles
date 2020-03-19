
export PATH=\
$HOME/go/bin:\
$HOME/.cargo/bin:\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/local/go/bin:\
/usr/local/tinygo/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/games:\
/usr/sbin:\
/usr/bin:\
/snap/bin:\
/sbin:\
/bin

case "$PLATFORM" in
  mac)
  [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/bin" | cut -f2 | tr '\n' ':')"
  [[ -r "$HOME/.bin" ]] && export PATH="$PATH:$(du -I .git "$HOME/.bin" | cut -f2 | tr '\n' ':')"
  ;;
  linux)
  [[ -r "$HOME/bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/bin" | cut -f2 | tr '\n' ':')"
  [[ -r "$HOME/.bin" ]] && export PATH="$PATH:$(du --exclude=.git "$HOME/.bin" | cut -f2 | tr '\n' ':')"
  ;;
  esac

alias path='echo $PATH | tr ":" "\n" | nl' # human readable path

