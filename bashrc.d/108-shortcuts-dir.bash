# Directory (cd) shortcuts. Using associative arrays pointing to
# environment variable names cuz names might not always match (otherwise
# would just ${foo^^} them). Might want to use a different env variable
# name at some point.

declare -A directories=(
  [repos]=REPOS
  [config]=CONFIG
  [personal]=PERSONAL
  [private]=PRIVATE
  [tokens]=TOKENS
  [downloads]=DOWNLOADS
  [desktop]=DESKTOP
  [pictures]=PICTURES
  [videos]=VIDEOS
  [images]=DISKIMAGES
  [vmachines]=VMACHINES
  [readme]=README
  [documents]=DOCUMENTS
)

for k in "${!directories[@]}"; do 
  v=${directories[$k]}
  alias $k='\
    if [[ -n "$'$v'" ]];\
      then cd "$'$v'";\
    else\
      warnln "\`\$'$v'\` not set. Consider adding to ~/.bash_{personal,private}.";\
    fi'
done

# Detect reasonable defaults (override in .bash_private). You'll want to
# set CONFIG in your PERSONAL or PRIVATE locations. See the following for
# examples of how to do this:
#
#    https://github.com/rwxrob/config-personal-sample
#    https://github.com/rwxrob/config-private-sample

declare -A defaults=(
  [DOWNLOADS]=~/Downloads
  [REPOS]=~/Repos
  [DESKTOP]=~/Desktop
  [DOCUMENTS]=~/Documents
  [README]=~/Documents/README   # README WorldPress content
  [PICTURES]=~/Pictures
  [VIDEOS]=~/Videos
  [DISKIMAGES]=~/DiskImages     # linux, arch, raspberrian, etc.
  [VMACHINES]=~/VMachines       # vmware, virtual box, etc.
  [TRASH]=~/Trash               # trash (see trash)
) 

for k in "${!defaults[@]}"; do
  v=${defaults[$k]}
  export $k=$v
done

