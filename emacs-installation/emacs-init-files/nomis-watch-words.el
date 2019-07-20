;;;; Init stuff -- Watch words.

(defvar nomis/watch-words/finger-pointers
  ;; Use \\ in the strings below so you don't get the highlighting here.
  '("-\\-.+--▶"))

(defvar nomis/watch-words/high-priority
  ;; Use \\ in the strings below so you don't get the highlighting here.
  '("F\\IXME"
    "F\\IX"
    "T\\ODO-THINK"
    "T\\ODO-with-Picasso-on-site"
    "T\\ODO"
    "T\\O-CHECK"
    "R\\EMAINING-ISSUE"
    "H\\ACK"
    "R\\EFACTOR"
    "N\\OCOMMIT"
    "Q\\UESTION/ACTION"
    "L\\EARNING-NOW"))

(defvar nomis/watch-words/low-priority-prefix "x")

(defvar nomis/watch-words/low-priority
  ;; Use \\ in the strings below so you don't get the highlighting here.
  (append '()
          (mapcar #'(lambda (string)
                      (concat nomis/watch-words/low-priority-prefix
                              string))
                  nomis/watch-words/high-priority)))

(defface nomis/watch-word-face/no-priority
  `((t (:foreground ,(case 2
                       (1 "gray27")
                       (2 "DodgerBlue3"))
                    :bold t
                    :italic t
                    )))
  "Face for low priority watch words.")

(defface nomis/watch-word-face/low-priority
  '((t (:foreground "White"
                    :background "Pink4"
                    :bold t
                    :italic t)))
  "Face for low priority watch words.")

(defun nomis/make-regex-from-watchwords-helper (words beginning-of-word-p)
  (with-output-to-string
    (when beginning-of-word-p (princ "\\<"))
    (princ "\\(")
    (princ (first words))
    (dolist (w (rest words))
      (princ "\\|")
      (princ w))
    (princ "\\)")))

(defun nomis/make-regex-from-watchwords/basic (watch-words)
  (nomis/make-regex-from-watchwords-helper watch-words
                                           nil))

(defun nomis/make-regex-from-watchwords/simple (watch-words)
  (nomis/make-regex-from-watchwords-helper watch-words
                                           t))

(defun nomis/make-regex-from-watchwords/bracketed (watch-words)
  (let* ((bracketed-watch-words
          (mapcar (lambda (word) (concat "\\[" word "]"))
                  watch-words)))
    (nomis/make-regex-from-watchwords-helper bracketed-watch-words
                                             nil)))

(defun nomis/add-watch-words*/basic (watch-words face)
  (font-lock-add-keywords
   nil
   `((,(nomis/make-regex-from-watchwords/basic watch-words)
      0 ',face t))))

(defun nomis/add-watch-words* (watch-words face)
  (font-lock-add-keywords
   nil
   `((,(nomis/make-regex-from-watchwords/simple watch-words)
      0 ',face t)
     (,(nomis/make-regex-from-watchwords/bracketed watch-words)
      0 ',face t))))

(defun nomis/add-watch-words ()
  (nomis/add-watch-words*/basic nomis/watch-words/finger-pointers
                                'nomis/watch-word-face/no-priority)
  (nomis/add-watch-words* nomis/watch-words/low-priority
                          'nomis/watch-word-face/low-priority)
  (nomis/add-watch-words* nomis/watch-words/high-priority
                          font-lock-warning-face))

(add-hook 'text-mode-hook 'nomis/add-watch-words)
(add-hook 'prog-mode-hook 'nomis/add-watch-words)

;;;; ___________________________________________________________________________
;;;; Stuff for testing the above:

;;;; - [QUESTION/ACTION]aaa
;;;; - QUESTION/ACTIONaaa
;;;; - [FIXME]aaa
;;;; - FIXMEaaa
;;;; - [FIX]aaa
;;;; - FIXaaa
;;;; - [TODO-THINK]aaa
;;;; - TODO-THINKaaa
;;;; - [TODO]aaa
;;;; - TODOaaa
;;;; - [TODO-with-Picasso-on-site]aaa
;;;; - TODO-with-Picasso-on-siteaaa
;;;; - [HACK]aaa
;;;; - HACKaaa
;;;; - [REFACTOR]aaa
;;;; - REFACTORaaa
;;;; - [NOCOMMIT]aaa
;;;; - NOCOMMITaaa
;;;; - [REMAINING-ISSUE]aaa
;;;; - REMAINING-ISSUEaaa

;;;; - [xQUESTION/ACTION]aaa
;;;; - xQUESTION/ACTIONaaa
;;;; - [xFIXME]aaa
;;;; - xFIXMEaaa
;;;; - [xFIX]aaa
;;;; - xFIXaaa
;;;; - [xTODO-THINK]aaa
;;;; - xTODO-THINKaaa
;;;; - [xTODO]aaa
;;;; - xTODOaaa
;;;; - [xTODO-with-Picasso-on-site]aaa
;;;; - xTODO-with-Picasso-on-siteaaa
;;;; - [xHACK]aaa
;;;; - xHACKaaa
;;;; - [xREFACTOR]aaa
;;;; - xREFACTORaaa
;;;; - [xNOCOMMIT]aaa
;;;; - xNOCOMMITaaa
;;;; - [xREMAINING-ISSUE]aaa
;;;; - xREMAINING-ISSUEaaa

;;;; - --x-y-z--▶

;;;; ___________________________________________________________________________

(provide 'nomis-watch-words)
