#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/mpd.pid ] && mpd

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export ICAROOT='/home/dnewman/ICAClient'
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
