;;; -*- lexical-binding: t; -*
;; Configuration to Braulio Date: 12/02/24
(let ((start-time (current-time)))
  (add-hook 'emacs-startup-hook
	    #'(lambda ()
	        (message "GNU Emacs inició en %.4f segundos"
		         (float-time (time-subtract (current-time)
						    start-time))))))

;;;
;;; INCLUIDO CON GNU EMACS
;;; 

;;; * Variables and functions defined in C source code
;;;

(setq frame-inhibit-implied-resize t)
(setq frame-resize-pixelwise t)
(setq x-underline-at-descent-line t)
(setq-default tab-width 4)
(setq use-dialog-box nil)
(setq use-file-dialog nil)
(setq enable-recursive-minibuffers t)
(setq ring-bell-function #'ignore)
(setq load-prefer-newer noninteractive)
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq use-short-answers t)
(setq delete-by-moving-to-trash t)

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;; * startup
;;;
;;; Process Emacs shell arguments

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)
(setq initial-major-mode #'fundamental-mode)

;;; * subr
;;;
;;; Basic lisp subroutines for Emacs

(defun path-from-home (path)
  "Regresa el camino a PATH desde el directorio de Emacs."
  (expand-file-name path user-emacs-directory))

;;; * mule-cmds
;;;
;;; Commands for multilingual environment

(set-language-environment "UTF-8")

;;; PREFIX COMMANDS

(defmacro define-prefix (command name)
  "Define un comando prefijo COMMAND llamado NAME."
  `(progn
     (defvar ,command ,name)
     (define-prefix-command ',command nil ,name)))

(define-prefix editor-map "Editor")
(define-prefix visual-map "Visual")
(define-prefix doc-map "Document")
(define-prefix window-map "Window")
(define-prefix omni-map "Omni")
(define-prefix lsp-map "LSP")
(define-prefix tasks-map "Tasks")

;;; * package
;;;
;;; Simple package system for Emacs

(require 'package)
(add-to-list 'package-archives '("elpa-devel" . "https://elpa.gnu.org/devel/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(setq package-archive-priorities
      '(("melpa" . 3)
        ("gnu" . 2)
        ("nongnu" . 2)
        ("elpa-devel" . 1)))

(require 'use-package)

(setq use-package-verbose t)
(setq use-package-minimum-reported-time 0.0)

(unbind-key (kbd "C-\\") global-map)
(bind-key "C-c e" 'editor-map)
(bind-key "C-c v" 'visual-map)
(bind-key "C-c d" 'doc-map)
(bind-key "C-c w" 'window-map)
(bind-key "C-c o" 'omni-map)
(bind-key "C-c l" 'lsp-map)
(bind-key "C-c t" 'tasks-map)

(bind-key "u" 'package-upgrade-all 'editor-map)

;;; * cus-edit
;;;
;;; Tools for customizing Emacs and Lisp packages
(use-package cus-edit
  :custom
  (custom-file (path-from-home "custom.el"))
  :config
  (unless (file-exists-p custom-file)
    (write-region "" nil custom-file))
  (load custom-file))

;;; * menu-bar
;;;
;;; Define a default menu bar
(use-package menu-bar
  :config
  (menu-bar-mode 0))

;;; * tool-bar
;;;
;;; Setting up the tool bar
(use-package tool-bar
  :config
  (tool-bar-mode 0))

;;; * simple
;;;
;;; Basic editing commands for Emacs
(use-package simple
  :config
  (size-indication-mode 1)
  (column-number-mode 1)
  (setq-default indent-tabs-mode nil))

;;; * files
;;;
;;; File input and output commands for Emacs
(use-package files
  :custom
  (make-backup-files t)
  (backup-by-copying t)
  (version-control t)
  (delete-old-versions t)
  (kept-old-versions 6)
  (kept-new-versions 9)
  (backup-directory-alist `(("." . ,(path-from-home "backups"))))
  (major-mode-remap-alist '((c-mode . c-ts-mode)
                            (c++-mode . c++-ts-mode)
                            (c-or-c++-mode . c-or-c++-ts-mode)
                            (json-mode . json-ts-mode)
                            (js-json-mode . json-ts-mode)
                            (js-mode . typescript-ts-mode)
                            (javascript-mode . typescript-ts-mode)
                            (css-mode . css-ts-mode)
                            (rust-mode . rust-ts-mode))))

(bind-key "r" 'revert-buffer 'omni-map)
(bind-key "r" 'restart-emacs 'editor-map)

;;; * faces
;;;
;;; Lisp faces
(use-package faces
  :when (display-graphic-p)
  :config
  (set-face-attribute 'fixed-pitch nil :inherit 'default)
  (set-face-attribute 'variable-pitch nil :inherit 'default))

