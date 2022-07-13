;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Bas Bossink"
      user-mail-address "basbossink@dreamsolution.nl")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrainsMono NF" :size 16 :weight 'semi-light)
        doom-variable-pitch-font (font-spec :family "Iosevka NF" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! org
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-log-into-drawer t
        org-todo-keywords '((sequence "DEVELOPING(d!)" "IN REVIEW(r!)" "W.F. REWORK(w!)" "REWORKING(o!)" "IN RE-REVIEW(n!)" "|" "MERGED(m!)" "CANCELED(c@)"))
        org-todo-keywords-for-agenda '((sequence "TODO(t!)" "|" "DONE(d!)" "CANCELED(c@)")))

  (defun bb/add-custom-id (id)
    (interactive "sID: ")
    (org-set-property "CUSTOM_ID" id))

  (map! :leader
        (:prefix ("i" . "insert")
         :desc "custom Id" "i" #'bb/add-custom-id)))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
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
(setq timeclock-mode-line-display t
      timeclock-file (expand-file-name (getenv "TIMELOG")))

(defun my/timeclock-visit-timelog ()
  (interactive)
  (switch-to-buffer (find-file-noselect timeclock-file nil nil nil)))

(map! :leader
      (:prefix ("k" . "Clock actions")
       :desc "clock In" "i" #'timeclock-in
       :desc "clock Out" "o" #'timeclock-out
       :desc "Visit timelog" "v" #'my/timeclock-visit-timelog))

(after! magit
  (setq
   magit-repository-directories (list (cons (expand-file-name "~/ds/code") 2))
   magit-repolist-columns
   '(("Name" 35 magit-repolist-column-ident nil)
    ("Branch" 35 magit-repolist-column-branch nil)
    ("Upstream branch" 35 magit-repolist-column-branch nil)
    ("Version" 35 magit-repolist-column-version nil)
    ("B<U" 5 magit-repolist-column-unpulled-from-upstream
     ((:right-align t)
      (:help-echo "Upstream changes not in branch")))
    ("B>U" 5 magit-repolist-column-unpushed-to-upstream
     ((:right-align t)
      (:help-echo "Local changes not in upstream")))
    ("Path" 99 magit-repolist-column-path nil)))
  (magit-add-section-hook
   'magit-status-sections-hook
   'magit-insert-branch-description nil t)
  (magit-list-repositories))

(after! evil
  ;; Prefer symbol motions
  (defalias 'forward-evil-word 'forward-evil-symbol))

;; Mail setup
(after! mu4e
  (set-email-account! "work"
                      '((mu4e-sent-folder       . "/work/[Gmail]/Verzonden berichten")
                        (mu4e-drafts-folder     . "/work/[Gmail]/Concepten")
                        (mu4e-trash-folder      . "/work/[Gmail]/Prullenbak")
                        (mu4e-refile-folder     . "/work/[Gmail]/Alle e-mail")
                        (smtpmail-smtp-user     . "basbossink@dreamsolution.nl"))
                      t)
  (setq +mu4e-gmail-accounts '(("basbossink@dreamsolution.nl" . "/work")))

  (setq sendmail-program "/usr/bin/msmtp"
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail)

  (setq mu4e-compose-reply-to-address "basbossink@dreamsolution.nl")

  (setq mu4e-compose-signature (with-temp-buffer
                                 (insert-file-contents "~/.signature")
                                 (buffer-string)))
  (setq message-signature-file "~/.signature")
  (setq mu4e-attachment-dir "~/Downloads")

  (setq mu4e-headers-fields
        '( (:date          .  20)
           (:flags         .   6)
           (:from          .  30)
           (:mailing-list  .  10)
           (:subject       .  nil)))
  (setq mu4e-headers-date-format "%F %T")

  (setq mu4e-index-cleanup nil
        ;; because gmail uses labels as folders we can use lazy check since
        ;; messages don't really "move"
        mu4e-index-lazy-check t))

(after! (:and treemacs ace-window)
  (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))

(after!
  lsp-mode
  (add-hook
   'lsp-after-apply-edits-hook
   (lambda (operation)
     (when (eq operation 'rename)
       (projectile-save-project-buffers))))
  (setq lsp-lens-enable nil
        lsp-headerline-breadcrumb-enable t))

(after! rustic
  (map! (:map rustic-mode-map
         :localleader
         :desc "Jump to begin of function" "f" #'rustic-beginning-of-defun
         :desc "Jump to end of function" "e" #'rustic-end-of-defun)))

(after! consult
  (map!
   :desc "Yank selection from kill-ring"
   "C-c p" #'consult-yank-from-kill-ring))

(after!
  (:or gfm-mode markdown-mode)
  (add-hook! (gfm-mode markdown-mode) #'visual-line-mode #'turn-off-auto-fill))

(use-package! org-kanban)

(use-package! super-save
  :config
  (super-save-mode +1)
  (setq
   super-save-auto-save-when-idle t
   super-save-idle-duration 20))

(use-package! string-inflection
  :commands (string-inflection-all-cycle
             string-inflection-toggle
             string-inflection-camelcase
             string-inflection-lower-camelcase
             string-inflection-kebab-case
             string-inflection-underscore
             string-inflection-capital-underscore
             string-inflection-upcase)
  :init
  (map! :leader :prefix ("c~" . "naming convention")
        :desc "cycle" "~" #'string-inflection-all-cycle
        :desc "toggle" "t" #'string-inflection-toggle
        :desc "CamelCase" "c" #'string-inflection-camelcase
        :desc "downCase" "d" #'string-inflection-lower-camelcase
        :desc "kebab-case" "k" #'string-inflection-kebab-case
        :desc "under_score" "_" #'string-inflection-underscore
        :desc "Upper_Score" "u" #'string-inflection-capital-underscore
        :desc "UP_CASE" "U" #'string-inflection-upcase)
  (after! evil
    (evil-define-operator evil-operator-string-inflection (beg end _type)
      "Define a new evil operator that cycles symbol casing."
      :move-point nil
      (interactive "<R>")
      (string-inflection-all-cycle)
      (setq evil-repeat-info '([?g ?~])))
    (define-key evil-normal-state-map (kbd "g~") 'evil-operator-string-inflection)))

(use-package! ob-http)

(setq
 auto-revert-verbose nil
 browse-url-browser-function 'browse-url-firefox
 browse-url-generic-program "firefox"
 dired-auto-revert-buffer t
 explicit-shell-file-name "/usr/bin/sh"
 global-auto-revert-mode t
 sentence-end-double-space nil
 shell-file-name "/usr/bin/sh"
)
