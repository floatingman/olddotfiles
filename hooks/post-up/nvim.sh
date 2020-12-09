#!/bin/sh

if hash nvim 2> /dev/null; then
    nvim +PlugInstall! +qall!
fi
