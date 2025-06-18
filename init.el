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
  (global-set-key (kbd "M-<up>") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down)
  (global-set-key (kbd "M-<down>") 'move-text-down))

(use-package ess
  :ensure t)

(use-package essgd
  :ensure t)

(use-package nov
  :ensure t)

(use-package meow
  :ensure t)
(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(require 'meow)
(meow-setup)
(meow-global-mode 1)

(load-file custom-file)
(put 'narrow-to-region 'disabled nil)
