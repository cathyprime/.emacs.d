(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-metals lsp-pyright company lsp-mode treemacs-evil treemacs highlight-indent-guides markdown-mode python-mode go-mode which-key wgrep vterm undo-tree smex magit ligature evil-surround evil-commentary evil-collection autothemer)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun madie/set-font-faces ()
  (set-face-font 'default "JetBrainsMono Nerd Font-13")
  (load-theme 'kanagawa t))

(setq make-backup-files nil)

(if (daemonp)
    (add-hook 'after-make-frame-functions
			  (lambda (frame)
				(set-frame-parameter frame 'alpha-background 60)
				(with-selected-frame frame
				  (madie/set-font-faces))))
  (madie/set-font-faces))

(global-set-key (kbd "M-&") 'with-editor-async-shell-command)

(setq default-frame-alist '((undecorated . t)))
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq dired-isearch-filenames 'dwim)
(setq display-line-numbers-type 'relative)
(setq ring-bell-function 'ignore)
(setq split-width-threshold nil)
(setq isearch-lazy-count t)
(setq lazy-count-prefix-format "(%s/%s) ")
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

(use-package ligature
  :load-path "path-to-ligature-repo"
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package vterm
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

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

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (setq evil-insert-state-cursor `(hbar . 7)))

(use-package evil-surround
  :after evil
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :ensure t
  :config
  (evil-commentary-mode))

(use-package evil-collection
  :after evil
  :ensure t
  :init
  (evil-collection-init))

(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

(use-package wgrep
  :ensure t)

(use-package treemacs
  :ensure t)

(use-package treemacs-evil
  :ensure t)

(use-package lsp-mode
  :ensure t
  :bind (:map lsp-mode-map
			  ("C-c l" . lsp-command-map)
			  ("C-c d" . lsp-describe-thing-at-point)
			  ("C-c a" . lsp-execute-code-action))
  :config
  (lsp-enable-which-key-integration))

(use-package company
  :ensure t
  :config
  :hook ((emacs-lisp-mode . (lambda ()
							  (setq-local company-backends '(company-elisp))))
		 (emacs-lisp-mode . company-mode))
  (company-keymap--unbind-quick-access company-active-map)
  (setq company-idle-delay 0.1
		company-minimum-prefix-length 1))

;; language specific stuff
(use-package go-mode
  :ensure t
  :hook ((go-mode . lsp-deferred)
		 (go-mode . company-mode))
  :bind (:map go-mode-map
			  ("C-c f" . gofmt))
  :config
  (require 'lsp-go)
  (setq lsp-go-analyses
		'((fieldalignment . t)
		  (nilness        . t)
		  (unusedwrite    . t)
		  (unusedparams   . t)))
  (add-to-list 'exec-path "~/go/bin")
  (setq gofmt-command "goimports"))

(use-package python-mode
  :ensure t
  :mode (("\\.py\\'" . python-ts-mode)))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

(use-package lsp-metals
  :ensure t
  :custom
  ;; You might set metals server options via -J arguments. This might not always work, for instance when
  ;; metals is installed using nix. In this case you can use JAVA_TOOL_OPTIONS environment variable.
  (lsp-metals-server-args '(;; Metals claims to support range formatting by default but it supports range
                            ;; formatting of multiline strings only. You might want to disable it so that
                            ;; emacs can use indentation provided by scala-mode.
                            "-J-Dmetals.allow-multiline-string-formatting=off"
                            ;; Enable unicode icons. But be warned that emacs might not render unicode
                            ;; correctly in all cases.
                            "-J-Dmetals.icons=unicode"))
  ;; In case you want semantic highlighting. This also has to be enabled in lsp-mode using
  ;; `lsp-semantic-tokens-enable' variable. Also you might want to disable highlighting of modifiers
  ;; setting `lsp-semantic-tokens-apply-modifiers' to `nil' because metals sends `abstract' modifier
  ;; which is mapped to `keyword' face.
  (lsp-metals-enable-semantic-highlighting t)
  :hook (scala-mode . lsp))

(use-package highlight-indent-guides
  :ensure t
  :hook (python-ts-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
