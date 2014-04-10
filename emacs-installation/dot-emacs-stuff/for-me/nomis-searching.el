;;;; Init stuff -- Searching.

;; ;;;; ___________________________________________________________________________
;; ;;;; ---- Stuff for rgrep and lgrep ----

(progn
  (defvar *extra-ignored-directories*
    '(;; "labrepl*/public/javascripts/jquery.js"
      ;; "emacs-configuration/nomis-addons/cygwin-mount.el"
      ".emacs.d"
      ".worksheet"))
  (defvar *extra-ignored-files*
    '(;; ".jar"
      ;; ".exe"
      ))
  (eval-after-load "grep"
    '(progn
       (mapc (lambda (x) (add-to-list 'grep-find-ignored-files x))
             *extra-ignored-files*)
       (mapc (lambda (x) (add-to-list 'grep-find-ignored-directories x))
             *extra-ignored-directories*))))

;;;; ___________________________________________________________________________

(progn
  ;; M-> and M-< are by default bound to end-of-buffer and
  ;; beginning-of-buffer, which are also bound to C-end and C-home.
  ;; Rebind M-> and M-< without much lossage.
  (define-key global-map (kbd "M->") 'next-error)
  (define-key global-map (kbd "M-<") 'previous-error))

;;;; ___________________________________________________________________________
;;;; Better grepping.

;;;; Based on code found at
;;;; https://github.com/magnars/.emacs.d/blob/master/setup-rgrep.el.
;;;; Note:
;;;;   I had tried something that advised `grep-read-files`, but that didn't
;;;;   work. Looks like `grep-read-files` does some weird side-effecty stuff.
;;;;   In any case, I don't understand and I gave up on that approach.

(defun -nomis-rgrep-interactive-stuff (all-p)
  (progn
    (grep-compute-defaults)
    (cond
     ((and grep-find-command (equal current-prefix-arg '(16)))
      (list (read-from-minibuffer "Run: " grep-find-command
                                  nil nil 'grep-find-history)))
     ((not grep-find-template)
      (error "grep.el: No `grep-find-template' available"))
     (t (let* ((regexp (grep-read-regexp))
               (files (if all-p
                          "*"
                        (grep-read-files regexp)))
               (dir (ido-read-directory-name "Base directory: "
                                             nil default-directory t))
               (confirm (equal current-prefix-arg '(4))))
          (list regexp files dir confirm))))))

(defun nomis-rgrep (regexp &optional files dir confirm)
  "A variation of `rgrep` that:
- uses `ido-read-directory-name` for nicer directory navigation."
  (interactive (-nomis-rgrep-interactive-stuff nil))
  (rgrep regexp files dir confirm))

(defun nomis-rgrep-all-unignored-files (regexp &optional files dir confirm)
  "A variation of `rgrep` that:
- uses `ido-read-directory-name` for nicer directory navigation
- searches all (unignored) files."
  (interactive (-nomis-rgrep-interactive-stuff t))
  (rgrep regexp files dir confirm))

(define-key global-map (kbd "C-c C-x C-c") 'nomis-rgrep)
(define-key global-map (kbd "C-c C-x C-s") 'nomis-rgrep-all-unignored-files)

;;;; ___________________________________________________________________________
;;;; ---- Stuff for rgrep and lgrep ----

;; (defadvice grep-tag-default (around change-space-to-todo ()) ; TODO: Huh? What's this for?
;;   (flet ((do-it () ad-do-it))
;;     (when (string-equal (do-it) "")
;;       (setq ad-return-value
;;             ;; use \ below so this doesn't show up in searches
;;             "TOD\O"))))
;; (ad-activate 'grep-tag-default)

;; (define-key global-map (kbd "C-c C-v C-s") 'rgrep)

;;;; ___________________________________________________________________________

(provide 'nomis-searching)