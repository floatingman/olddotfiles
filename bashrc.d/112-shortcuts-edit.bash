
############################# Edit Shortcuts #############################

export EDITOR=nvim
export VISUAL=nvim
export EDITOR_PREFIX=nvim

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
  [dotfiles]=~/.dotfiles/
)

for cmd in "${!edits[@]}"; do
  path=${edits[$cmd]}
  case $PLATFORM in
    *) alias $EDITOR_PREFIX$cmd="$EDITOR '$path';warnln 'Make sure you git commit your changes (if needed).'" ;;
  esac
done
