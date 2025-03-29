;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)

;; (package! nixos-options) ;; enable when migrating to nixos
;; (package! quick-preview) ;; preview files with sushi


;; (package! codeium :recipe (:host github :repo "Exafunction/codeium.el"))
(package! config-general-mode)
(package! dired-open)
(package! dired-subtree)
(package! doom-modeline-now-playing)
(package! ini-mode)
(package! insert-esv) ;; bible passages
(package! olivetti) ;; writing mode centering text, looks like word
(package! org-auto-tangle)
(package! org-roam-ui)
(package! org-transclusion)
(package! peep-dired) ;; kind of cool but never could make it work
(package! php-cs-fixer)
(package! systemd)
;; (package! 2048-game)
;; (package! academic-phrases)
;; (package! caddyfile-mode)
;; (package! clippy)
;; (package! crontab-mode) ;; crontab colors
;; (package! evil-tutor) ;; vim tutorial
;; (package! ewal) ;; theme colors based on pywal
;; (package! ewal-doom-themes)
;; (package! ewal-evil-cursors)
;; (package! fish-completion) ;; what does it do???????????????????????????
;; (package! flycheck-aspell)
;; (package! ivy-posframe)
;; (package! mw-thesaurus)
;; (package! org-alert)
;; (package! org-appear) ;; couldn't get it to work
;; (package! org-recur) ;; works but I want to keep org vanilla
;; (package! ox-chameleon
;;   :recipe (:host github :repo "tecosaur/ox-chameleon"))
;; (package! renpy)
;; (package! resize-window)
;; (package! tldr)
;; (package! typit) ;; type speed test
;; (package! vimgolf) ;; vim puzzles
;; (package! wc-mode) ;; displays character count of buffer
