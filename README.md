dotfiles
1. Install rcm https://robots.thoughtbot.com/rcm-for-rc-files-in-dotfiles-repos
2. Run `git submodule update --init`
3. Run `./build`
4. Run `ln -s ~/.dotfiles/rcrc ~/.rcrc`
5. Run `rcup -v`
6. Run `~/.dotfiles/install.sh`

*Bonus* for mac
1. Run `rcup -v -t macos`
2. And then run the various mac setup scripts in my [bin](https://github.com/floatingman/bin) repo


Afterwards an alias is created to update your dotfiles with the command ```ud```
