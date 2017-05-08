# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
# * ~/.utils is for any utility functons used by other shell dotfiles

for file in ~/.{utils,bash_prompt,aliases,functions,path,dockerfunc,extra,exports}; do
    [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# bash 4 features
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar autocd dirspell
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
                                         -o "nospace" \
                                         -W "$(grep "^Host" ~/.ssh/config | \
grep -v "[?*]" | cut -d " " -f2 | \
tr ' ' '\n')" scp sftp ssh

# set javahome on mac
if $_ismac; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

source "$HOME/.bashrc"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if $_islinux; then
  export SDKMAN_DIR="/home/dnewman/.sdkman"
  [[ -s "/home/dnewman/.sdkman/bin/sdkman-init.sh" ]] && source "/home/dnewman/.sdkman/bin/sdkman-init.sh"
fi
