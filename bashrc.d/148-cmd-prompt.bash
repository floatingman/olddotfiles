
# Not a fan of ridiculously distracting command prompts. Prompt should
# fade into background, not demand focus. The printf magic ensures that
# any output that does not end with a newline will not put a prompt
# immediately after it. Never forget the \[$color\] brackets that escape
# the width of the color escapes so they don't affect line wrapping.

# See https://github.com/ryanoasis/powerline-extra-symbols

export glypharrow=$'\ue0b0'
export glyphflames=$'\ue0c0'
export glyphrounded=$'\ue0b4'
export glyphbits=$'\ue0c6'
export glyphhex=$'\ue0cc'

export promptglyph=$glypharrow
export promptbgr=40
export promptbgg=40
export promptbgb=40
export promptuserc=$twrwxrob
export prompthostc=$twitch
export promptdirc=$bold$base04

# TODO detect current home system and only show home of main system so
# that when used on remote systems the name is displayed.

export PROMPT_COMMAND='
  touch "$HOME/.bash_history"
  promptbg=$(rgbg $promptbgr $promptbgg $promptbgb)
  # FIXME 
  promptglyphc=$(rgb $promptbgr $promptbgg $promptbgb)
  if [[ $HOME == $PWD ]]; then
    export PROMPTDIR="🏡"
  elif [[ $HOME == ${PWD%/*} ]]; then
    export PROMPTDIR="/${PWD##*/}"
  elif [[ / == $PWD ]]; then
    export PROMPTDIR="/"
  elif [[ "" == ${PWD%/*} ]]; then
    export PROMPTDIR=$PWD
  else
    # TODO fixeme with ascii char
    export PROMPTDIR=…/${PWD##*/}
  fi
  if [[ $EUID == 0 ]]; then
    PS1="\[$blinkon$promptbg$red\]\u\[$base03$blinkoff\]@\[\$prompthostc\]\h \[$base03\]\[$promptdirc\]"$PROMPTDIR" \[$reset$promptglyphc\]$promptglyph \[$reset\]"
  else 
    PS1="\[$base03\]\[$promptdirc\]"$PROMPTDIR" \[$reset$twitch\]$promptglyph \[$reset\]"
 fi
'
