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

test -e "/usr/local/opt/git/etc/bash_completion.d/git-completion.bash" && source "/usr/local/opt/git/etc/bash_completion.d/git-completion.bash"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if $_ismac; then
  export SDKMAN_DIR="/Users/daniel.newman/.sdkman"
  [[ -s "/Users/daniel.newman/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/daniel.newman/.sdkman/bin/sdkman-init.sh"
  test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

if $_islinux; then
  export SDKMAN_DIR="/home/dnewman/.sdkman"
  [[ -s "/home/dnewman/.sdkman/bin/sdkman-init.sh" ]] && source "/home/dnewman/.sdkman/bin/sdkman-init.sh"
fi
if [ -e /home/dnewman/.nix-profile/etc/profile.d/nix.sh ]; then
   . /home/dnewman/.nix-profile/etc/profile.d/nix.sh;
fi # added by Nix installer

if $_ismac; then
   # Setting PATH for Python 3.6
   # The original version is saved in .bash_profile.pysave
   PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
   export PATH
fi

# added by Anaconda3 5.0.0 installer
export PATH="/Users/daniel.newman/anaconda3/bin:$PATH"
