;;;; Init stuff -- Fix bugs in clj-refactor, and add things.

;;;; ___________________________________________________________________________

(defun nomis/cljr-add-command (command-spec)
  (setq cljr--all-helpers
        (sort (cons command-spec
                    cljr--all-helpers)
              (lambda (x y)
                (string-lessp (first x) (first y))))))

;;;; ___________________________________________________________________________

(when (equal (cljr--version)
             "2.3.1")
  ;; `cider-eval-ns-form` is called with arguments, but it doesn't take any.
  (defadvice cider-eval-ns-form (around fix-broken-arg-list
                                        (&rest args-to-ignore))
    ad-do-it)
  (ad-activate 'cider-eval-ns-form))

;;;; ___________________________________________________________________________

(when (equal (cljr--version)
             "2.3.1")
  ;; `cljr-slash` doesn't respect `cljr-magic-requires` being `:prompt`.
  (defun cljr-slash ()
    "Inserts / as normal, but also checks for common namespace shorthands to require.
If `cljr-magic-require-namespaces' is non-nil, typing one of the
short aliases listed in `cljr-magic-requires' followed by this
command will add the corresponding require statement to the ns
form."
    (interactive)
    (insert "/")
    (unless (or (cljr--in-map-destructuring?)
                (cljr--in-ns-above-point-p))
      (when-let (aliases (and cljr-magic-requires
                              (not (cider-in-comment-p))
                              (not (cider-in-string-p))
                              (not (cljr--in-keyword-sans-alias-p))
                              (clojure-find-ns)
                              (cljr--magic-requires-lookup-alias)))
        (let ((short (cl-first aliases)))
          (when-let (long (cljr--prompt-user-for "Require " (cl-second aliases)))
            (when (and (not (cljr--in-namespace-declaration-p (concat ":as " short "\b")))
                       (or (not (eq :prompt cljr-magic-requires))
                           ;; jsk: This seems to me to break things, so get rid
                           ;;      of it.
                           ;; (not (> (length (cl-second aliases)) 1)) ; already prompted
                           (yes-or-no-p (format "Add %s :as %s to requires?" long short))))
              (save-excursion
                (cljr--insert-in-ns ":require")
                (let ((libspec (format "[%s :as %s]" long short)))
                  (insert libspec)
                  (ignore-errors (cljr--maybe-eval-ns-form))
                  (cljr--indent-defun)
                  (cljr--post-command-message "Required %s" libspec))))))))))

;;;; ___________________________________________________________________________

(when (equal (cljr--version)
             "2.3.1")
  
  (defun nomis/cljr-clean-ns-no-prune ()
    "Clean the ns form for the current buffer, without pruning."
    (interactive)
    (cljr--ensure-op-supported "clean-ns")
    (cider-eval-ns-form :sync)
    (cljr--clean-ns nil t))
  
  (nomis/cljr-add-command
   '("sn" . (nomis/cljr-clean-ns-no-prune "Clean ns no prune" ?c ("ns")))))

;;;; ___________________________________________________________________________

(when (equal (cljr--version)
             "2.3.1")  
  
  (defun nomis/cljr-cycle-collection-type ()
    "Display a message that describes the replacements for cycle collection."
    (interactive)
    (message (s-join " "
                     '("Use C-c C-r xxxx"
                      " where xxxx is one of x or C-x where x is one of"
                      " (  '  {  [  #")))
    (beep))
  
  (nomis/cljr-add-command
   '("cc" . (nomis/cljr-cycle-collection-type "Describe replacements for cycle collection." ?y ("code")))))

;;;; ___________________________________________________________________________

(provide 'nomis-clj-refactor-fixes)
