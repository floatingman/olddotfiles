
######################### Lynx Text Browser FTW! #########################

# This version of lynx does not allow for anything to be passed to it but
# the URL it is to search for. All other configurations must be placed in
# the ~/.config/lynx/lynx.cfg and ~/.config/lynx/lynx.lss files. 

if [ -e "$HOME/.config/lynx/lynx.cfg" ];then
  export LYNX_CFG="$HOME/.config/lynx/lynx.cfg"
fi

if [ -e "$HOME/.config/lynx/lynx.lss" ];then
  export LYNX_LSS="$HOME/.config/lynx/lynx.lss"
fi

export _lynx=$(which lynx)

lynx () { 
  if [ -z "$_lynx" ]; then
      echo "Doesn't look like lynx is installed."
      return 1
  fi
  $_lynx $*
} && export -f lynx 

