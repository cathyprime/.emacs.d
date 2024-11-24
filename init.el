(setq custom-file "~/.emacs.d/custom.el")

(add-to-list 'package-archives
			 '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defun magda/fonts ()
  (set-face-font 'default "Iosevka-16"))

(defun magda/colorize-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point)))

(defun magda/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(add-hook 'compilation-filter-hook 'magda/colorize-buffer)

(if (daemonp)
	(add-hook 'after-make-frame-functions
			  (lambda (frame)
				(select-frame frame)
				(if (display-graphic-p frame)
					(magda/fonts))))
  (if (display-graphic-p)
	  (magda/fonts)))

(blink-cursor-mode)
(setq make-backup-files nil)
(setq create-lockfiles nil)

(global-set-key (kbd "M-&") 'with-editor-async-shell-command)
(global-set-key (kbd "C-,") 'magda/duplicate-line)
(global-set-key (kbd "<f4>") 'ibuffer)

(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-b"))

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq dired-isearch-filenames 'dwim)
(setq display-line-numbers-type t)
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
(show-paren-mode 1)
(delete-selection-mode 1)

(require 'package)
(require 'use-package)
(require 'ansi-color)

(load "~/.emacs.d/simpc.el")

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package multiple-cursors
  :ensure t
  :bind(("C-S-c" . 'mc/edit-lines)
		("C->" . 'mc/mark-next-like-this)
		("C-<" . 'mc/mark-previous-like-this)
		("C-c C-<" . 'mc/mark-all-like-this)
		("C-\"" . 'mc/skip-to-next-like-this)
		("C-:" . 'mc/skip-to-previous-like-this)))

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

(use-package ivy
  :ensure t
  :config (ivy-mode 1))

(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down))

(use-package ess
  :ensure t)

(use-package essgd
  :ensure t)

(use-package nov
  :ensure t)

(use-package god-mode
  :ensure t
  :init (setq god-mode-enable-function-key-translation nil)
  :config
  (global-set-key (kbd "<escape>") #'god-local-mode)
  (define-key god-local-mode-map (kbd ".") #'repeat))

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))

(use-package change-inner
  :ensure t
  :config
  (global-set-key (kbd "M-i") 'change-inner)
  (global-set-key (kbd "M-o") 'change-outer)
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package auctex
  :ensure t)

(load-file custom-file)
