############################## Notifications #############################

# Notify sends a normal notification using notify-send. Use notify-send
# for more specific notifications.

notify () {
  notify-send "$*"
} && export -f notify
