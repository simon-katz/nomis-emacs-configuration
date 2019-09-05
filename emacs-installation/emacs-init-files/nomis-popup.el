;;;; nomis-popup --- A layer on top of popup  ---  -*- lexical-binding: t -*-

(progn) ; this-stops-hs-hide-all-from-hiding-the-next-comment

;;;; ___________________________________________________________________________
;;;; ____ * Require things

(require 'nomis-scrolling)

;;;; ___________________________________________________________________________
;;;; ____ * Parameterisation

(defvar nomis/popup/duration 1)

;;;; ___________________________________________________________________________
;;;; ____ * Private parameterisation

(defvar -nomis/popup/muted-yellow "#fefd90")

(defface -nomis/popup/face
  `((t (:foreground "black" :background ,-nomis/popup/muted-yellow)))
  "Face used for popups.")

(defvar -nomis/popup/pink "pink")

(defface -nomis/popup/error-face
  `((t (:foreground "black" :background ,-nomis/popup/pink)))
  "Face used for popups.")

;;;; ___________________________________________________________________________
;;;; ____ * nomis/popup/message

(defvar -nomis/popup/most-recent-popup-time nil)

(defun -make-nomis-popup-overlay (face start-pos end-pos &rest props)
  (let* ((ov (make-overlay start-pos end-pos)))
    (overlay-put ov 'category 'nomis-popup)
    (overlay-put ov 'face     face)
    (while props (overlay-put ov (pop props) (pop props)))
    ov))

(defun -nomis/popup/point-invisible? (&optional pos)
  ;; Copied from `org-invisible-p`. Why "after POS" (in doc string)?
  "Non-nil if the character after POS is invisible.
If POS is nil, use `point' instead."
  (get-char-property (or pos (point)) 'invisible))

(defun -nomis/popup/remove-existing-popups (&optional force?)
  (when (or force?
            (>= (float-time)
                (+ -nomis/popup/most-recent-popup-time
                   nomis/popup/duration)))
    (remove-overlays nil nil 'category 'nomis-popup)))

(defun -nomis/popup/remove-existing-popups/force ()
  (-nomis/popup/remove-existing-popups t))

(add-hook 'pre-command-hook '-nomis/popup/remove-existing-popups/force)

(defun -nomis/popup/message* (face format-string &rest args)
  (cl-flet ((n-chars-we-can-replace-at-pos
             (pos)
             (let* ((n-chars-before-eol
                     (save-excursion
                       (- (- (progn (goto-char pos) (point))
                             (progn (end-of-line) (point)))))))
               (or (loop for i from 0 to n-chars-before-eol
                         when (-nomis/popup/point-invisible? (+ pos i))
                         return (1- i))
                   n-chars-before-eol))))
    (-nomis/popup/remove-existing-popups/force)
    (let* ((msg (apply #'format format-string args))
           (len (length msg))
           (popup-pos (save-excursion
                        (unless (get-char-property
                                 (point)
                                 'invisible)
                          (ignore-errors
                            (previous-line (min (nomis/line-no-in-window)
                                                1))))
                        (point)))
           (msg-part-1-len (min len
                                (n-chars-we-can-replace-at-pos popup-pos)))
           (ov1-start-pos popup-pos)
           (ov2-start-pos (+ popup-pos msg-part-1-len)))
      (let* ((msg-part-1 (substring msg 0 msg-part-1-len))
             (ov1 (-make-nomis-popup-overlay face
                                             ov1-start-pos
                                             ov2-start-pos
                                             'display  msg-part-1))))
      (let* ((msg-part-2 (substring msg msg-part-1-len)))
        (unless (equal msg-part-2 "")
          (put-text-property 0
                             (length msg-part-2)
                             'face
                             face
                             msg-part-2)
          (let* ((ov2 (-make-nomis-popup-overlay face
                                                 ov2-start-pos
                                                 ov2-start-pos
                                                 'before-string msg-part-2))))))
      (setq -nomis/popup/most-recent-popup-time (float-time))
      (let* ((buffer (current-buffer)))
        (run-at-time nomis/popup/duration
                     nil
                     (lambda ()
                       (when (buffer-live-p buffer)
                         (with-current-buffer buffer
                           (-nomis/popup/remove-existing-popups)))))))))

(defun nomis/popup/message (format-string &rest args)
  (apply #'-nomis/popup/message*
         '-nomis/popup/face
         format-string
         args))

(defvar nomis/popup/error-message-prefix "!! ")

(defun nomis/popup/error-message (format-string &rest args)
  (apply #'-nomis/popup/message*
         '-nomis/popup/error-face
         (concat nomis/popup/error-message-prefix
                 format-string)
         args))

;;;; ___________________________________________________________________________
;;;; * End

(provide 'nomis-popup)
