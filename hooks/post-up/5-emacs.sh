#!/bin/sh

if hash emacs 2> /dev/null; then
    cd ~/.emacs.d/
    ./update-emacs-config
fi
