eject () {
  declare path=/media/$USER
  declare first=$(ls -1 $path | head -1)
  declare mpoint=$path/$first
  [[ -z "$first" ]] && tell 'Nothing to eject.' && return
  umount $mpoint && tell "$first ejected" || tell 'Could not eject.'
} && export -f eject

usb () {
  declare path="/media/$USER"
  declare first=$(ls -1 "$path" | head -1)
  echo "$path/$first"
} && export -f usb

cdusb () {
  cd "$(usb)"
} && export -f cdusb

zeroblk () {
  [[ -z "$1" ]] && usageln 'zerobkd <blkdev>' && return 1
  [[ ! -b "/dev/$1" ]] && tell 'Not a block device.' && return 1
  danger 'Are you really sure you want to completly erase /dev/$1?'\
    || return 1
  sudo dd if=/dev/zero of=/dev/$1 bs=4M status=progress
  sync
} && export -f zeroblk

