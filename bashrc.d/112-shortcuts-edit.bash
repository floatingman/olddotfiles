
############################# Edit Shortcuts #############################

export EDITOR=vi
export VISUAL=vi
export EDITOR_PREFIX=vi

export VIMSPELL=(~/.vim/spell/*.add)
declare personalspell=(~/.vimpersonal/spell/*.add)
[[ -n "$personalspell" ]] && VIMSPELL=$personalspell
declare privatespell=(~/.vimprivate/spell/*.add)
[[ -n $privatespell ]] && VIMSPELL=$privatespell

# Commonly edited files.

declare -A edits=(
  [bashrc]=~/.bashrc
  [personal]=~/.bash_personal
  [private]=~/.bash_private
  [profile]=~/.profile
  [spell]=$VIMSPELL
)

for cmd in "${!edits[@]}"; do 
  path=${edits[$cmd]}
  case $PLATFORM in
    *) alias $EDITOR_PREFIX$cmd="$EDITOR '$path';warnln 'Make sure you git commit your changes (if needed).'" ;;
  esac
done
