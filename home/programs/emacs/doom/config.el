;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Documents/org-roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

;;(setq org-roam-directory (file-truename "~/Documents/org-roam"))

;; Background-only transparency (text remains fully opaque); requires Emacs 29+
(add-to-list 'default-frame-alist '(alpha-background . 88))

;;; --- Multilingual ---

(set-language-environment "UTF-8")

;; JetBrainsMono Nerd Font already covers Latin + Cyrillic (Russian, German).
;; Noto fills in CJK (Mandarin) and Hebrew where the primary font has no glyphs.
(when (display-graphic-p)
  (set-fontset-font t 'han "Noto Sans CJK SC")
  (set-fontset-font t 'cjk-misc "Noto Sans CJK SC")
  (set-fontset-font t 'hebrew "Noto Sans Hebrew"))

;; Allow Emacs to auto-detect paragraph direction per-paragraph so Hebrew
;; RTL text is visually reordered correctly alongside LTR content.
(setq-default bidi-paragraph-direction nil)

;; Input method switchers — SPC L <key>
(defun my/im-russian ()
  (interactive)
  (set-input-method "russian-computer")
  (message "Input: Russian (Йцукен)"))

(defun my/im-chinese ()
  (interactive)
  (set-input-method "pyim")
  (message "Input: Chinese (拼音)"))

(defun my/im-hebrew ()
  (interactive)
  (set-input-method "hebrew")
  (message "Input: Hebrew (עברית)"))

(defun my/im-german ()
  (interactive)
  (set-input-method "german-postfix")
  (message "Input: German (Deutsch)"))

(defun my/im-off ()
  (interactive)
  (deactivate-input-method)
  (message "Input: English"))

(map! :leader
      (:prefix ("L" . "language")
       :desc "English (off)"    "e" #'my/im-off
       :desc "Russian"          "r" #'my/im-russian
       :desc "Chinese (pyim)"   "c" #'my/im-chinese
       :desc "Hebrew"           "h" #'my/im-hebrew
       :desc "German"           "d" #'my/im-german
       :desc "Toggle IME"       "t" #'toggle-input-method))

;; pyim: standard full-pinyin; Doom's chinese module enables pyim-basedict.
(with-eval-after-load 'pyim
  (setq pyim-default-scheme 'quanpin))
