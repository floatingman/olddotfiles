# mac exports
if $_ismac; then
  export HOMEBREW_AUTO_UPDATE_SECS=86400;
  export HOMEBREW_NO_ANALYTICS=true;
  export HOMEBREW_INSTALL_BADGE="(ʘ‿ʘ)";
  export HOMEBREW_BUNDLE_FILE_PATH=~/.homebrew/Brewfile;
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# Set alacritty as the default terminal
if _have alacritty; then
  export TERMINAL='alacritty';
fi

# For the fuzzy finder
if _have fzf; then
    # Customize the default Fuzzy Finder command. Use "fd" instead of the default
    # "find" command to traverse the file system while respecting .gitignore. fd is
    # a simple, fast and user-friendly alternative to find. While it does not seek
    # to mirror all of find's powerful functionality, it provides sensible
    # (opinionated) defaults for 80% of the use cases. It's the perfect tool to use
    # with fzf, each with its own strength.
    export FZF_DEFAULT_COMMAND='fd --hidden --exclude=.local --exclude=.config --exclude=.rbenv --exclude=.cache --exclude=.git --exclude=node_modules'
    # Default command for finding dirs
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type=d"
    # Default command for finding files
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type=f"
fi

if [ -e ~/.dpi ]; then
  source ~/.dpi
fi

#Mac git completion
if $_ismac; then
  if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    . `brew --prefix`/etc/bash_completion.d/git-completion.bash
  fi
fi

# Andriod SDK
if $_ismac; then
  if [ -d ~/Library/Android/sdk ]; then
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
    _add_to_path "$HOME/Library/Android/sdk/platform-tools"
  fi
fi

# Ruby
if [[ -r "$HOME/.rbenv" ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

#Composer
[[ -d "$HOME/.composer" ]] && _add_to_path "$HOME/.composer/vendor/bin"

# Heroku
[[ -r "/usr/local/heroku" ]] && _add_to_path "/usr/local/heroku/bin"

# PHP5
[[ -f /usr/local/php5/bin/php ]] && _add_to_path "/usr/local/php5/bin"

# MYSQL
[[ -f /usr/local/mysql/bin/mysql ]] && _add_to_path "/usr/local/mysql/bin"

#mac stuff
if $_ismac; then
  _add_to_path "/usr/local/sbin"
fi

# PyENV
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  eval "$(register-python-argcomplete pipx)"
fi

#NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#SDKMAN
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

###-tns-completion-start-###
if [ -f /home/dnewman/.tnsrc ]; then
  source /home/dnewman/.tnsrc
fi
###-tns-completion-end-###

# Broot
if [ -f "${HOME}/Library/Preferences/org.dystroy.broot/launcher/bash/br" ]; then
  source "${HOME}/Library/Preferences/org.dystroy.broot/launcher/bash/br"
elif [ -f "${HOME}/.config/broot/launcher/bash/br" ]; then
  source "${HOME}/.config/broot/launcher/bash/br"
fi

#Jenkins X
if [ -d $HOME/.jx/bin ]; then
    _add_to_path "$HOME/.jx/bin"
fi

#Yarn
if [ -d $HOME/.yarn/bin ]; then
    _add_to_path "$HOME/.yarn/bin"
    _add_to_path "$HOME/.config/yarn/global/node_modules/.bin"
fi
