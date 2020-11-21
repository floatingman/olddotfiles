;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "*** Emacs loaded in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			(time-subtract after-init-time before-init-time)))
		     gcs-done)))

;; Keep transient cruft out of ~/.emacs.d/
(setq user-emacs-directory "~/.cache/emacs/"
backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
url-history-file (expand-file-name "url/history" user-emacs-directory)
auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-emacs-directory)
projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" user-emacs-directory))

;; Keep customization settings in a temporary file (thanks Ambrevar!)
(setq custom-file
(if (boundp 'server-socket-dir)
	  (expand-file-name "custom.el" server-socket-dir)
	(expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))


(package-initialize)
(unless package-archive-contents
   (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))
(require 'use-package)

;; Uncomment this to get a reading on packages that get loaded at startup
;; (setq use-package-verbose t)

;; ensure packages by default
(setq use-package-always-ensure t)

;; Add my elisp path to load-path
(push "~/.emacs.d/elisp" load-path)

;; Helper function for changing OS platform keywords to system-type strings
(defun platform-keyword-to-string (platform-keyword)
  (cond
   ((eq platform-keyword 'windows) "windows-nt")
   ((eq platform-keyword 'cygwin) "cygwin")
   ((eq platform-keyword 'osx) "darwin")
   ((eq platform-keyword 'linux) "gnu/linux")))

;; Define a macro that runs an elisp expression only on a particular platform
(defmacro on-platform-do (&rest platform-expressions)
  `(cond
    ,@(mapcar
 (lambda (platform-expr)
     (let ((keyword (nth 0 platform-expr))
	   (expr (nth 1 platform-expr)))
 `(,(if (listp keyword)
	 `(or
	   ,@(mapcar
	(lambda (kw) `(string-equal system-type ,(platform-keyword-to-string kw)))
	keyword))
	  `(string-equal system-type ,(platform-keyword-to-string keyword)))
	  ,expr)))
 platform-expressions)))

;; Check if GUI is running
(defconst my/gui? (display-graphic-p))

(server-start)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(defun dn/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(defun dn/dont-arrow-me-bro ()
  (interactive)
  (message "Arrow keys are bad, you know?"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  :config
  (add-hook 'evil-mode-hook 'dn/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;; Disable arrow keys in normal and visual modes
  (define-key evil-normal-state-map (kbd "<left>") 'dn/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<right>") 'dn/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<down>") 'dn/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<up>") 'dn/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<left>") 'dn/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<right>") 'dn/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<down>") 'dn/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<up>") 'dn/dont-arrow-me-bro)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer dn/leader-key-def
			  :keymaps '(normal insert visual emacs)
			  :prefix "SPC"
			  :global-prefix "C-SPC")
  (general-create-definer dn/ctrl-c-keys
			  :prefix "C-c"))

; Thanks, but no thanks
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; disable dialog boxes
(setq use-dialog-box nil)

;; Changes all yes/no questions to y/n type.
(fset 'yes-or-no-p 'y-or-n-p)

;; Confirm emacs exit when in gui mode
(when (window-system)
  (setq confirm-kill-emacs 'yes-or-no-p))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(column-number-mode)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
		prog-mode-hook
		conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq large-file-warning-threshold nil)

(setq vc-follow-symlinks t)

(setq ad-redefinition-action 'accept)

(use-package spacegray-theme :defer t)
(use-package doom-themes :defer t)
(load-theme 'doom-palenight t)
(doom-themes-visual-bell-config)

(use-package all-the-icons
  :when my/gui?
  :commands (all-the-icons-octicon
             all-the-icons-faicon
             all-the-icons-fileicon
             all-the-icons-wicon
             all-the-icons-material
             all-the-icons-alltheicon)

  :config
  ;; IMPORTANT: changing the variables below may require restarting
  ;; Emacs.
  ;; IMPORTANT: if placeholders are being displayed instead of icons
  ;; see https://github.com/domtronn/all-the-icons.el#troubleshooting

  (setq all-the-icons-ivy-rich-icon-size 1.0)

  ;; Icons by file name.
  (add-to-list 'all-the-icons-icon-alist '("\\.conf$" all-the-icons-octicon "settings" :height 1.0 :v-adjust 0.0 :face all-the-icons-dyellow))
  (add-to-list 'all-the-icons-icon-alist '("\\.service$" all-the-icons-octicon "settings" :height 1.0 :v-adjust 0.0 :face all-the-icons-dyellow))
  (add-to-list 'all-the-icons-icon-alist '("^config$" all-the-icons-octicon "settings" :height 1.0 :v-adjust 0.0 :face all-the-icons-dyellow))

  ;; Icons by directory name.
  (add-to-list 'all-the-icons-dir-icon-alist '("emacs" all-the-icons-fileicon "emacs"))
  (add-to-list 'all-the-icons-dir-icon-alist '("emacs\\.d" all-the-icons-fileicon "emacs"))
  (add-to-list 'all-the-icons-dir-icon-alist '("spec" all-the-icons-fileicon "test-dir")))


;; Ivy/counsel integration for `all-the-icons'.
(use-package all-the-icons-ivy
  :when my/gui?
  :after (ivy counsel-projectile)
  :config
  ;; Adds icons to counsel-projectile-find-file as well.
  (setq all-the-icons-ivy-file-commands '(counsel-projectile-find-file))

  (all-the-icons-ivy-setup))


;; Displays icons for all buffers in Ivy.
(use-package all-the-icons-ivy-rich
  :when my/gui?
  :init (all-the-icons-ivy-rich-mode 1))


;; Adds dired support to all-the-icons.
(use-package all-the-icons-dired
  :when my/gui?
  :defer t
  :hook (dired-mode . all-the-icons-dired-mode))

;; Set the font face based on platform
(on-platform-do
 ((windows cygwin) (set-face-attribute 'default nil :font "Fira Mono:antialias=subpixel" :height 130))
  (osx (set-face-attribute 'default nil :font "Fira Mono" :height 170))
  (linux (set-face-attribute 'default nil :font "Fira Code Retina" :height 150)))

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 130)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 165 :weight 'regular)

(defun dn/replace-unicode-font-mapping (block-name old-font new-font)
  (let* ((block-idx (cl-position-if
			 (lambda (i) (string-equal (car i) block-name))
			 unicode-fonts-block-font-mapping))
	 (block-fonts (cadr (nth block-idx unicode-fonts-block-font-mapping)))
	 (updated-block (cl-substitute new-font old-font block-fonts :test 'string-equal)))
    (setf (cdr (nth block-idx unicode-fonts-block-font-mapping))
	  `(,updated-block))))

(use-package unicode-fonts
  :ensure t
  :custom
  (unicode-fonts-skip-font-groups '(low-quality-glyphs))
  :config
  ;; Fix the font mappings to use the right emoji font
  (mapcar
    (lambda (block-name)
(dn/replace-unicode-font-mapping block-name "Apple Color Emoji" "Noto Color Emoji"))
    '("Dingbats"
"Emoticons"
"Miscellaneous Symbols and Pictographs"
"Transport and Map Symbols"))
  (unicode-fonts-setup))

(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(use-package default-text-scale
  :when my/gui?
  :defer t
  :init
  (general-define-key
   "M-=" #'default-text-scale-increase
   "M--" #'default-text-scale-decrease
   "M-0" #'default-text-scale-reset))

(setq display-time-format "%l:%M %p %b %y"
display-time-default-load-average nil)

(use-package diminish)

;; You must run (all-the-icons-install-fonts) one time after
;; installing this package!

(use-package minions
  :hook (doom-modeline-mode . minions-mode)
  :custom
  (minions-mode-line-lighter ""))

(use-package doom-modeline
  :after eshell     ;; Make sure it gets hooked after eshell
  :hook (after-init . doom-modeline-init)
  :custom-face
  (mode-line ((t (:height 0.85))))
  (mode-line-inactive ((t (:height 0.85))))
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-mode-icon nil))

(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifications))

(use-package super-save
  :ensure t
  :defer 1
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

(global-auto-revert-mode 1)

(dn/leader-key-def
  "t"  '(:ignore t :which-key "toggles")
  "tw" 'whitespace-mode
  "tt" '(counsel-load-theme :which-key "choose theme"))

(use-package sudo-edit)

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(setq-default indent-tabs-mode nil)

(use-package hydra
  :defer 1)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)

  ;; Use different regex strategies per completion command
  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist) ;; This doesn't seem to work...
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)

  ;; Set minibuffer height for different commands
  (setf (alist-get 'counsel-projectile-ag ivy-height-alist) 15)
  (setf (alist-get 'counsel-projectile-rg ivy-height-alist) 15)
  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))

(use-package ivy-hydra
  :defer t
  :after hydra)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
	      (plist-put ivy-rich-display-transformers-list
		               'ivy-switch-buffer
		               '(:columns
		                 ((ivy-rich-candidate (:width 40))
		                  (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
		                  (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
		                  (ivy-rich-switch-buffer-project (:width 15 :face success))             ; return project name using `projectile'
		                  (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))  ; return file path relative to project root or `default-directory' if project is nil
		                 :predicate
		                 (lambda (cand)
		                   (if-let ((buffer (get-buffer cand)))
			                     ;; Don't mess with EXWM buffers
			                     (with-current-buffer buffer
			                       (not (derived-mode-p 'exwm-mode)))))))))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 ("C-M-l" . counsel-imenu)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package flx  ;; Improves sorting for fuzzy-matched results
  :defer t
  :init
  (setq ivy-flx-limit 10000))

(use-package smex ;; Adds M-x recent command sorting for counsel-M-x
  :defer 1
  :after counsel)

(use-package wgrep)

(use-package ivy-posframe
  :custom
  (ivy-posframe-width      115)
  (ivy-posframe-min-width  115)
  (ivy-posframe-height     10)
  (ivy-posframe-min-height 10)
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  (setq ivy-posframe-parameters '((parent-frame . nil)
				  (left-fringe . 8)
				  (right-fringe . 8)))
  (ivy-posframe-mode 1))

(dn/leader-key-def
  "r"   '(ivy-resume :which-key "ivy resume")
  "f"   '(:ignore t :which-key "files")
  "ff"  '(counsel-find-file :which-key "open file")
  "C-f" 'counsel-find-file
  "fr"  '(counsel-recentf :which-key "recent files")
  "fR"  '(revert-buffer :which-key "revert file")
  "fj"  '(counsel-file-jump :which-key "jump to file"))

(use-package avy
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))

(dn/leader-key-def
  "j" '(:ignore t :which-key "jump")
  "jj" '(avy-goto-char :which-key "jump to char")
  "jw" '(avy-goto-word-0 :which-key "jump to word")
  "jl" '(avy-goto-line :which-key "jump to line"))

(use-package dired
  :ensure nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
    (lambda ()
    (interactive)
    (dired-collapse)))
  
	(use-package all-the-icons-dired)
  
  (add-hook 'dired-mode-hook
    (lambda ()
    (interactive)
    (dired-omit-mode 1)
    (unless (s-equals? "/gnu/store/" (expand-file-name default-directory))
      (all-the-icons-dired-mode 1))
    (hl-line-mode 1)))

  (use-package dired-rainbow
    :defer 2
    :config
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

  (use-package dired-single
    :ensure t
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "p" 'dired-ranger-paste))

(defun dn/dired-link (path)
  (lexical-let ((target path))
    (lambda () (interactive) (message "Path: %s" target) (dired target))))

(dn/leader-key-def
  "d"   '(:ignore t :which-key "dired")
  "dd"  '(dired :which-key "Here")
  "dh"  `(,(dn/dired-link "~") :which-key "Home")
  "dn"  `(,(dn/dired-link "~/Notes") :which-key "Notes")
  "do"  `(,(dn/dired-link "~/Downloads") :which-key "Downloads")
  "dr"  `(,(dn/dired-link "~/Repos") :which-key "Repos")
  "d."  `(,(dn/dired-link "~/.dotfiles") :which-key "dotfiles")
  "de"  `(,(dn/dired-link "~/.emacs.d") :which-key ".emacs.d"))

(use-package openwith
  :config
  (setq openwith-associations
    (list
      (list (openwith-make-extension-regexp
             '("mpg" "mpeg" "mp3" "mp4"
               "avi" "wmv" "wav" "mov" "flv"
               "ogm" "ogg" "mkv"))
             "mpv"
             '(file))
      (list (openwith-make-extension-regexp
             '("xbm" "pbm" "pgm" "ppm" "pnm"
               "png" "gif" "bmp" "tif" "jpeg")) ;; Removed jpg because Telega was
                                                ;; causing feh to be opened...
             "feh"
             '(file))
      (list (openwith-make-extension-regexp
             '("pdf"))
             "zathura"
             '(file))))
  (openwith-mode 1))

;; TODO: Mode this to another section
(setq-default fill-column 80)

;; Turn on indentation and auto-fill mode for Org files
(defun dn/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)
  (diminish org-indent-mode))

(use-package org
  :defer t
  :hook (org-mode . dn/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        org-startup-folded 'content
        org-cycle-separator-lines 2)

  (setq org-modules
    '(org-crypt
        org-habit
        org-bookmark
        org-eshell
        org-irc))

  (setq org-refile-targets '((nil :maxlevel . 3)
                            (org-agenda-files :maxlevel . 3)))
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup)

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (ledger . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes)

  ;; NOTE: Subsequent sections are still part of this use-package block!

(require 'dn-org)

;; Since we don't want to disable org-confirm-babel-evaluate all
;; of the time, do it around the after-save-hook
(defun dn/org-babel-tangle-dont-ask ()
  ;; Dynamic scoping to the rescue
  (let ((org-confirm-babel-evaluate nil))
    (org-babel-tangle)))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'dn/org-babel-tangle-dont-ask
                                              'run-at-end 'only-in-org-mode)))

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
;; (font-lock-add-keywords 'org-mode
;;                         '(("^ *\\([-]\\) "
;;                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; TODO: Others to consider
;; '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;; '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;; '(org-property-value ((t (:inherit fixed-pitch))) t)
;; '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;; '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
;; '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;; '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(setq org-directory "~/Notes")

(defun dn/org-path (path)
  (expand-file-name path org-directory))

(setq org-journal-dir (dn/org-path "Journal/"))

(defun dn/get-todays-journal-file-name ()
  "Gets the journal file name for today's date"
  (interactive)
  (let* ((journal-file-name
           (expand-file-name
             (format-time-string "%Y/%Y-%2m-%B.org")
             org-journal-dir))
         (journal-year-dir (file-name-directory journal-file-name)))
    (if (not (file-directory-p journal-year-dir))
      (make-directory journal-year-dir))
    journal-file-name))

(setq org-default-notes-file (dn/org-path "Projects.org"))

(setq org-agenda-files
  (list
    (dn/org-path "Habits.org")
    (dn/org-path "Work.org")
    (dn/org-path "Calendar/Personal.org")
    (dn/org-path "Calendar/Work.org")
    (dn/org-path "Projects.org")))
    ;(dn/get-todays-journal-file-name)))

(setq org-agenda-window-setup 'other-window)
(setq org-agenda-span 'day)
(setq org-stuck-projects '("+LEVEL=2/TODO" ("NEXT") nil ""))
(setq org-agenda-start-with-log-mode t)

;; Configure custom agenda views
(setq org-agenda-custom-commands
  '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "PROC" ((org-agenda-overriding-header "Process Tasks")))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
      ;; (todo "TODO"
      ;;   ((org-agenda-overriding-header "Unprocessed Inbox Tasks")
      ;;    (org-agenda-files `(,dn/org-inbox-path))
      ;;    (org-agenda-text-search-extra-files nil)))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("p" "Active Projects"
     ((agenda "")
      (todo "ACTIVE"
        ((org-agenda-overriding-header "Active Projects")
         (org-agenda-max-todos 5)
         (org-agenda-files org-agenda-files)))))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))

    ;; Projects on hold
    ("h" tags-todo "+LEVEL=2/+HOLD"
     ((org-agenda-overriding-header "On-hold Projects")
      (org-agenda-files org-agenda-files)))

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))))

;; Configure common tags
(setq org-tag-alist
  '((:startgroup)
     ; Put mutually exclusive tags here
     (:endgroup)
     ("@errand" . ?E)
     ("@home" . ?H)
     ("@work" . ?W)
     ("agenda" . ?a)
     ("planning" . ?p)
     ("publish" . ?P)
     ("batch" . ?b)
     ("note" . ?n)
     ("idea" . ?i)
     ("thinking" . ?t)
     ("recurring" . ?r)))

;; Configure task state change tag triggers
;; (setq org-todo-state-tags-triggers
;;   (quote (("CANC" ("cancelled" . t))
;;           ("WAIT" ("waiting" . t))
;;           ("HOLD" ("waiting") ("onhold" . t))
;;           (done ("waiting") ("onhold"))
;;           ("TODO" ("waiting") ("cancelled") ("onhold"))
;;           ("DONE" ("waiting") ("cancelled") ("onhold")))))

;; Configure TODO settings
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-datetree-add-timestamp 'inactive)
(setq org-habit-graph-column 60)
(setq org-fontify-whole-heading-line t)
(setq org-todo-keywords
  '((sequence "TODO(t)" "NEXT(n)" "PROC" "|" "DONE(d!)")
    (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")
    (sequence "GOAL(g)" "|" "ACHIEVED(v)" "MAINTAIN(m)")))

(use-package org-journal
  :defer t
  :custom
  (org-journal-file-type 'daily)
  (org-journal-date-format "%B %d, %Y - %A")
  (org-journal-dir "~/Notes/Journal/")
  (org-journal-time-format "%-l:%M %p - ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-enable-agenda-integration t))

(defun dn/read-file-as-string (path)
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-string)))

(setq org-capture-templates
  `(("t" "Tasks / Projects")
    ("tt" "Task" entry (file+olp ,(dn/org-path "Projects.org") "Projects" "Inbox")
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
    ("ts" "Clocked Entry Subtask" entry (clock)
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
    ("tp" "New Project" entry (file+olp ,(dn/org-path "Projects.org") "Projects" "Inbox")
         "* PLAN %?\n  %U\n  %a\n  %i" :empty-lines 1)

    ("j" "Journal Entries")
    ("jj" "Journal" entry
         (file+olp+datetree ,(dn/get-todays-journal-file-name))
         ;"\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
         ,(dn/read-file-as-string "~/Notes/Templates/Daily.org")
         :clock-in :clock-resume
         :empty-lines 1)
    ("jm" "Meeting" entry
         (file+olp+datetree ,(dn/get-todays-journal-file-name))
         "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
         :clock-in :clock-resume
         :empty-lines 1)
    ("jt" "Thinking" entry
         (file+olp+datetree ,(dn/get-todays-journal-file-name))
         "\n* %<%I:%M %p> - %^{Topic} :thoughts:\n\n%?\n\n"
         :clock-in :clock-resume
         :empty-lines 1)
    ("jc" "Clocked Entry Notes" entry
         (file+olp+datetree ,(dn/get-todays-journal-file-name))
         "* %<%I:%M %p> - %K :notes:\n\n%?"
         :empty-lines 1)
    ("jg" "Clocked General Task" entry
         (file+olp+datetree ,(dn/get-todays-journal-file-name))
         "* %<%I:%M %p> - %^{Task description} %^g\n\n%?"
         :clock-in :clock-resume
         :empty-lines 1)

    ("w" "Workflows")
    ("we" "Checking Email" entry (file+olp+datetree ,(dn/get-todays-journal-file-name))
         "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

    ("m" "Metrics Capture")
    ("mw" "Weight" table-line (file+headline "~/Notes/Metrics.org" "Weight")
     "| %U | %^{Weight} | %^{Notes} |" :kill-buffer)
    ("mp" "Blood Pressure" table-line (file+headline "~/Notes/Metrics.org" "Blood Pressure")
     "| %U | %^{Systolic} | %^{Diastolic} | %^{Notes}" :kill-buffer)))

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))

(use-package org-pomodoro
  :after org
  :config
  (setq org-pomodoro-start-sound "~/.emacs.d/sounds/focus_bell.wav")
  (setq org-pomodoro-short-break-sound "~/.emacs.d/sounds/three_beeps.wav")
  (setq org-pomodoro-long-break-sound "~/.emacs.d/sounds/three_beeps.wav")
  (setq org-pomodoro-finished-sound "~/.emacs.d/sounds/meditation_bell.wav")

  (dn/leader-key-def
    "op"  '(org-pomodoro :which-key "pomodoro")))

(require 'org-protocol)

(defun dn/search-org-files ()
  (interactive)
  (counsel-rg "" "~/Notes" nil "Search Notes: "))

(use-package evil-org
  :after org
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode)
         (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(dn/leader-key-def
  "o"   '(:ignore t :which-key "org mode")

  "oi"  '(:ignore t :which-key "insert")
  "oil" '(org-insert-link :which-key "insert link")

  "on"  '(org-toggle-narrow-to-subtree :which-key "toggle narrow")

  "os"  '(dn/counsel-rg-org-files :which-key "search notes")

  "oa"  '(org-agenda :which-key "status")
  "oc"  '(org-capture t :which-key "capture")
  "ox"  '(org-export-dispatch t :which-key "export"))

;; This ends the use-package org-mode block
)

(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

(defun dn/org-start-presentation ()
  (interactive)
  (org-tree-slide-mode 1)
  (setq text-scale-mode-amount 3)
  (text-scale-mode 1))

(defun dn/org-end-presentation ()
  (interactive)
  (text-scale-mode 0)
 	(org-tree-slide-mode 0))

(use-package org-tree-slide
  :defer t
  :after org
  :commands org-tree-slide-mode
  :config
  (evil-define-key 'normal org-tree-slide-mode-map
    (kbd "q") 'dn/org-end-presentation
    (kbd "C-j") 'org-tree-slide-move-next-tree
    (kbd "C-k") 'org-tree-slide-move-previous-tree)
  (setq org-tree-slide-slide-in-effect nil
        org-tree-slide-activate-message "Presentation started."
        org-tree-slide-deactivate-message "Presentation ended."
        org-tree-slide-header t))

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets)

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :defer t
  :hook (org-mode
	 emacs-lisp-mode
	 web-mode
	 typescript-mode
	 js2-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(global-set-key (kbd "C-M-;") 'magit-status)

(dn/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

(use-package magit-todos
	:defer t)

(use-package git-link
  :commands git-link
  :config
  (setq git-link-open-in-browser t)
  (dn/leader-key-def
    "gL" 'git-link))

(use-package git-gutter
  :diminish
  :hook ((text-mode . git-gutter-mode)
	 (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2)

  (use-package git-gutter-fringe)
  (set-face-foreground 'git-gutter-fr:added "LightGreen")
  (fringe-helper-define 'git-gutter-fr:added nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

   (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
   (fringe-helper-define 'git-gutter-fr:modified nil
"XXXXXXXXXX"
"XXXXXXXXXX"
"XXXXXXXXXX"
".........."
".........."
"XXXXXXXXXX"
"XXXXXXXXXX"
"XXXXXXXXXX"
".........."
".........."
"XXXXXXXXXX"
"XXXXXXXXXX"
"XXXXXXXXXX")

    (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
    (fringe-helper-define 'git-gutter-fr:deleted nil
"XXXXXXXXXX"
"XXXXXXXXXX"
"XXXXXXXXXX"
".........."
".........."
"XXXXXXXXXX"
"XXXXXXXXXX"
"XXXXXXXXXX"
".........."
".........."
"XXXXXXXXXX"
"XXXXXXXXXX"
"XXXXXXXXXX")

  ;; These characters are used in terminal mode
  (setq git-gutter:modified-sign "≡")
  (setq git-gutter:added-sign "≡")
  (setq git-gutter:deleted-sign "≡")
  (set-face-foreground 'git-gutter:added "LightGreen")
  (set-face-foreground 'git-gutter:modified "LightGoldenrod")
  (set-face-foreground 'git-gutter:deleted "LightCoral"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Repos")
    (setq projectile-project-search-path '("~/Repos")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile)

(dn/leader-key-def
  "pf" 'counsel-projectile-find-file
  "ps" 'counsel-projectile-switch-project
  "pF" 'counsel-projectile-rg
  "pp" 'counsel-projectile
  "pc" 'projectile-compile-project
  "pd" 'projectile-dired)

(use-package ivy-xref
  :init (if (< emacs-major-version 27)
	  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
	  (setq xref-show-definitions-function #'ivy-xref-show-defs)))

(use-package lsp-mode
  :commands lsp
  :hook ((typescript-mode js2-mode web-mode) . lsp)
  :bind (:map lsp-mode-map
	 ("TAB" . completion-at-point)))
(dn/leader-key-def
  "l"  '(:ignore t :which-key "lsp")
  "ld" 'xref-find-definitions
  "lr" 'xref-find-references
  "ln" 'lsp-ui-find-next-reference
  "lp" 'lsp-ui-find-prev-reference
  "ls" 'counsel-imenu
  "le" 'lsp-ui-flycheck-list
  "lS" 'lsp-ui-sideline-mode
  "lX" 'lsp-execute-code-action)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show))

(use-package lispy
  :hook ((emacs-lisp-mode . lispy-mode)
	 (scheme-mode . lispy-mode)))

(use-package lispyville
  :disabled
  :hook ((lispy-mode . lispyville-mode))
  :config
  (lispyville-set-key-theme '(operators c-w additiona)))

(use-package sly
  :disabled t
  :mode "\\.lisp\\'")

(use-package slime
  :mode "\\.lisp\\'")

;; TODO: This causes issues for some reason.
  ;; :bind (:map geiser-mode-map
  ;;        ("TAB" . completion-at-point))

(use-package geiser
  :ensure t
  :config
  (setq geiser-default-implementation 'gambit)
  (setq geiser-active-implementations '(gambit guile))
  (setq geiser-repl-default-port 44555) ; For Gambit Scheme
  (setq geiser-implementations-alist '(((regexp "\\.scm$") gambit)
				 ((regexp "\\.sld") gambit))))

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)

(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package nvm
  :defer t)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(defun dn/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-wdith js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'dn/set-js-indentation)
  (add-hook 'json-mode-hook #'dn/set-js-indentation))

(use-package prettier-js
  :hook ((js2-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode))
  :config
  (setq prettier-js-show-errors nil))

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package posframe)

  (use-package command-log-mode
    :ensure t
    :after posframe)

  (setq dn/command-window-frame nil)

  (defun dn/toggle-command-window ()
    (interactive)
    (if dn/command-window-frame
	(progn
	  (posframe-delete-frame clm/command-log-buffer)
	  (setq dn/command-window-frame nil))
	(progn
	  (global-command-log-mode t)
	  (with-current-buffer
	    (setq clm/command-log-buffer
		  (get-buffer-create " *command-log*"))
	    (text-scale-set -1))
	  (setq dn/command-window-frame
	    (posframe-show
	      clm/command-log-buffer
	      :position `(,(- (x-display-pixel-width) 650) . 50)
	      :width 35
	      :height 5
	      :min-width 35
	      :min-height 5
	      :internal-border-width 2
	      :internal-border-color "#c792ea"
	      :override-parameters '((parent-frame . nil)))))))
(dn/leader-key-def
  "tc" 'dn/toggle-command-window)

(dn/leader-key-def
	"a" '(:ignore t :which-key "apps"))

(defun read-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun dn/get-current-package-version ()
  (interactive)
  (let ((package-json-file (concat (eshell/pwd) "/package.json")))
    (when (file-exists-p package-json-file)
      (let* ((package-json-contents (read-file package-json-file))
             (package-json (ignore-errors (json-parse-string package-json-contents))))
        (when package-json
          (ignore-errors (gethash "version" package-json)))))))

(defun dn/map-line-to-status-char (line)
  (cond ((string-match "^?\\? " line) "?")))

(defun dn/get-git-status-prompt ()
  (let ((status-lines (cdr (process-lines "git" "status" "--porcelain" "-b"))))
    (seq-uniq (seq-filter 'identity (mapcar 'dn/map-line-to-status-char status-lines)))))

(defun dn/get-prompt-path ()
  (let* ((current-path (eshell/pwd))
         (git-output (shell-command-to-string "git rev-parse --show-toplevel"))
         (has-path (not (string-match "^fatal" git-output))))
    (if (not has-path)
      (abbreviate-file-name current-path)
      (string-remove-prefix (file-name-directory git-output) current-path))))

;; This prompt function mostly replicates my custom zsh prompt setup
;; that is powered by github.com/denysdovhan/spaceship-prompt.
(defun dn/eshell-prompt ()
  (let ((current-branch (magit-get-current-branch))
        (package-version (dn/get-current-package-version)))
    (concat
     "\n"
     (propertize (system-name) 'face `(:foreground "#62aeed"))
     (propertize " ॐ " 'face `(:foreground "white"))
     (propertize (dn/get-prompt-path) 'face `(:foreground "#82cfd3"))
     (when current-branch
       (concat
        (propertize " • " 'face `(:foreground "white"))
        (propertize (concat " " current-branch) 'face `(:foreground "#c475f0"))))
     (when package-version
       (concat
        (propertize " @ " 'face `(:foreground "white"))
        (propertize package-version 'face `(:foreground "#e8a206"))))
     (propertize " • " 'face `(:foreground "white"))
     (propertize (format-time-string "%I:%M:%S %p") 'face `(:foreground "#5a5b7f"))
     (if (= (user-uid) 0)
         (propertize "\n#" 'face `(:foreground "red2"))
       (propertize "\nλ" 'face `(:foreground "#aece4a")))
     (propertize " " 'face `(:foreground "white")))))

  (add-hook 'eshell-banner-load-hook
          '(lambda ()
             (setq eshell-banner-message
                   (concat "\n" (propertize " " 'display (create-image "~/.dotfiles/.emacs.d/images/flux_banner.png" 'png nil :scale 0.2 :align-to "center")) "\n\n"))))

(defun dn/eshell-configure ()
  (require 'evil-collection-eshell)
  (evil-collection-eshell-setup)

  (use-package xterm-color)

  (push 'eshell-tramp eshell-modules-list)
  (push 'xterm-color-filter eshell-preoutput-filter-functions)
  (delq 'eshell-handle-ansi-color eshell-output-filter-functions)

  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  (add-hook 'eshell-before-prompt-hook
            (lambda ()
              (setq xterm-color-preserve-properties t)))

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; We want to use xterm-256color when running interactive commands
  ;; in eshell but not during other times when we might be launching
  ;; a shell command to gather its output.
  (add-hook 'eshell-pre-command-hook
            '(lambda () (setenv "TERM" "xterm-256color")))
  (add-hook 'eshell-post-command-hook
            '(lambda () (setenv "TERM" "dumb")))

  ;; Use Ivy to provide completions in eshell
  (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)

  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setenv "PAGER" "cat")

  (setq eshell-prompt-function      'dn/eshell-prompt
        eshell-prompt-regexp        "^λ "
        eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-highlight-prompt t
        eshell-scroll-to-bottom-on-input t
        eshell-prefer-lisp-functions nil))

(use-package eshell
  :hook (eshell-first-time-mode . dn/eshell-configure)
  :init
  (setq eshell-directory-name "~/.emacs.d/eshell/"))

(use-package eshell-z
  :hook ((eshell-mode . (lambda () (require 'eshell-z)))
         (eshell-z-change-dir .  (lambda () (eshell/pushd (eshell/pwd))))))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(dn/leader-key-def
  "SPC" 'eshell)

(with-eval-after-load 'esh-opt
  (setq eshell-destroy-buffer-when-process-dies t)
  (setq eshell-visual-commands '("htop" "zsh" "vim")))

(use-package fish-completion
  :hook (eshell-mode . fish-completion-mode))

(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode)
  :config
  (setq	esh-autosuggest-delay 0.5)
  (set-face-foreground 'company-preview-common "#4b5668")
  (set-face-background 'company-preview nil))

(use-package eshell-toggle
  :bind ("C-M-'" . eshell-toggle)
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil))

(use-package vterm
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(use-package elfeed
  :commands elfeed
  :config
  (setq elfeed-feeds
        '("https://nullprogram.com/feed/"
          "https://ambrevar.xyz/atom.xml"
          "https://guix.gnu.org/feeds/blog.atom"
          "https://valdyas.org/fading/feed/"
          "https://www.reddit.com/r/emacs/.rss")))

(use-package emms
  :commands emms
  :config
  (require 'emms-setup)
  (emms-standard)
  (emms-default-players)
  (emms-mode-line-disable)
  (setq emms-source-file-default-directory "/mnt/perceptormedia/Audio/music/")
  (dn/leader-key-def
    "am" '(:ignore t :which-key "media")
    "amp" '(emms-pause :which-key "play / pause")
    "amf" '(emms-play-file :which-key "play file")))

(use-package pulseaudio-control
  :commands pulseaudio-control-select-sink-by-name
  :config
  (setq pulseaudio-control-pactl-path "/usr/sbin/pactl"))