;;; * minibuffer
;;;
;;; Minibuffer and completion functions
(use-package minibuffer
  :custom
  (read-file-name-completion-ignore-case t)
  (completions-detailed t)
  (completion-styles '(basic flex))
  (completions-format 'one-column)
  (completions-max-height 20)
  (completions-header-format nil)
  :bind
  (:map completion-in-region-mode-map
        ("M-n" . minibuffer-next-completion)
        ("M-p" . minibuffer-previous-completion))
  (:map minibuffer-local-completion-map
        ("M-n" . minibuffer-next-completion)
        ("M-p" . minibuffer-previous-completion))
  (:map minibuffer-local-shell-command-map
        ("M-n" . minibuffer-next-completion)
        ("M-p" . minibuffer-previous-completion)))

;;; * delsel
;;;
;;; Delete selection if you insert
(use-package delsel
  :config
  (delete-selection-mode 1))

;;; * tooltip
;;;
;;; Show tooltip windows
(use-package tooltip
  :config
  (tooltip-mode 0))

;;; * scroll-bar
;;;
;;; Window system-independent scroll bar support
(use-package scroll-bar
  :config
  (scroll-bar-mode 0))

;;; * frame
;;;
;;; Multi-frame management independent of window systems
(use-package frame
  :config
  (unbind-key (kbd "C-z") global-map)
  (unbind-key (kbd "C-x C-z") global-map)
  (blink-cursor-mode 0))


;;; * window
;;;
;;; GNU Emacs window commands aside from those written in C
(use-package window)


;;; * help
;;;
;;; Help commands for Emacs
(use-package help
  :custom
  (help-window-select t))

;;; * page
;;;
;;; Page motion commands for Emacs
(use-package page
  :config
  (put 'narrow-to-page 'disabled nil))

;;; * windmove
;;;
;;; Directional window-selection routines
(use-package windmove
  :config
  (windmove-default-keybindings))

;;; * uniquify
;;;
;;; Unique buffer names dependent on file name
(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward)
  (uniquify-separator " › "))

;;; * icomplete
;;;
;;; Minibuffer completion incremental feedback
(use-package icomplete
  :config
  (setq icomplete-in-buffer t)
  (fido-vertical-mode 1))

;;; * recentf
;;;
;;; Keep track of recently opened files
(use-package recentf
  :custom
  (recentf-max-menu-items 100)
  (recentf-max-saved-items 100)
  (recentf-save-file (path-from-home "recentf"))
  :bind ("C-x C-r" . recentf-open-files)
  :init
  (recentf-mode 1))

;;; * doc-view
;;;
;;; Document viewer for Emacs
(use-package doc-view
  :when (display-graphic-p)
  :custom
  (doc-view-resolution 200))

;;; * org
;;;
;;; Outline-based notes management and organizer
(use-package org
  :custom
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-use-sub-superscripts '{})
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (lisp . t)))

  ;; * oc
  ;;
  ;; Org Cite library
  (use-package oc
    :bind (:map doc-map
                ("c" . org-cite-insert)))

  ;; * org-src
  ;;
  ;; Source code examples in Org
  (use-package org-src
    :custom
    (org-src-preserve-indentation t)))


