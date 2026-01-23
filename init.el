(setq custom-file "~/.emacs.d/custom.el")

(add-to-list 'package-archives
			 '("melpa" . "https://melpa.org/packages/") t)

(defun magda/fonts ()
  (interactive)
  (set-face-font 'default "Iosevka NFM Medium")
  (set-face-attribute 'default nil :height 200))

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

(defun magda/compile-wrap-login-shell (orig-fun &rest args)
  "Wrap the compile command in `bash --login -c` only for plink TRAMP projects.
Does not modify `compile-command`, just passes a wrapped string to the original function."
  (let ((cmd (or (car args) compile-command)))
    (if (and default-directory
             (string-prefix-p "/plink:" default-directory))
        ;; Pass wrapped command to original function
        (apply orig-fun
               (list (format "bash --login -c %s"
                             (shell-quote-argument cmd))))
      ;; Otherwise, just call original function normally
      (apply orig-fun args))))

(defun magda/strip-login-shell-hook ()
  "Strip leading `bash --login -c` from `compile-command` if in a plink TRAMP buffer."
  ;; Only act if default-directory starts with /plink:Zone_
  (when (and default-directory
             (string-prefix-p "/plink:Zone_" default-directory))
    (message "Running compile in TRAMP plink buffer: %s" default-directory)
    ;; Strip bash wrapper if present
    (when (and compile-command
               (string-match "^bash --login -c \\(\"\\|'\\)\\(.*\\)\\1$" compile-command))
      (setq compile-command (match-string 2 compile-command)))))

(advice-add 'compile :around 'magda/compile-wrap-login-shell)
(add-hook 'compilation-mode-hook 'magda/strip-login-shell-hook)

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
(global-set-key (kbd "C-c u") 'undo-only)
(global-set-key (kbd "C-c r") 'undo-redo)
(global-set-key (kbd "C-o") 'pop-global-mark)
(global-set-key (kbd "C-c C-c") 'compile)

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

(use-package magit
  :ensure t)

(use-package modus-themes
  :ensure t)

(use-package wgrep
  :ensure t)

(use-package vertico
  :ensure t
  :config (vertico-mode))

(use-package marginalia
  :ensure t
  :config (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil))

(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-<up>") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down)
  (global-set-key (kbd "M-<down>") 'move-text-down))

(use-package objed
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'objed-activate))

(defun match-paren (arg)
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(use-package wrap-region
  :ensure t
  :config
  (wrap-region-global-mode 1)

  (wrap-region-add-wrapper "(" ")" "p")
  (wrap-region-add-wrapper "(" ")" "(")
  (wrap-region-add-wrapper "(" ")" ")")
  (wrap-region-add-wrapper "[" "]" "b")
  (wrap-region-add-wrapper "[" "]" "[")
  (wrap-region-add-wrapper "[" "]" "]")
  (wrap-region-add-wrapper "{" "}" "s")
  (wrap-region-add-wrapper "{" "}" "{")
  (wrap-region-add-wrapper "{" "}" "}")
  (wrap-region-add-wrapper "\"" "\"")
  (wrap-region-add-wrapper "'" "'")
  (wrap-region-add-wrapper "*" "*"))

(load-file custom-file)
(put 'narrow-to-region 'disabled nil)
(load-theme 'modus-operandi-tinted t)

