############################## Markdown-ish ##############################

# Minimal packrat parsing expression grammar (PEG):
# 
#   Mark      <- Span* !.
#   Span      <- Plain / StrongEm / Strong / Emphasis / Link / Code
#   StrongEm  <- '***' .* '***'
#   StrongEm  <- '***' .* '***'
#   Strong    <- '**' .* '**'
#   Emphasis  <- '*' .* '*'
#   Link      <- '<' .* '>'
#   Code      <- '`' .* '`'
#   Plain     <- DQUOTE / QUOTE / LARROW / RARROW / ELLIPSIS / .*
#   DQUOTE    <- '"'
#   QUOTE     <- "'"
#   LARROW    <- " <- " 
#   RARROW    <- " -> " 
#   ELLIPSIS  <- '...'
# 
# There's no character escape support because it isn't needed for most
# all use cases here. 

export md_strongem=$red     #  ***strongem***
export md_strong=$yellow    #  **strong**
export md_emphasis=$magen   #  *emphasis*
export md_code=$cyan        #  `code`
export md_plain=''          #  plain

mark () {
  declare inemphasis instrong instrongem incode indquote inquote inlink i
  declare defsol1="$normal"
  declare defsol2="$normalbg"

  # Detect default colors (fore, bg) from optional first and second
  # arguments. 

  issol "$1" && defsol1="$1" && shift
  issol "$1" && defsol2="$1" && shift
  declare defsol="$defsol1$defsol2"
  echo -n "$defsol"

  # The main content is almost always within single quotes to prevent
  # shell expansions, but we'll combine the remaining arguments anyway for
  # convenience (like echo does).

  declare buf=$*

  # recursive descent parser

  for (( i=0; i<${#buf}; i++ )); do 

    # ***strongem***

    if [[ "${buf:$i:3}" = '***' ]]; then
      if [[ -z "$instrongem" ]]; then
        echo -n "$md_strongem"
        #echo -n '<strongem>'
        instrongem=1
      else
        #echo -n '</strongem>'
        echo -n $defsol
        instrongem=''
      fi
      i=$[i+2]
      continue
    fi

    # **strong**

    if [[ "${buf:$i:2}" = '**' ]]; then
      if [[ -z "$instrong" ]]; then
        echo -n "$md_strong"
        #echo -n '<strong>'
        instrong=y
      else
        #echo -n '</strong>'
        echo -n $defsol
        instrong=''
      fi
      i=$[i+1]
      continue
    fi

    # *emphasis*

    if [[ "${buf:$i:1}" = '*' ]]; then
      if [[ -z "$inemphasis" ]]; then
        echo -n "$md_emphasis"
        #echo -n '<emphasis>'
        inemphasis=y
      else
        #echo -n '</emphasis>'
        echo -n $defsol
        inemphasis=''
      fi
      continue
    fi

    # `code`

    if [[ "${buf:$i:1}" = '`' ]]; then
      if [[ -z "$incode" ]]; then
        echo -n "$md_code"
        #echo -n '<code>'
        incode=y
      else
        #echo -n '</code>'
        echo -n $defsol
        incode=''
      fi
      continue
    fi

    # "

    if [[ "${buf:$i:1}" = '"' ]]; then
      if [[ -z "$indquote" ]]; then
        echo -n '“'
        indquote=y
      else
        echo -n '”'
        indquote=''
      fi
      continue
    fi

    # ' 

    if [[ "${buf:$i:1}" = "'" ]]; then
      if [[ -z "$inquote" ]]; then
        echo -n '‘'
        inquote=y
      else
        echo -n '’'
        inquote=''
      fi
      continue
    fi

    # <-

    if [[ "${buf:$i:4}" = ' <- ' ]]; then
      echo -n " ← "
      i=$[i+3]
      continue
    fi

    # ->

    if [[ "${buf:$i:4}" = ' -> ' ]]; then
      echo -n " → "
      i=$[i+3]
      continue
    fi

    # ...
    
    if [[ "${buf:$i:3}" = '...' ]]; then
      echo -n "…"
      i=$[i+2]
      continue
    fi

    # <link>

    if [[ "${buf:$i:1}" = '<' ]]; then
      if [[ -z "$inlink" ]]; then
        echo -n $md_code${buf:$i:1}
        #echo -n '<link>'
        inlink=y
      fi
      continue
    fi
    if [[ "${buf:$i:1}" = '>' ]]; then
      if [[ -n "$inlink" ]]; then
        #echo -n '</link>'
        echo -n ${buf:$i:1}$defsol
        inlink=''
      fi
      continue
    fi

    echo -n "${buf:$i:1}"
  done
  echo -n $reset
} && export -f mark