;;; * compile
;;;
;;; Run compiler as inferior of Emacs, parse error messages
(use-package compile
  :config
  (add-to-list 'display-buffer-alist
               '("\\*compilation\\*")))

;;; * saveplace
;;;
;;; Automatically save place in files
(use-package saveplace
  :config
  (save-place-mode 1))

;;; * ispell
;;;
;;; Interface to spell checkers
(use-package ispell
  :hook (org-mode . (lambda ()
                      (make-local-variable 'ispell-skip-region-alist)
                      (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
                      (add-to-list 'ispell-skip-region-alist '("~" "~"))
                      (add-to-list 'ispell-skip-region-alist '("=" "="))
                      (add-to-list 'ispell-skip-region-alist '("^#\\+" ":"))
                      (add-to-list 'ispell-skip-region-alist '("^#" "\n"))
                      (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))))

;;; * pixel-scroll
;;;
;;; Scroll a line smoothly
(use-package pixel-scroll
  :when (display-graphic-p)
  :custom
  (pixel-scroll-precision-interpolate-page t)
  (pixel-scroll-precision-interpolate-mice nil)
  :config
  (pixel-scroll-precision-mode 1))

;;; * project
;;;
;;; Operations on the current project
(use-package project
  :config
  (defun compile-project ()
    "Compiles current project or CWD using `compile-command'."
    (interactive)
    (if (project-current)
        (let ((compilation-read-command nil))
          (call-interactively #'project-compile))
      (compile compile-command)))
  (bind-key "m" 'compile-project 'omni-map)

  (defun project-try-gomod (dir)
    (let ((dir (locate-dominating-file dir "go.mod")))
      (and dir (list 'gomod dir))))

  (cl-defmethod project-root ((project (head gomod)))
    (nth 1 project))

  (defun project-try-node (dir)
    (let ((dir (locate-dominating-file dir "node_modules")))
      (and dir (list 'node dir))))

  (cl-defmethod project-root ((project (head node)))
    (nth 1 project))

  (defun project-try-cargo (dir)
    (let ((dir (locate-dominating-file dir "Cargo.toml")))
      (and dir (list 'cargo dir))))

  (cl-defmethod project-root ((project (head cargo)))
    (nth 1 project))

  (defun project-try-meson (dir)
    (let ((dir (locate-dominating-file dir "meson.build")))
      (and dir (list 'meson dir))))

  (cl-defmethod project-root ((project (head meson)))
    (nth 1 project))

  (add-hook 'project-find-functions #'project-try-gomod 1)
  (add-hook 'project-find-functions #'project-try-node 1)
  (add-hook 'project-find-functions #'project-try-cargo 1)
  (add-hook 'project-find-functions #'project-try-meson 1))

;;; * tramp
;;;
;;; Transparent Remote Access, Multiple Protocol
(use-package tramp
  :defer t
  :custom
  (tramp-allow-unsafe-temporary-files t))

;;; * elec-pair
;;;
;;; Automatic parenthesis pairing
(use-package elec-pair
  :hook (prog-mode . electric-pair-local-mode))

;;; * display-line-numbers
;;;
;;; Interface for display-line-numbers
(use-package display-line-numbers
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (setq display-line-numbers-type 'relative))

;;; * treesit
;;;
;;; tree-sitter utilities
(use-package treesit
  :commands (treesit-install-language-grammar treesit-install-all-languages)
  :init
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
          (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod"))
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
          (julia . ("https://github.com/tree-sitter/tree-sitter-julia"))
          (make . ("https://github.com/alemuller/tree-sitter-make"))
          (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "master" "ocaml/src"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          (php . ("https://github.com/tree-sitter/tree-sitter-php"))
          (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
          (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
          (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
          (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
          (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
  :config
  (defun treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
	    (treesit-install-language-grammar lang)
	    (message "`%s' parser was installed." lang)
	    (sit-for 0.75)))))

(add-to-list 'load-path "~/repos/c3-ts-mode")
(require 'c3-ts-mode)

;;; * indent
;;;
;;;
(defun smart-bol (&optional n)
  (interactive "^p")
  (let ((x (point)))
    (call-interactively 'beginning-of-line-text)
    (when (= x (point))
      (call-interactively 'beginning-of-line))))
(bind-key "C-a" 'smart-bol)

;;; * eshell
;;;
;;; 
(defun eshell/clear ()
  (eshell/clear-scrollback))

;;; * eglot
;;;
;;; The Emacs Client for LSP servers
(use-package eglot
  :config
  (bind-key (kbd "a") 'eglot-code-actions 'lsp-map)
  (bind-key (kbd "f") 'eglot-format 'lsp-map)
  (bind-key (kbd "r") 'eglot-rename 'lsp-map)
  (bind-key (kbd "e e") 'flymake-show-project-diagnostics 'lsp-map)
  (bind-key (kbd "e n") 'flymake-goto-next-error 'lsp-map)
  (bind-key (kbd "e p") 'flymake-goto-prev-error 'lsp-map))
(add-to-list 'eglot-server-programs
             '((c3-ts-mode) . ("~/repos/c3-lsp/server/bin/c3lsp")))
;;;
;;; PAQUETES DE TERCEROS
;;;

;;; * delight
;;;
;;; A dimmer switch for your lighter text
;;;
;;; Used by `use-package'
(use-package delight
  :ensure t)

;;; * paredit
;;;
;;; Minor mode for editing parentheses
(use-package paredit
  :ensure t
  :delight)

;;; * doom-modeline
;;;
;;; A minimal and modern mode-line
(use-package doom-modeline
  :ensure t
  :custom
  (doom-modeline-height 25)             ;23
  (doom-modeline-bar-width 5)           ;4
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project) ;'auto
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding t)
  (doom-modeline-indent-info nil)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 12)
  (doom-modeline-env-version t)
  (doom-modeline-irc-stylize 'identity)
  (doom-modeline-gnus-timer nil)        ;2
  :init (doom-modeline-mode 1))

;;; * which-key
;;;
;;; Display available keybindings in popup
(use-package which-key
  :ensure t
  :delight
  :hook (after-init . which-key-mode))

;;; * pdf-tools
;;;
;;; Support library for PDF documents
(use-package pdf-tools
  :ensure t
  :when (display-graphic-p)
  :mode "\\.pdf\\'"
  :config
  (pdf-tools-install)

  ;;; * saveplace-pdf-view
  ;;;
  ;;; Save place in pdf-view buffers
  (use-package saveplace-pdf-view
    :ensure t))

;;; * company
;;;
;;; Modular text completion framework
(use-package company
  :ensure t
  :delight
  :custom
  (company-idle-delay 1.0)
  (company-tooltip-idle-delay 1.0)
  :hook (prog-mode . company-mode)
  :config
  (bind-key (kbd "o") 'company-complete 'omni-map))

;;; * yasnippet
;;;
;;; Yet another snippet extension for Emacs
(use-package yasnippet
  :ensure t
  :config
  (use-package yasnippet-snippets
    :ensure t)
  (yas-global-mode 1))

;;; * rainbow-delimiters
;;;
;;; Highlight brackets according to their depth
(use-package rainbow-delimiters
  :ensure t)

;;; * rainbow-mode
;;;
;;; Colorize color names in buffers
(use-package rainbow-mode
  :ensure t
  :commands (rainbow-mode))

;;; * markdown-mode
;;;
;;; Major mode for Markdown-formatted text
(use-package markdown-mode
  :ensure t)

;;; * toml-ts-mode
;;;
;;; tree-sitter support for TOML
(use-package toml-ts-mode
  :ensure t)

;;; * json-ts-mode
;;;
;;; tree-sitter support for JSON
(use-package json-ts-mode
  :custom
  (json-ts-mode-indent-offset 4))

;;; * nginx-mode
;;;
;;; major mode for editing nginx config files
(use-package nginx-mode
  :ensure t)

;;; * dockerfile-mode
;;;
;;; Major mode for editing Docker's Dockerfiles
(use-package dockerfile-mode
  :ensure t)

;;; * gnuplot-mode
;;;
;;; Major mode for editing gnuplot scripts
(use-package gnuplot-mode
  :ensure t)

;;; * yaml-mode
;;;
;;; Major mode for editing YAML files
(use-package yaml-mode
  :ensure t)

;;; * powershell
;;;
;;; Mode for editing PowerShell scripts
(use-package powershell
  :ensure t)

;;; * julia-mode
;;;
;;; Major mode for editing Julia source code
(use-package julia-mode
  :ensure t)

;;; * meson-mode
;;;
;;; Major mode for the Meson build system files
(use-package meson-mode
  :ensure t)

;;; * cmake-mode
;;;
;;; major-mode for editing CMake sources
(use-package cmake-mode
  :ensure t)

;;; * simple-httpd
;;;
;;; Pure elisp HTTP server
(use-package simple-httpd
  :ensure t
  :commands (httpd-start httpd-serve-directory))

;;; * restclient
;;;
;;;
(use-package restclient
  :ensure t)

;;; * comint-mime
;;;
;;; Display content of various MIME types in comint buffers
(use-package comint-mime
  :ensure t
  :commands (comint-mime-setup))

;;; * magit
;;;
;;; A Git porcelain inside Emacs
(use-package magit
  :ensure t
  :bind (:map omni-map
              ("g" . magit-status)))

;;; * git-modes
;;;
;;; Major modes for editing Git configuration files
(use-package git-modes
  :ensure t)

;;; * sql-indent
;;;
;;;
(use-package sql-indent
  :ensure t)

;;;
;;; PROGRAMACIÓN EN C/C++
;;;

;;; * c-ts-mode
;;;
;;; tree-sitter support for C and C++
(use-package c-ts-mode
  :custom
  (c-ts-mode-indent-offset 4)
  :hook ((c++-ts-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)))

;;; * c3-ts-mode
;;;
;;; tree-sitter support for C3
(use-package c3-ts-mode
  :custom
  (c3-ts-mode-indent-offset 4)
  :mode ("\\.c3\\'")
  :hook ((c3-ts-mode . eglot-ensure)))
;;; * gdb-mi
;;;
;;; User Interface for running GDB
(use-package gdb-mi
  :custom
  (gdb-many-windows t))

;;;
;;; PROGRAMACIÓN EN EMACS LISP
;;;

;;; * elisp-mode
;;;
;;; Emacs Lisp mode
(use-package elisp-mode
  :hook
  (emacs-lisp-mode . paredit-mode)
  (emacs-lisp-mode . rainbow-delimiters-mode))

;;;
;;; PROGRAMACIÓN EN COMMON LISP
;;;

;;; * lisp-mode
;;;
;;; Lisp mode, and its idiosyncratic commands
(use-package lisp-mode
  :hook
  (lisp-data-mode . paredit-mode)
  (lisp-data-mode . rainbow-delimiters-mode))

;;; * sly
;;;
;;; Sylvester the Cat's Common Lisp IDE
(use-package sly
  :ensure t
  :custom
  (sly-default-lisp 'roswell)
  (sly-net-coding-system 'utf-8-unix)
  :config
  (setq sly-lisp-implementations '((roswell ("ros" "-Q" "run"))))
  (defvar sly-mrepl-pop-sylvester nil)
  :commands (sly sly-connect))

;;; * sly-quicklisp
;;;
;;; Quicklisp support for SLY
(use-package sly-quicklisp
  :ensure t
  :after sly)

;;; * sly-named-readtables
;;;
;;; Support named readtables in Common Lisp files
(use-package sly-named-readtables
  :ensure t
  :after sly)

;;; * sly-macrostep
;;;
;;; fancy macro-expansion via macrostep.el
(use-package sly-macrostep
  :ensure t
  :after sly)

;;; * sly-asdf
;;;
;;; ASDF system support for SLY
(use-package sly-asdf
  :ensure t
  :after sly)

;;; * sly-repl-ansi-color
;;;
;;; Add ANSI colors support to the sly mrepl.
(use-package sly-repl-ansi-color
  :ensure t
  :after sly)

;;;
;;; PROGRAMACIÓN EN RACKET
;;;

;;; * racket-mode
;;;
;;; Racket editing, REPL, and more
(use-package racket-mode
  :ensure t
  :hook
  (racket-mode . paredit-mode)
  (racket-mode . rainbow-delimiters-mode))

;;;
;;; PROGRAMACIÓN EN CLOJURE/CLOJURESCRIPT
;;;

;;; * clojure-mode
;;;
;;; Major mode for Clojure code
(use-package clojure-mode
  :ensure t
  :hook
  (clojure-mode . paredit-mode)
  (clojure-mode . rainbow-delimiters-mode))

;;; * cider
;;;
;;; Clojure Interactive Development Environment that Rocks
(use-package cider
  :ensure t
  :commands (cider-connect cider-connect-clj cider-connect-cljs cider-connect-clj&cljs
                           cider-jack-in cider-jack-in-clj cider-jack-in-cljs cider-jack-in-clj&cljs)
  :bind (:map cider-repl-mode-map
              ("C-c M-o" . cider-repl-clear-buffer*)
              :map cider-mode-map
              ("C-c ~" . cider-repl-set-ns))
  :config
  (defun cider-repl-clear-buffer* ()
    (interactive)
    (cider-repl-clear-buffer)
    (redisplay t)))

;;;
;;; PROGRAMACIÓN EN PYTHON
;;;

;;; * python
;;;
;;; Python's flying circus support for Emacs
(use-package python
  :custom
  (python-indent-guess-indent-offset-verbose nil)
  (python-shell-interpreter "ipython3")
  (python-shell-interpreter-args "--simple-prompt --classic")
  :config
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "jupyter")
  :hook (inferior-python-mode . comint-mime-setup))

;;; * pyvenv
;;;
;;; Python virtual environment interface
(use-package pyvenv
  :ensure t
  :after python
  :hook (python-mode . pyvenv-tracking-mode))

;;; * python-pytest
;;;
;;; helpers to run pytest
(use-package python-pytest
  :ensure t
  :after python
  :bind (:map python-mode-map
              ("C-c t a" . python-pytest)
              ("C-c t f" . python-pytest-file-dwim)
              ("C-c t F" . python-pytest-file)
              ("C-c t t" . python-pytest-function-dwim)
              ("C-c t T" . python-pytest-function)
              ("C-c t r" . python-pytest-repeat)
              ("C-c t p" . python-pytest-dispatch)))

;;; * pyimport
;;;
;;; Manage Python imports!
(use-package pyimport
  :ensure t
  :after python
  :bind (:map python-mode-map
              ("C-c C-i C-i" . pyimport-insert-missing)))

;;; * py-isort
;;;
;;; Use isort to sort the imports in a Python buffer
(use-package py-isort
  :ensure t
  :after python
  :hook (python-mode . py-isort-before-save))

;;; * python-black
;;;
;;; Reformat Python using python-black
(use-package python-black
  :ensure t
  :delight
  :commands (python-black-buffer)
  :hook (python-mode . python-black-on-save-mode))

;;;
;;; PROGRAMACIÓN EN GO
;;;

;;; * go-ts
;;;
;;; tree-sitter support for Go
(use-package go-ts-mode
  :custom
  (go-ts-mode-indent-offset 4)
  :mode (("\\.go\\'" . go-ts-mode)
         ("go.mod" . go-mod-ts-mode))
  :hook ((go-mod-ts-mode . eglot-ensure)
         (go-ts-mode . eglot-ensure)))

;;;
;;; PROGRAMACIÓN EN RUST
;;;
(use-package rust-ts-mode
  :mode (("\\.rs\\'" . rust-ts-mode))
  :hook ((rust-ts-mode . eglot-ensure)))

;;;
;;; PROGRAMACIÓN EN TYPESCRIPT
;;;
(use-package typescript-ts-mode
  :custom
  (typescript-ts-mode-indent-offset 4)
  :mode (("\\.js\\'" . typescript-ts-mode)
         ("\\.ts\\'" . typescript-ts-mode)
         ("\\.jsx\\'" . tsx-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :hook ((typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)))

;;;
;;; PROGRAMACIÓN EN CSS
;;;
(use-package css-mode
  :custom
  (css-indent-offset 4)
  :mode ("\\.css\\'" "\\.scss\\'")
  :hook (css-mode . eglot-ensure))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; EXTENSIONES PERSONALES
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;
;;; ABRIR ARCHIVOS DE KPSEWHICH (TeXLive)
;;; 

(defvar kpsewhich--cache nil)
(defvar kpsewhich--command
  "grep \"^[^.%][^\\\\.]*\\\\.\\\\(tex\\\\|sty\\\\|mf\\\\)$\" /usr/share/texmf-dist/ls-R")

(defun kpsewhich (name)
  "Abre un archivo .tex, .sty o .mf utilizando kpsewhich.

NAME es el nombre del archivo y se utiliza `completing-read' para obtenerlo."
  (interactive
   (list
    (let ((coll (or kpsewhich--cache
                    (split-string (shell-command-to-string kpsewhich--command)))))
      (setq kpsewhich--cache coll)
      (completing-read (format-prompt "TeX file" nil) coll))))
  (find-file (string-trim (shell-command-to-string (format "kpsewhich %s" name)))))

;;;
;;; ABRIR ARCHIVO DE CONFIGURACIÓN
;;;

(defun find-init ()
  "Abre el archivo de configuración de Emacs `user-init-file'."
  (interactive)
  (find-file user-init-file))

(bind-key "i" 'find-init 'editor-map)

;;;
;;; AJUSTAR TAMAÑO DE FUENTE GLOBALMENTE
;;;

(defvar default-face-current-height
  (face-attribute 'default :height nil))

(defcustom default-face-height-delta 10
  "Cantidad de unidades de altura al incrementar o decrementar tamaño."
  :type 'natnum
  :group 'faces)

(defun set-default-face-height (height)
  "Ajusta la altura de la fuente por defecto al valor numérico HEIGHT."
  (interactive "nFont height: ")
  (set-face-attribute 'default nil :height height)
  (setq default-face-current-height height))

(defvar default-face--restart-height nil)

(defun default-face-update-height (inc)
  "Ajusta la altura de la fuente por defecto de acuerdo al incremento INC."
  (interactive "p")
  (let ((new-value (if (= inc 0)
                       default-face--restart-height
                     (+ default-face-current-height
                        (* default-face-height-delta inc)))))
    (set-default-face-height new-value)))

(defun default-face-height-adjust (inc)
  "Ajusta la altura de la fuente por defecto.

INC es un argumento prefijo que puede modificar qué tanto ajustar la altura."
  (interactive "p")
  (unless default-face--restart-height
    (setq default-face--restart-height default-face-current-height))
  (let ((ev last-command-event)
        (echo-keystrokes nil))
    (let* ((base (event-basic-type ev))
           (step
            (pcase base
              ((or ?+ ?=) inc)
              (?- (- inc))
              (?0 0)
              (_ inc))))
      (default-face-update-height step)
      (message "Use +,-,0 for further adjustment (height %s)" default-face-current-height)
      (set-transient-map
       (let ((map (make-sparse-keymap)))
         (dolist (mods '(()))
           (dolist (key '(?- ?+ ?= ?0))
             (define-key map (vector (append mods (list key)))
                         (lambda () (interactive) (default-face-height-adjust (abs inc))))))
         map)))))

(when (display-graphic-p)
  (bind-key "h" 'set-default-face-height 'visual-map)
  (bind-key "+" 'default-face-height-adjust 'visual-map)
  (bind-key "-" 'default-face-height-adjust 'visual-map)
  (bind-key "=" 'default-face-height-adjust 'visual-map)
  (bind-key "0" 'default-face-height-adjust 'visual-map))

;;;
;;; SALVAR Y CARGAR DISPOSICIÓN DE VENTANAS
;;;

(defvar window-stored-configurations nil
  "Lista de configuraciones de ventana almacenadas.

Cada entrada es de la forma (NAME . CONFIG) donde NAME es una
cadena y CONFIG algún objeto regresado por
`current-window-configuration'.")

(defvar window-configurations--current nil)

(defvar window-configurations--previous nil)

(defun window-configuration-store (name)
  "Guarda la configuración de ventanas actual bajo el nombre de NAME."
  (interactive (list (completing-read
                      (format-prompt "Window configuration name" nil)
                      (mapcar #'car window-stored-configurations))))
  (let ((entry (assoc name window-stored-configurations)))
    (when entry
      (setq window-stored-configurations (delq entry window-stored-configurations)))
    (setq entry (cons name (current-window-configuration)))
    (setq window-stored-configurations
          (reverse (cons entry (reverse window-stored-configurations))))
    (when window-configurations--current
      (setq window-configurations--previous window-configurations--current))
    (setq window-configurations--current (car entry))
    name))

(defun window-configuration--stored-sorted ()
  "Regresa una lista de disposiciones de ventanas almacenada."
  (let ((current (assoc window-configurations--current window-stored-configurations))
        (previous (assoc window-configurations--previous window-stored-configurations)))
    (cond ((not current)
           window-stored-configurations)
          ((eq current previous)
           (cons current (remove current window-stored-configurations)))
          (t
           (let ((others (remove current (remove previous window-stored-configurations))))
             (cons previous (cons current others)))))))

(defun window-configuration-load (name)
  "Carga la configuración de ventanas almacenado bajo el nombre NAME."
  (interactive (list (let ((collection (window-configuration--stored-sorted)))
                       (completing-read
                        (format-prompt "Window configuration name" (caar collection))
                        (mapcar #'car collection)
                        nil t nil nil (caar collection)))))
  (let ((entry (assoc name window-stored-configurations)))
    (when entry
      (set-window-configuration (cdr entry))
      (when window-configurations--current
        (setq window-configurations--previous window-configurations--current))
      (setq window-configurations--current (car entry))
      (car entry))))

(bind-key "s" 'window-configuration-store 'window-map)
(bind-key "w" 'window-configuration-load 'window-map)

;;;
;;; PARA MODO ORG
;;;

(defun org-insert-relative-link ()
  "Inserta un enlace relativo."
  (interactive)
  (let ((org-link-file-path-type 'relative))
    (call-interactively #'org-insert-link)))

(bind-key "l" 'org-insert-relative-link 'doc-map)


(defun org-get-custom-id-dwim (&optional pom create prefix)
  "Get the CUSTOM_ID property of the entry at point-or-marker POM.

If POM is nil, refer to the entry at point.  If the entry does
not have an CUSTOM_ID, the function returns nil.  However, when
CREATE is non nil, create a CUSTOM_ID if none is present already.
PREFIX will be passed through to `org-id-new'.  In any case, the
CUSTOM_ID of the entry is returned."
  (org-with-point-at pom
                     (let ((id (org-entry-get nil "CUSTOM_ID")))
                       (cond
                        ((and id (stringp id) (string-match "\\S-" id))
                         id)
                        (create
                         (setq id (org-id-new (concat prefix "h")))
                         (org-entry-put pom "CUSTOM_ID" id)
                         (org-id-add-location id (format "%s" (buffer-file-name (buffer-base-buffer))))
                         id)))))

(defun org-add-missing-custom-ids ()
  "Add missing CUSTOM_ID to all headlines in current file."
  (interactive)
  (org-map-entries
   (lambda () (org-get-custom-id-dwim (point) t))))


;;;
;;; PARA CAMBIAR ENTRE TEMAS
;;;
(defvar loaded-theme-variant nil)

(defun load-light-theme ()
  "Carga el tema con colores claros."
  "Carga el tema doom-acario-light."
  (interactive)
  ;; Asegurarse de que cualquier tema previamente activado esté desactivado primero; opcional
  (mapc #'disable-theme custom-enabled-themes)
  ;; Cargar el tema doom-acario-light
  (load-theme 'doom-acario-light t)
  (setq loaded-theme-variant 'light)
  )

(defun load-dark-theme ()
  "Carga el tema con colores oscuros."
  (interactive)
  ;; Asegurarse de que cualquier tema previamente activado esté desactivado primero; opcional
  (mapc #'disable-theme custom-enabled-themes)
  ;; Cargar el tema doom-acario-light
  (load-theme 'doom-gruvbox t)
  (setq loaded-theme-variant 'dark)
  )
  
(defun toggle-theme-variant ()
  "Cambia de tema claro a oscuro y viceversa."
  (interactive)
  (cond ((eq loaded-theme-variant 'light)
         (load-dark-theme)
         (message "loaded-theme-variant: %s" loaded-theme-variant))
        ((eq loaded-theme-variant 'dark)
         (load-light-theme)
         (message "loaded-theme-variant: %s" loaded-theme-variant))
        (t
         (load-dark-theme)))
  (message "loaded-theme-variant: %s" loaded-theme-variant))
(bind-key "t" 'toggle-theme-variant 'visual-map)

;;;
;;; AJUSTE DE TEMA AL CAMBIAR MODO OSCURO EN GNOME
;;;

(defun dbus-gnome-callback (path var value)
  "Ajusta tema de Emacs si cambia tema de colores en Gnome.

PATH, VAR y VALUE vienen de D-Bus."
  (when (and (string-equal path "org.freedesktop.appearance")
             (string-equal var "color-scheme"))
    (dbus-gnome-adjust-theme (car value))))

(defun dbus-gnome-adjust-theme (value)
  "Ajusta tema de Emacs de acuerdo a VALUE."
  (cond ((= value 0)
         (load-light-theme)
         (dbus-gnome-set-frame-variant "light"))
        ((= value 1)
         (load-dark-theme)
         (dbus-gnome-set-frame-variant "dark"))))

(defun dbus-gnome-set-frame-variant (variant)
  "Ajusta color del marco de Emacs de acuerdo a VARIANT."
  (dolist (frame (frame-list))
    (let* ((window-id (or (frame-parameter frame 'outer-window-id)
                          (frame-parameter frame 'window-id)))
           (id (string-to-number window-id))
           (cmd (format "xprop -id 0x%x -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"%s\""
                        id variant)))
      (call-process-shell-command cmd))))

(defun dbus-gnome-init ()
  "Inicializa D-Bus para Gnome."
  (dbus-register-signal
   :session
   "org.freedesktop.portal.Desktop"
   "/org/freedesktop/portal/desktop"
   "org.freedesktop.portal.Settings"
   "SettingChanged"
   #'dbus-gnome-callback)
  (dbus-call-method-asynchronously
   :session
   "org.freedesktop.portal.Desktop"
   "/org/freedesktop/portal/desktop"
   "org.freedesktop.portal.Settings"
   "Read"
   #'(lambda (value-list)
       (dbus-gnome-adjust-theme (caar value-list)))
   "org.freedesktop.appearance"
   "color-scheme"))

;;; * dbus
;;;
;;; Elisp bindings for D-Bus.
(use-package dbus
  :when (and (eq system-type 'gnu/linux)
             (string-equal "gnome" (getenv "DESKTOP_SESSION")))
  :config
  (dbus-gnome-init))


(use-package jupyter
  :ensure t
  :config
  ;; Aquí puedes añadir configuraciones específicas si lo necesitas
)

(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'prog-mode-hook 'visual-line-mode)
(load-theme 'catppuccin :no-confirm)


;;; COnfig Personal
(require 'autoinsert)
(auto-insert-mode 1)
(setq auto-insert-directory "~/.emacs.d/templates/")
(define-auto-insert "\\.org\\'" "default-org-template.org")

;; Instalar org-bullets
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))


;; use-package with Elpaca:
(use-package dashboard
  :ensure t
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))
(setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))

(add-to-list 'dashboard-items '(agenda) t)
(setq dashboard-week-agenda t)
(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)


;;; Config Emacs
;; Set the title
(setq dashboard-banner-logo-title "Welcome to Emacs Dashboard")
;; Set the banner
(setq dashboard-startup-banner 'logo)
;; Value can be:
;;  - 'official which displays the official emacs logo.
;;  - 'logo which displays an alternative emacs logo.
;;  - an integer which displays one of the text banners
;;    (see dashboard-banners-directory files).
;;  - a string that specifies a path for a custom banner
;;    currently supported types are gif/image/text/xbm.
;;  - a cons of 2 strings which specifies the path of an image to use
;;    and other path of a text file to use if image isn't supported.
;;    (cons "path/to/image/file/image.png" "path/to/text/file/text.txt").
;;  - a list that can display an random banner,
;;    supported values are: string (filepath), 'official, 'logo and integers.

;; Content is not centered by default. To center, set
(setq dashboard-center-content t)
;; vertically center content
(setq dashboard-vertically-center-content t)

;; To disable shortcut "jump" indicators for each section, set
(setq dashboard-show-shortcuts nil)

(setq dashboard-items '((recents   . 5)
                        (bookmarks . 5)
                        (projects  . 5)
                        (agenda    . 5)
                        (registers . 5)))

(setq dashboard-startupify-list '(dashboard-insert-banner
                                  dashboard-insert-newline
                                  dashboard-insert-banner-title
                                  dashboard-insert-newline
                                  dashboard-insert-navigator
                                  dashboard-insert-newline
                                  dashboard-insert-init-info
                                  dashboard-insert-items
                                  dashboard-insert-newline
                                  dashboard-insert-footer))

(setq dashboard-heading-shorcut-format " [%s]")

(setq dashboard-item-shortcuts '((recents   . "r")
                                 (bookmarks . "m")
                                 (projects  . "p")
                                 (agenda    . "a")
                                 (registers . "e")))

(setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
(setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package

(dashboard-modify-heading-icons '((recents   . "file-text")
                                  (bookmarks . "book")))

(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-style "linux")
            (setq c-basic-offset 4)
            (setq indent-tabs-mode t)))


(add-to-list 'load-path "~/.emacs.d/copilot.el")
(require 'copilot)

(use-package editorconfig :ensure t)
(use-package jsonrpc :ensure t)
(use-package f :ensure t)

(add-hook 'prog-mode-hook 'copilot-mode)

(with-eval-after-load 'copilot
  (define-key copilot-completion-map (kbd "<tab>") #'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "TAB") #'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "C-TAB") #'copilot-accept-completion-by-word)
  (define-key copilot-completion-map (kbd "C-<tab>") #'copilot-accept-completion-by-word))

(setq warning-minimum-level :error)

