;;;; Init stuff -- Very general stuff.

(setq-default indent-tabs-mode nil) ; use spaces, not tabs
(setq sentence-end-double-space nil)
(setq visible-bell t)
(setq whitespace-style '(face trailing lines-tail tabs))
(show-paren-mode 1)
(setq line-move-visual nil) ; the default of T is annoying, and it
                            ; screws up keyboard macros

(progn
  (defun nomis-turn-on-idle-highlight-mode ()
    (idle-highlight-mode t))
  (add-hook 'prog-mode-hook 'nomis-turn-on-idle-highlight-mode))

(when (display-graphic-p)
  ;; (mouse-wheel-mode t)
  (blink-cursor-mode -1))

;; (setq-default indent-tabs-mode nil)

(setq Buffer-menu-sort-column nil) ; 2

(add-hook 'find-file-hooks (lambda () (auto-fill-mode -1)))

(defalias 'yes-or-no-p 'y-or-n-p)

(defmacro defparameter (symbol &optional initvalue docstring)
  `(progn
     (defvar ,symbol nil ,docstring)
     (setq   ,symbol ,initvalue)))

;; (global-set-key (kbd "<escape>") 'keyboard-quit)
                                        ; hmmm, so I can't do ESC C-k -- not a huge deal, but annoying -- have I lost anything else?

;;;; ___________________________________________________________________________

(provide 'nomis-very-general-stuff)
