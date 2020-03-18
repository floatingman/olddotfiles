# Graphic web site shortcuts.

declare -A sites=(
  [github]=github.com
  [gitlab]=gitlab.com
  [protonmail]=protonmail.com
  [skilstak]=skilstak.io
  [dockhub]=hub.docker.com
  [twitter]=twitter.com
  [medium]=medium.com
  [reddit]=reddit.com
  [patreon]=patreon.com
  [paypal]=paypal.com
  [hackerone]=hackerone.com
  [bugcrowd]=bugcrowd.com
  [synack]=synack.com
  [bls]=bls.gov
  [youtube]=youtube.com
  [twitch]=twitch.com
  [vimeo]=vimeo.com
  [emojipedia]=emojipedia.com
  [netflix]=netflix.com
  [amazon]=amazon.com
)

for shortcut in "${!sites[@]}"; do 
  url=${sites[$shortcut]}
  alias $shortcut="open https://$url &>/dev/null"
done

alias '?'=duck
alias '??'=google
