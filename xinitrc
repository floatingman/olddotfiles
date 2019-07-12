#!/bin/sh

#[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
#[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

#xset r rate 200 50

[ -f ~/.xprofile ] && . ~/.xprofile

while :; do
	ssh-agent dwm || break
done
