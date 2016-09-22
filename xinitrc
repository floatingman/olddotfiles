#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [-f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [-d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

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

$HOME/bin/wallpaper.sh &

blueman-applet &

dropboxy &

exec i3
