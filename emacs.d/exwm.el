(use-package exwm
  :init
  (setq mouse-autoselect-window nil
        focus-follows-mouse t
        exwm-workspace-warp-cursor t
        exwm-workspace-number 5)
        ;exwm-workspace-display-echo-area-timeout 5
        ;exwm-workspace-minibuffer-position 'bottom) ;; Annoying focus issues
  :config
  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (pcase exwm-class-name
                ("Vimb" (exwm-workspace-rename-buffer (format "vimb: %s" exwm-title)))
                ("qutebrowser" (exwm-workspace-rename-buffer (format "Qutebrowser: %s" exwm-title))))))

  (exwm-enable)
  (require 'exwm-randr)
  (exwm-randr-enable)
  (setq exwm-randr-workspace-monitor-plist '(4 "eDP-1")))

(defun exwm/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun exwm/bind-function (key invocation &rest bindings)
  "Bind KEYs to FUNCTIONs globally"
  (while key
    (exwm-input-set-key (kbd key)
                        `(lambda ()
                           (interactive)
                           (funcall ',invocation)))
    (setq key (pop bindings)
          invocation (pop bindings))))

(defun exwm/bind-command (key command &rest bindings)
  "Bind KEYs to COMMANDs globally"
  (while key
    (exwm-input-set-key (kbd key)
                        `(lambda ()
                           (interactive)
                           (exwm/run-in-background ,command)))
    (setq key (pop bindings)
          command (pop bindings))))

(defun dn/exwm-init-hook ()
  ;; Launch Telega in workspace 0 if we've logged in before
  ;; (when (file-exists-p "~/.telega/db.sqlite")
  ;;   (telega nil))

  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Open eshell by default
  (eshell)

  ;; Launch apps that will run in the background
  (exwm/run-in-background "dunst")
  (exwm/run-in-background "nm-applet")
  (exwm/run-in-background "syncthing-gtk --minimized")
  (exwm/run-in-background "redshift -l 36.083286:-87.009861 -t 6500:3500"))

(use-package exwm
  :if dn/exwm-enabled
  :config
  ;(display-time-mode 1) ;; Not needed for now since we have a panel

  (add-hook 'exwm-mode-hook
            (lambda ()
              (evil-local-set-key 'motion (kbd "C-u") nil)))

  (require 'dn-exwm)

  (defun dn/setup-window-by-class ()
    (interactive)
    (pcase exwm-class-name
      ("qutebrowser" (exwm-workspace-move-window 2))
      ("qjackctl" (exwm-floating-toggle-floating))
      ("mpv" (exwm-floating-toggle-floating)
             (dn/exwm-floating-toggle-pinned))))

  ;; Do some post-init setup
  (add-hook 'exwm-init-hook #'dn/exwm-init-hook)

  ;; Manipulate windows as they're created
  (add-hook 'exwm-manage-finish-hook
            (lambda ()
              ;; Send the window where it belongs
              (dn/setup-window-by-class)))

              ;; Hide the modeline on all X windows
              ;(exwm-layout-hide-mode-line)))

  ;; Hide the modeline on all X windows
  (add-hook 'exwm-floating-setup-hook
            (lambda ()
              (exwm-layout-hide-mode-line))))

(use-package exwm-systemtray
  :disabled
  :if dn/exwm-enabled
  :after (exwm)
  :config
  (exwm-systemtray-enable)
  (setq exwm-systemtray-height 35))

(defun dn/run-xmodmap ()
  (interactive)
  (start-process-shell-command "xmodmap" nil "xmodmap ~/.Xmodmap"))

(defun dn/update-wallpapers ()
  (interactive)
  (start-process-shell-command
   "feh" nil
   (format "feh --bg-scale ~/.dotfiles/backgrounds/%s" (alist-get 'desktop/background dn/system-settings))))

(setq dn/panel-process nil)
(defun dn/kill-panel ()
  (interactive)
  (when dn/panel-process
    (ignore-errors
      (kill-process dn/panel-process)))
  (setq dn/panel-process nil))

(defun dn/start-panel ()
  (interactive)
  (dn/kill-panel)
  (setq dn/panel-process (start-process-shell-command "polybar" nil "polybar panel")))

(defun dn/update-screen-layout ()
  (interactive)
  (let ((layout-script "~/bin/update-screens"))
     (message "Running screen layout script: %s" layout-script)
     (start-process-shell-command "xrandr" nil layout-script)))

(defun dn/configure-desktop ()
  (interactive)
    (dn/run-xmodmap)
    (dn/update-screen-layout)
    (run-at-time "2 sec" nil (lambda () (dn/update-wallpapers))))

(defun dn/on-exwm-init ()
  (dn/configure-desktop)
  (dn/start-panel))

(when dn/exwm-enabled
  ;; Configure the desktop for first load
  (add-hook 'exwm-init-hook #'dn/on-exwm-init))

(defalias 'switch-to-buffer-original 'exwm-workspace-switch-to-buffer)

(defun dn/send-polybar-hook (name number)
  (start-process-shell-command "polybar-msg" nil (format "polybar-msg hook %s %s" name number)))

(defun dn/update-polybar-exwm (&optional path)
  (dn/send-polybar-hook "exwm" 1)
  (dn/send-polybar-hook "exwm-path" 1))

(defun dn/update-polybar-telegram ()
  (dn/send-polybar-hook "telegram" 1))

(defun dn/polybar-exwm-workspace ()
  (pcase exwm-workspace-current-index
    (0 "")
    (1 "")
    (2 "")
    (3 "")
    (4 "")))

(defun dn/polybar-exwm-workspace-path ()
  (let ((workspace-path (frame-parameter nil 'bufler-workspace-path-formatted)))
    (if workspace-path
        (substring-no-properties workspace-path)
      "")))

(defun dn/polybar-mail-count (max-count)
  (if dn/mail-enabled
    (let* ((mail-count (shell-command-to-string
                         (format "mu find --nocolor -n %s \"%s\" | wc -l" max-count dn/mu4e-inbox-query))))
      (format " %s" (string-trim mail-count)))
    ""))

(defun dn/telega-normalize-name (chat-name)
  (let* ((trimmed-name (string-trim-left (string-trim-right chat-name "}") "◀{"))
         (first-name (nth 0 (split-string trimmed-name " "))))
    first-name))

(defun dn/propertized-to-polybar (buffer-name)
  (if-let* ((text (substring-no-properties buffer-name))
            (fg-face (get-text-property 0 'face buffer-name))
            (fg-color (face-attribute fg-face :foreground)))
    (format "%%{F%s}%s%%{F-}" fg-color (dn/telega-normalize-name text))
    text))

(defun dn/polybar-telegram-chats ()
  (if (> (length tracking-buffers) 0)
    (format " %s" (string-join (mapcar 'dn/propertized-to-polybar tracking-buffers) ", "))
    ""))

(add-hook 'exwm-workspace-switch-hook #'dn/update-polybar-exwm)
(add-hook 'bufler-workspace-set-hook #'dn/update-polybar-exwm)

(when dn/exwm-enabled
  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\C-\M-j  ;; Buffer list
          ?\C-\M-k  ;; Browser list
          ?\C-\     ;; Ctrl+Space
          ?\C-\;))

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  (defun exwm/run-vimb ()
    (exwm/run-in-background "vimb")
    (exwm-workspace-switch-create 2))

  (defun exwm/run-qute ()
    (exwm/run-in-background "qutebrowser")
    (exwm-workspace-switch-create 2))

  (exwm/bind-function
   "s-o" 'exwm/run-qute)

  (exwm/bind-command
   "s-p" "playerctl play-pause"
   "s-[" "playerctl previous"
   "s-]" "playerctl next")

  (use-package desktop-environment
    :after exwm
    :config (desktop-environment-mode)
    :custom
    (desktop-environment-brightness-small-increment "2%+")
    (desktop-environment-brightness-small-decrement "2%-")
    (desktop-environment-brightness-normal-increment "5%+")
    (desktop-environment-brightness-normal-decrement "5%-"))

  ;; This needs a more elegant ASCII banner
  (defhydra hydra-exwm-move-resize (:timeout 4)
    "Move/Resize Window (Shift is bigger steps, Ctrl moves window)"
    ("j" (lambda () (interactive) (exwm-layout-enlarge-window 10)) "V 10")
    ("J" (lambda () (interactive) (exwm-layout-enlarge-window 30)) "V 30")
    ("k" (lambda () (interactive) (exwm-layout-shrink-window 10)) "^ 10")
    ("K" (lambda () (interactive) (exwm-layout-shrink-window 30)) "^ 30")
    ("h" (lambda () (interactive) (exwm-layout-shrink-window-horizontally 10)) "< 10")
    ("H" (lambda () (interactive) (exwm-layout-shrink-window-horizontally 30)) "< 30")
    ("l" (lambda () (interactive) (exwm-layout-enlarge-window-horizontally 10)) "> 10")
    ("L" (lambda () (interactive) (exwm-layout-enlarge-window-horizontally 30)) "> 30")
    ("C-j" (lambda () (interactive) (exwm-floating-move 0 10)) "V 10")
    ("C-S-j" (lambda () (interactive) (exwm-floating-move 0 30)) "V 30")
    ("C-k" (lambda () (interactive) (exwm-floating-move 0 -10)) "^ 10")
    ("C-S-k" (lambda () (interactive) (exwm-floating-move 0 -30)) "^ 30")
    ("C-h" (lambda () (interactive) (exwm-floating-move -10 0)) "< 10")
    ("C-S-h" (lambda () (interactive) (exwm-floating-move -30 0)) "< 30")
    ("C-l" (lambda () (interactive) (exwm-floating-move 10 0)) "> 10")
    ("C-S-l" (lambda () (interactive) (exwm-floating-move 30 0)) "> 30")
    ("f" nil "finished" :exit t))

  ;; Workspace switching
  (setq exwm-input-global-keys
        `(([?\s-\C-r] . exwm-reset)
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-r] . hydra-exwm-move-resize/body)
          ([?\s-e] . dired-jump)
          ([?\s-E] . (lambda () (interactive) (dired "~")))
          ([?\s-Q] . (lambda () (interactive) (kill-buffer)))
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-input-set-key (kbd "<s-return>") 'vterm)
  (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)
  (exwm-input-set-key (kbd "s-f") 'exwm-layout-toggle-fullscreen))
