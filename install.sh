#!/bin/sh

get_dpi() {
    r=$( (xrandr | \
             grep '\<connected\>' | \
             head -n 1 | \
             sed 's/[^0-9]/ /g' | \
             awk '{printf "%.0f\n", $2 / ($6 * 0.0394)}') \
           2>/dev/null)
    if [ -z "$r" ]; then
        echo 96  # fake it
    else
        echo "$r"
    fi
}

## Reload .Xresources
if [ -n "$DISPLAY" ]; then
    dpi="$(get_dpi)"
    if [ "$dpi" -gt 110 ]; then
        font_size=12
    else
        font_size=10
    fi
    echo "#define FONT_SIZE $font_size" > ~/.Xresources.h
    if [ ! -e ~/.dpi ]; then
        echo "export DPI=$(get_dpi)" > ~/.dpi
    fi
    xrdb -I$HOME -merge ~/.Xresources 2> /dev/null
elif [ ! -e ~/.Xresources.h ]; then
    echo "#define FONT_SIZE 10" > ~/.Xresources.h
fi
