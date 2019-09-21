#!/bin/bash
## Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
# * ~/.utils is for any utility functons used by other shell dotfiles

for file in ~/.{utils,exports,functions,path,aliases,dockerfunc,extra,bashrc}; do
    [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
done
# for file in ~/.{utils,exports,functions,path,aliases,dockerfunc,extra,bashrc}; do
    # [[ -r "$file" ]] && [[ -f "$file" ]] && source "$file"
# done
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

[ ! -f ~/.shortcuts ] && shortcuts >/dev/null 2>&1

export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
   . "${HOME}/.nix-profile/etc/profile.d/nix.sh";
fi # added by Nix installer

if [ ! -f "/mnt/keytabs/${USER}.keytab" ]; then
    if [ -x /mnt/keytabs/generate_user_keytab.sh ]; then
        /mnt/keytabs/generate_user_keytab.sh &> /dev/null
    fi
fi

if [ -f "/mnt/keytabs/${USER}.keytab" ]; then
    kinit -kt "/mnt/keytabs/${USER}.keytab ${USER}/$(hostname -f)"
fi

if [ -f "$HOME/apache-maven/bin/mvn" ]; then
    alias mvn='$HOME/apache-maven/bin/mvn'
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

if [ -d "$HOME/.asdf" ]; then
	. $HOME/.asdf/asdf.sh
	. $HOME/.asdf/completions/asdf.bash
fi

# if $_ismac; then
# 	LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
# 	export PATH="/usr/local/opt/llvm/bin:$PATH"
# 	export LDFLAGS="-L/usr/local/opt/llvm/lib"
#   export CPPFLAGS="-I/usr/local/opt/llvm/include"
# fi
