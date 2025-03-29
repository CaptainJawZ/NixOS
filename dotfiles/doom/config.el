(use-package
  insert-esv
  :init
  (setq insert-esv-crossway-api-key "bb1872462ecc59624c7bb8ab36c9701ce2027cd1")
  (setq insert-esv-include-short-copyright 'false)
  (setq insert-esv-include-headings 'true)
  (setq insert-esv-include-passage-horizontal-lines 'false)
  (setq insert-esv-line-length '500)
  :bind ("C-x C-e" . insert-esv-passage))

(setq bookmark-default-file "~/.config/doom/bookmarks")

(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks"                          "L" #'list-bookmarks
       :desc "Set bookmark"                            "m" #'bookmark-set
       :desc "Delete bookmark"                         "M" #'bookmark-set
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)

(setq doom-fallback-buffer "*dashboard*")

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; (kbd "Q") 'quick-preview-at-point) ;; previews with sushi
;; Get file icons in dired
;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "eog")
                              ("jpg" . "eog")
                              ("png" . "eog")
                              ("mkv" . "celluloid")
                              ("mp4" . "celluloid")))

(evil-define-key 'normal peep-dired-mode-map
 (kbd "j") 'peep-dired-next-file
 (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

;; (diredp-toggle-find-file-reuse-dir 1)
(setq dired-kill-when-opening-new-dired-buffer 1)

(use-package! base16-stylix-theme)
(require 'base16-stylix-theme)
(setq doom-theme 'base16-stylix)
;; (setq doom-theme 'doom-opera-light)
;; ;; (setq doom-theme 'doom-dark+)
;; (map! :leader
;;       :desc "Load new theme" "h t" #'counsel-load-theme)

;; (emms-all)
;; (emms-default-players)
;; (emms-mode-line 1)
;; (emms-playing-time 1)
;; (setq emms-source-file-default-directory "~/Music/"
;;       emms-playlist-buffer-name "*Music*"
;;       emms-info-asynchronously t
;;       emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
;; (map! :leader
;;       (:prefix ("m p d". "EMMS audio player")
;;        :desc "Go to emms playlist" "a" #'emms-playlist-mode-go
;;        :desc "Emms pause track" "x" #'emms-pause
;;        :desc "Emms stop track" "s" #'emms-stop
;;        :desc "Emms play previous track" "p" #'emms-previous
;;        :desc "Emms play next track" "n" #'emms-next))

(map! :leader
      (:prefix ("e". "evaluate/EWW")
       :desc "Evaluate elisp in buffer" "b" #'eval-buffer
       :desc "Evaluate defun" "d" #'eval-defun
       :desc "Evaluate elisp expression" "e" #'eval-expression
       :desc "Evaluate last sexpression" "l" #'eval-last-sexp
       :desc "Evaluate elisp in region" "r" #'eval-region))

;; (setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words
      (:prefix ("e" . "evaluate/EWW")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload))

(setq doom-unicode-font "Symbola")
(setq doom-font (font-spec :family "ComicShannsMono Nerd Font Mono" :size 18)
      doom-variable-pitch-font (font-spec :family "ComicShannsMono Nerd Font Mono" :size 18)
      doom-big-font (font-spec :family "ComicShannsMono Nerd Font Mono" :size 22))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(bold :weight ultra-bold)
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(defun func/insert-todays-date (prefix)
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%Y-%m-%d")
                 ((equal prefix '(4)) "%A, %B %d, %Y"))))
    (insert (format-time-string format))))

(require 'calendar)
(defun func/insert-any-date (date)
  "Insert DATE using the current locale."
  (interactive (list (calendar-read-date)))
  (insert (calendar-date-string date)))

(map! :leader
      (:prefix ("i d" . "Insert date")
        :desc "Insert any date" "a" #'func/insert-any-date
        :desc "Insert todays date" "t" #'func/insert-todays-date))

(defun func/org-roam-capture-task ()
  (interactive)
  ;; Capture the new task, creating the project file if necessary
  (org-roam-capture-
   :node (org-roam-node-read nil)
   :templates '(("p" "project" plain "** TODO %?"
                 :if-new (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                        "#+title: ${title}\n#+category: ${title}\n#+filetags: Project"
                                        ("Tasks"))))))

(global-set-key (kbd "C-c n t") #'my/org-roam-capture-task)

(use-package! flycheck
  :config
  (flycheck-define-checker nix-statix
    "A syntax checker for Nix using Statix."
    :command ("statix" "check" source)
    :error-patterns
    ((warning line-start (file-name) ":" line ":" column
              ": " (message) line-end))
    :modes (nix-mode))

  (add-to-list 'flycheck-checkers 'nix-statix))

;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
  See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " (format-time-string "%Y-%m-%d-") fname)
                   ":END:"
                   "%?\n") ;Place the cursor here finally
                 "\n"))))
;; org capture templates
(setq org-capture-templates
      '(
        ("h" ;`org-capture' binding + h
         "Hugo post"
         entry
         ;; It is assumed that below file is present in `org-directory'
         ;; and that it has a "Blog Ideas" heading. It can even be a
         ;; symlink pointing to the actual location of all-posts.org!
         (file+olp "/home/jawz/Development/Websites/portfolio/content-org/posts.org" "blog")
         (function org-hugo-new-subtree-post-capture-template))
        ))

;;;(after! org
  ;;;;; ⧗             ―               ﮸          λ ◁ ▷ ✧ ✦
  ;;;(appendq! +ligatures-extra-symbols
            ;;;`(:clock "⧗ "
              ;;;:circle ""
              ;;;:code ""
              ;;;:results "﮸"
              ;;;:shogi "⛊"
              ;;;:white_shogi "☖"
              ;;;:black_shogi "☗"
              ;;;:two_lines "⚏"
              ;;;;; :tags "    ‌"
              ;;;:empty ""
              ;;;))
  ;;;(set-ligatures! 'org-mode
    ;;;;; :merge t
    ;;;;; :clock ":LOGBOOK:"
    ;;;:quote              "#+begin_quote"
    ;;;:name               "#+CAPTION:"
    ;;;:quote_end          "#+end_quote"
    ;;;:code               "#+begin_src"
    ;;;:code               "#+BEGIN_SRC"
    ;;;:src_block          "#+BEGIN:"
    ;;;:code               "#+end_src"
    ;;;:code               "#+END_SRC"
    ;;;:results            "#+RESULTS:"
    ;;;:results            "#+results:"
    ;;;;; :src_block_end     ":END:"
    ;;;;; :src_block_end     "#+END"
    ;;;;; :two_lines   ":PROPERTIES:"
    ;;;;; :black_shogi   "#+CATEGORY:"
    ;;;;; :black_shogi   "#+category:"
    ;;;;; :two_lines   "#+startup:"
    ;;;;; :two_lines   "#+STARTUP:"
    ;;;:empty              "#+title: "
    ;;;:empty              "#+TITLE: "
    ;;;;; :shogi "#+NAME:"
    ;;;;; :shogi "#+name:"
    ;;;;; :tags "keywords:"
    ;;;;; :black_shogi "#+roam_tags:"
    ;;;))

(setq display-line-numbers-type t)
(map! :leader
      :desc "Comment or uncomment lines" "TAB TAB" #'comment-line
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers" "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines" "t" #'toggle-truncate-lines))

(setq display-line-numbers-type `relative)
(global-visual-line-mode t)

;; CONFIG
(require 'config-general-mode)
    (add-to-list 'auto-mode-alist '("\\.conf$" . config-general-mode))

(setq all-the-icons-scale-factor .8) ;; fixes the issue of rightmost characters not fitting.
(set-face-attribute 'mode-line nil :font "Iosevka Nerd Font-15")
(setq doom-modeline-height 30     ;; sets modeline height
      doom-modeline-bar-width 5   ;; sets right bar width
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t) ;; adds folder icon next to persp name

(xterm-mouse-mode 1)

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Edit agenda file" "a" #'(lambda () (interactive)
                                        (find-file
                                         "~/Documents/Notes/20220819130052-agenda.org"))
       :desc "Edit doom config.org" "c" #'(lambda () (interactive)
                                            (find-file
                                             "~/.config/doom/config.org"))
       :desc "Edit doom init.el" "i" #'(lambda () (interactive)
                                         (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive)
                                             (find-file "~/.config/doom/packages.el"))))

(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.500)
(setq lsp-log-io nil) ; if set to true can cause a performance hit
;; c# LSP
(after! lsp-mode
    (setq lsp-csharp-server-path "/usr/bin/omnisharp"))

(after! org
  (setq org-directory "~/Documents/Notes/"
        org-agenda-files (directory-files-recursively
                          "~/Documents/Notes" "\\.org$")
        ;; org-default-notes-file (expand-file-name "Notes.org" org-directory)
        org-id-locations-file "~/Documents/Notes/.orgids"
        org-attach-id-dir "~/Documents/Notes/images"
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-item-bullet-alist '((?+ . ?+) (?- . ?-))
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence
           "TODO(t)" ; A task that needs doing & is ready to do
           "PROJ(p)" ; A project, which usually contains other tasks
           "ART(a)" ; Similar to PROJ but focused on drawing
           "IDEA(i)" ; Misc tasks, usually to elaborate on writing later
           "HOLD(h)" ; This task is paused/on hold because I'm a lazy fuck
           "|"
           "DONE(d)" ; Task succesfully completed
           "CANCELED(c)") ; Task was cancelled
          (sequence
           "[ ](T)" ; A task that needs doing
           "[-](S)" ; A task in progress
           "[?](H)" ; A task on hold
           "|"
           "[X](D)")) ;  A task completed
        org-todo-keyword-faces
        '(("[-]" . +org-todo-active)
          ("[?]" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("ART" . +org-todo-project)
          ("IDEA" . +org-todo-project)
          ("PROJ" . +org-todo-project)
          ("CANCELED" . +org-todo-cancel)))
  (require 'org-habit))

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
  '(org-document-title ((t (:inherit outline-1 :height 2.0))))
)

;; (use-package org-alert
;;   :ensure t)
;; (setq alert-default-style 'libnotify
;;       org-alert-interval 3600)
;; ;; Auto start org-alert when emacs/daemon load
;; (org-alert-enable)

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((R . t)
;;    (emacs-lisp . t)
;;    (nix . t)))

(require 'org-inlinetask)
(setq org-inlinetask-min-level 9)

(setq deft-directory "~/Documents/Notes/")
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Documents/Notes/")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
      '(("d" "default" entry "* %<%I:%M %p>: %?"
         :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("l" "programming language" plain
      (file "/home/jawz/.config/doom/templates/programming.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+filetags: :programming:language:${title}:\n#+title: ${title}")
      :unnarrowed t)
     ("e" "political events" plain
      (file "/home/jawz/.config/doom/templates/events.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+filetags: :politics:conflicts:\n#+title: ${title}")
      :unnarrowed t)
     ("p" "project" plain
      "* PROJ ${title}\n%?\n* Tasks"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+category: ${title}\n#+filetags: :project:\n#+title: ${title}")
      :unnarrowed t)
     ))
  :bind()
  :bind-keymap()
  :config
  (org-roam-db-autosync-mode))
(setq completion-ignore-case t)
(set-file-template! "~/Documents/Notes/.+\\.org$" 'org-mode :ignore t)

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
    ;; :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil))

(use-package! org-transclusion
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   (:prefix ("n r" . "toggle")
    :desc "Org Transclussion Add" "a" #'org-transclusion-add
    :desc "Org Transclusion Mode" "t" #'org-transclusion-mode)))

(after! undo-tree
  (setq undo-tree-auto-save-history nil))

;; (remove-hook 'undo-fu-mode-hook #'global-undo-fu-session-mode)

(setq user-full-name "Danilo Reyes"
      user-mail-address "CaptainJawZ@outlook.com")

(custom-set-variables
 '(flycheck-flake8-maximum-line-length 88)
 '(safe-local-variable-values '((git-commit-major-mode . git-commit-elisp-text-mode))))

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

(defadvice! fixed-flycheck-proselint-parse-errors-a (output checker buffer)
  :override #'flycheck-proselint-parse-errors
  (delq
   nil (mapcar (lambda (err)
                 (let-alist err
                   (and (or (not (derived-mode-p 'org-mode))
                            (save-excursion (goto-char .start)
                                            (not (org-in-src-block-p))))
                        (flycheck-error-new-at-pos
                         .start
                         (pcase .severity
                           (`"suggestion" 'info)
                           (`"warning"    'warning)
                           (`"error"      'error)
                           (_             'error))
                         .message
                         :id .check
                         :buffer buffer
                         :checker checker
                         :end-pos .end))))
               (let-alist (car (flycheck-parse-json output))
                 .data.errors))))

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)

(setq twittering-allow-insecure-server-cert t)

(map! :leader
      (:prefix ("w" . "window")
       :desc "Winner redo" "<right>" #'winner-redo
       :desc "Winner undo" "<left>" #'winner-undo))

(map! :leader
      :desc "Zap to char" "z" #'zap-to-char
      :desc "Zap up to char" "Z" #'zap-up-to-char)
