
############################# Personal Status ############################

# This stuff if for maintaining your personal status indicators wherere'
# they may be (GitHub, GitLab, Twitter, Twitch (on stream), IRC, Discord,
# etc.) These are in the Bash config because they are closer to the other
# command functions that will be called to change the status. For example,
# when the `blog` command function is called it can directly include calls
# to the following to change the status detecting it automatically. Vim
# can also be setup to change personal status based on what you are coding
# on. The personal status can be tied to things like Discord that detect
# what "game" you are playing.


schedule () {
  open $SCHEDULE
} && export -f schedule
