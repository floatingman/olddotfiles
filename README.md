dotfiles

1. Install rcm https://robots.thoughtbot.com/rcm-for-rc-files-in-dotfiles-repos
2. Run `git submodule update --init`
3. Run `./build`
4. Run `ln -s ~/.dotfiles/rcrc ~/.rcrc`
5. Run `rcup -v`
6. Run `~/.dotfiles/install.sh`
7. Start emacs and load Emacs.org in the .emacs.d folder and tangle the file
   with `C-c C-v t` to create the emacs config
_Bonus_ for mac

1. Run `rcup -v -t mac`
2. And then run the various mac setup scripts in my [bin](https://github.com/floatingman/bin) repo

Afterwards an alias is created to update your dotfiles with the command `ud`

You can keep private information or customized configuration in `.bash_personal` and/or `.bash_private`
