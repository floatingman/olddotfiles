#!/bin/bash
## Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
# * ~/.utils is for any utility functons used by other shell dotfiles

for file in ~/.{utils,exports,bash_prompt,functions,path,aliases,dockerfunc,extra}; do
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

[ ! -f ~/.shortcuts ] && shortcuts >/dev/null 2>&1

# Switch escape and caps if tty
sudo -n loadkeys ~/bin/ttymaps.kmap 2>/dev/null

if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --sh-syntax --exit-with-session)
	export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
fi

source "$HOME/.bashrc"

test -e "/usr/local/opt/git/etc/bash_completion.d/git-completion.bash" && source "/usr/local/opt/git/etc/bash_completion.d/git-completion.bash"

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
