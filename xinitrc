#!/bin/sh

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

#run systemd as user intsance
systemd --user &

# set key repeat rate
xset r rate 300

# Configure X
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# load keyboard modifications
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# composting
compton --inactive-dim 0.02 -b

# start pulseaudio if it isn't running already
if [ ! "`pgrep pulseaudio`" ]; then
	pulseaudio --start
fi

xset s off
setxkbmap -option terminate:ctrl_alt_bksp
xfce4-panel &
numlockx &
parcellite &
synergys &
plank &
wallpaper.sh &
xscreensaver &
pidgin &
#cairo-dock &

exec openbox-session
#exec i3
#exec enlightenment_start
