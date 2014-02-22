#!/bin/sh

PATH=~/.bin:~/.xmonad/:~/.cabal/bin:$PATH

/usr/lib/systemd/systemd --user &

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Configure X
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
xscreensaver -no-splash &
xsetroot -cursor_name left_ptr 
wallpaper.sh &

# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus
# Start GNOME keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets ssh)
# You probably need to do this too:
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID


#[-r ~/.xinitrc.local ] && . ~/.xinitrc.local

xset s off
setxkbmap -option terminate:ctrl_alt_bksp


#synergyc 192.168.0.2 &

# Start the apps
tray &
urxvtd -q -f -o
dropboxd &  #commented out for openbox
nm-applet &   #commented out for openbox
parcellite &
pasystray &
#volumeicon &
batterymon &
toggle-touchpad.sh &

#added for openbox
export GTK2_RC_FILES="$HOME/.gtkrc-2.0" 

#start tray apps
#blueman-applet &  #commented out for openbox
#redshiftgui &
#xautolock -time 30 -locker "sudo pm-suspend" &

exec dbus-launch --sh-syntax --exit-with-session xmonad
#exec openbox-session
