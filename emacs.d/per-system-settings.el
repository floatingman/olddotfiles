(require 'map) ;; Needed for map-merge

(setq dn/system-settings
      (map-merge
       'list
       '((desktop/dpi . 158)
         (desktop/background . "samual-ferrara-u0i3lg8fGl4-unsplash.jpg")
         (polybar/height . 35)
         (polybar/font-0-size . 18)
         (polybar/font-1-size . 14)
         (polybar/font-2-size . 20)
         (polybar/font-3-size . 13)
         (dunst/font-size . 20)
         (dunst/max-icon-size . 88))

       (when (equal system-name "sunstreaker"))))
