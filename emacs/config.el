(org-indent-mode t)

;;(setq org-edit-src-content-indentation 0) ; Zera a margem dos blocos
;;(electric-indent-mode -1)                 ; Desliga a indentação automática

(setq inhibit-startup-message t)

(menu-bar-mode -1)            ; no menu bar
(tool-bar-mode -1)            ; no tools bar
(scroll-bar-mode -1)          ; no scroll bars
(tooltip-mode -1)             ; no tooltips
(set-fringe-mode 10)          ; frame edges set to 10px
(column-number-mode 1)        ; modeline shows column number
(save-place-mode 1)           ; remember cursor position
(recentf-mode 1)              ; remember recent files
(savehist-mode 1)             ; enable history saving

(global-display-line-numbers-mode 1) 
(setq display-line-numbers-type 'relative) 
(dolist (mode '(org-mode-hook
                vterm-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq-default indent-tabs-mode nil)

(delete-selection-mode t)

(global-hl-line-mode 1)

(global-visual-line-mode t)

(global-auto-revert-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(electric-pair-mode 1)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-=") 'text-scale-increase) 
(global-set-key (kbd "C--") 'text-scale-decrease)

(setq backup-directory-alist '((".*" . "~/.local/share/Trash/files")))

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

(set-face-attribute 'default nil :font "Anonymice Pro Nerd Font Bold Italic 13")
(set-face-attribute 'variable-pitch nil :font "Anonymice Pro Nerd Font Bold Italic 13")
(set-face-attribute 'fixed-pitch nil :font "Anonymice Pro Nerd Font Bold Italic 13")

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-undo-system 'undo-redo)
  (evil-mode))

(use-package evil-collection
  :after evil
  :config
  (add-to-list 'evil-collection-mode-list 'help) ;; evilify help mode
  (evil-collection-init))

(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit)
              :map minibuffer-local-map
              ("M-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)))

(use-package consult)

(use-package which-key
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-allow-imprecise-window-fit nil
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-separator " → "))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; Sets the default theme to load!!!
  (load-theme 'doom-moonlight t)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :hook
  (after-init . doom-modeline-mode)
  :custom
  (set-face-attribute 'mode-line nil :font "Anonymice Pro Nerd Font Bold Italic" :height 110) 
  (set-face-attribute 'mode-line-inactive nil :font "Anonymice Pro Nerd Font Bold Italic" :height 110) 
  :config
  (setq doom-modeline-enable-word-count t))

(use-package diminish)

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t)) 
(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode))

(defun ze/reload-settings () 
  (interactive)
  (load-file "~/.config/emacs/init.el"))

(defun ze/open-emacs-config () 
  (interactive)
  (find-file "~/.config/emacs/config.org"))

(defun ze/emacs-personal-files () 
  (interactive)
  (let((default-directory "~/.config/emacs"))
     (call-interactively 'find-file)))

(use-package general 
  :config
  (general-evil-setup)
  ;; set up 'SPC' as the global leader key
  (general-create-definer ze/leader-keys
    :states '(normal insert visual emacs) 
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode

  (ze/leader-keys
    "TAB TAB" '(comment-line :wk "Comment lines")) 

  ;; Buffer/bookmarks
  (ze/leader-keys
    "b" '(:ignore t :wk "Buffers/Bookmarks")
    "b b" '(switch-to-buffer :wk "Switch to buffer")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-current-buffer :wk "Kill current buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "q q" '(save-buffers-kill-terminal :wk "Quit emacs"))

  ;; Files
  (ze/leader-keys
    "f" '(:ignore t :wk "Files") 
    "." '(find-file :wk "Find file") 
    "f f" '(find-file :wk "Find file")
    "f p" '(ze/emacs-personal-files :wk "Open personal config files")
    "f c" '(ze/open-emacs-config :wk "Open emacs config.org"))

  ;; Helpers
  (ze/leader-keys
    "h" '(:ignore t :wk "Helpers")
    "h r r" '(ze/reload-settings :wk "Reload emacs settings")))

(add-hook 'org-mode-hook (lambda ()
           (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))

(setq org-edit-src-content-indentation 0) ; Zera a margem dos blocos
(electric-indent-mode -1)                 ; Desliga a indentação automática

(add-hook 'org-mode-hook 'org-indent-mode) 
(use-package org-bullets
:custom
(org-bullets-bullet-list '("▶" "▷" "◆" "◇" "▪" "▪" "▪")))  
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(require 'org-tempo)

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))

(use-package treemacs
  :bind
  (:map global-map
        ("M-\\" . treemacs))
  :config
  (setq treemacs-no-png-images t
        treemacs-is-never-other-window nil))

(use-package vterm
:config
(setq shell-file-name "/bin/bash"
      vterm-max-scrollback 5000))
  ;; Define a leader key for vterm
  (ze/leader-keys
    "t" '(:ignore t :which-key "terminal")
    "tt" '(open-vterm-split :which-key "open vterm"))
(defun open-vterm-split ()
  (interactive)
  (split-window-below 20) ;; Adjust the number to set the height of the vterm window
  (other-window 1)
  (vterm))

(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3"))

(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :custom
  (blacken-line-length 88))

(use-package lsp-mode
  :hook ((python-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :custom
  (electric-indent-mode 1)
(indent-region)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-idle-delay 0.1)
  (lsp-log-io nil)
  (lsp-completion-provider :capf)
  (lsp-prefer-capf t)
  (lsp-enable-symbol-highlighting nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-indentation nil)
  (lsp-enable-snippet nil)
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-file-watchers t) ;; Habilitar file watchers
  (lsp-file-watch-threshold 1000) ;; Limite de arquivos para watchers
  (setq lsp-file-watch-ignored-directory '("[/\\\\]\\.git$"
                                        "[/\\\\]\\.venv$"
                                        "[/\\\\]node_modules$"
                                        "[/\\\\]\\.cask$"
                                        "[/\\\\]\\.cache$"
                                        "[/\\\\]\\.python-version$"
                                        "[/\\\\]\\.mypy_cache$"
                                        "[/\\\\]\\.pytest_cache$"
                                        "[/\\\\]\\.pyre$"
                                        "[/\\\\]\\.ruff_cache$")))


(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-max-width 150)
  (lsp-ui-doc-max-height 30)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-ignore-duplicate t))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  :custom
  (lsp-pyright-python-executable-cmd "python3"))
