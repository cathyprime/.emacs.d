(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)

(set-face-font 'default "Iosevka Nerd Font-18")
(blink-cursor-mode)
(setq make-backup-files nil)

(global-set-key (kbd "M-&") 'with-editor-async-shell-command)
(global-set-key (kbd "C-x C-b") 'buffer-menu)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq default-frame-alist '((undecorated . t)))
(setq dired-isearch-filenames 'dwim)
(setq display-line-numbers-type 'relative)
(setq ring-bell-function 'ignore)
(setq split-width-threshold nil)
(setq isearch-lazy-count t)
(setq lazy-count-prefix-format "(%s/%s) ")
(setq inhibit-startup-screen t)
(setq search-whitespace-regexp ".*?")
(setq-default tab-width 4)

(blink-cursor-mode 0)
(global-display-line-numbers-mode)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

(require 'package)
(require 'use-package)
(add-to-list 'package-archives
			 '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->")         'mc/mark-next-like-this)
  (global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
  (global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
  (global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this))
 
(use-package ido
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package smex
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'smex))

(use-package magit
  :ensure t)

(use-package modus-themes
  :ensure t)

(use-package wgrep
  :ensure t)
