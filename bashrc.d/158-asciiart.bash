
################################ ASCII Art ###############################

doh () {
  echo -n $base3
  kat <<'EOM'

                 _ ,___,-'",-=-.           
       __,-- _ _,-'_)_  (""`'-._\ `.  [31m _____   ____  _    _ _  [0m [97m
    _,'  __ |,' ,-' __)  ,-     /. |  [31m|  __ \ / __ \| |  | | |[0m [97m
  ,'_,--'   |     -'  _)/         `\  [31m| |  | | |  | | |__| | |[0m [97m
,','      ,'       ,-'_,`           : [31m| |  | | |  | |  __  | |[0m [97m
,'     ,-'       ,(,-(              : [31m| |__| | |__| | |  | |_|[0m [97m
     ,'       ,-' ,    _            ; [31m|_____/ \____/|_|  |_(_)[0m [97m
    /        ,-._/`---'            /                                
   /        (____)(----. )       ,'                                 
  /         (      `.__,     /\ /,         
 :           ;-.___         /__\/|         
 |         ,'      `--.      -,\ |         
 :        /            \    .__/           
  \      (__            \    |_            
   \       ,`-, *       /   _|,\           
    \    ,'   `-.     ,'_,-'    \          
   (_\,-'    ,'\")--,'-'       __\         
    \       /  // ,'|      ,--'  `-.       
     `-.    `-/ \'  |   _,'         `.     
        `-._ /      `--'/             \    
          ,'           /               \    
          /            |                \  
 [92m-hrr-[97m ,-'             |                /  
      /                               -'   

EOM
  echo -n $reset
} && export -f doh

humm () {
  echo -n $base3
  kat <<'EOM'
       ,---.                        
     ,.'-.   \                      
    ( ( ,'"""""-.                   
    `,X          `.        [33m  _____                   [0m[97m
    /` `           `._     [33m |  |  |_ _ _____ _____   [0m[97m
   (            ,   ,_\    [33m |     | | |     |     |_ [0m[97m
   |          ,---.,'o `.  [33m |__|__|___|_|_|_|_|_|_|_| [0m[97m
   |         / o   \     )          
    \ ,.    (      .____,           
     \| \    \____,'     \          
   '`'\  \        _,____,'          
   \  ,--      ,-'     \            
     ( C     ,'         \           
      `--'  .'           |          
        |   |            |          
      __|    \        ,-'_          
     / `L     `._  _,'  ' `.        
    /    `--.._  `',.   _\  `       
    `-.       /\  | `. ( ,\  \      
   _/  `-._  /  \ |--'  (     \     
 -'  `-.   `'    \/\`.   `.    )    
        \  [92m-hrr-[97m    \ `.  |    |    

EOM
} && export -f humm

##########################################################################

# Prints some asciiart by key name from the exported asciiart associative
# array. If not found says so on stdout and returns 1.

#ascii () {
#  declare name="${1:-hummm}"
#  if [[ -v $asciiart[$name] ]]; then
#    telln 'Sorry no ascii art found for `'$name'`'
#    return 1
#  fi
#  declare text=${asciiart[$name]}
#  echo -n "${text:1}"
#} && export -f ascii

# TODO I *really* need an asciicenter function that detects and
# automatically centers. It's simple enough, I just need to get it done.
# Could have finished already in the time I spend adding spaces for
# padding to the art.

# Joins two files of text (presumably ascii art). You should add adequate
# spaces to the left file so that they match. (Might calculate that
# someday but this is fine for now.)

asciijoin () {
  declare -a a b
  declare i
  mapfile -t  a < "$1"
  mapfile -t  b < "$2"
  declare -i arows=${#a[@]}
  declare -i brows=${#b[@]}
  declare -i rows
  if [[ $arows > $brows ]]; then # ???
    rows=$brows
  else
    rows=$arows
  fi
  #declare -i awidth
  for (( i=0; i<$rows; i++ )); do 
    declare aline=${a[$i]}
    declare bline=${b[$i]}
    declare -i alen=${#aline}
    #[[ $alen > $awidth ]] && awidth=$alen
    echo "$aline $bline"
  done
  # FIXME second pass with left padding in case image on the left has
  # fewer lines than the one on the right
} && export -f asciijoin

alias cmatrix="cmatrix -b -C red -u 6"
alias fish="asciiquarium" # fuck the fish shell

watchdragon () {
  hidecursor
  while true; do
    clear
    echo 
    fortune -s | cowsay -f dragon |lolcat
    sleep 120
  done
} && export -f watchdragon
