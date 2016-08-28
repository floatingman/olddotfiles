[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xmodmap ~/.Xmodmap

sxhkd &

xautolock -time 09 -locker "/usr/local/bin/lock" -detectsleep -secure &

if [ -f ~/.fehbg ]; then
  sh ~/.fehbg &
fi

volwheel &

nm-applet &

unclutter &

dunst &

redshift-gtk &

autorandr --change --default mobile

srandrd autorandr --change --default mobile

udiskie &

exec i3
