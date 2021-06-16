#!/bin/sh

if hash emacs 2> /dev/null; then
    ~/.dotfiles/emacs.d/update-emacs-config
fi
