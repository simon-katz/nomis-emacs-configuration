;;;; Init stuff -- Frames.

;;;; ___________________________________________________________________________

(require 'frame-cmds)

;;;; ___________________________________________________________________________
;;;; ---- Sort out menu bars, tools bars and scroll bars ----

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode +1))

;;;; ___________________________________________________________________________
;;;; ---- Get rid of some annoying key bindings ----

(when (and (not (null window-system))
           (eql (key-binding (kbd "C-z")) 'suspend-frame))
  (global-unset-key (kbd "C-z")))

(defun nomis-do-not-close-lots-of-frames (arg)
  (interactive "p")
  (message "No, I won't close lots of frames."))

(define-key ctl-x-5-map "1"
  'nomis-do-not-close-lots-of-frames) ; default was `delete-other-frames`

;;;; ___________________________________________________________________________
;;;; ---- Closing frames ----

;; Should do this for MS Windows only, I guess.
;; (define-key global-map [(meta f4)] 'delete-frame)

(progn
  ;; Deal with delete-frame.
  ;; The default C-x 5 0 is too long.
  ;; Can't use the normal M-w without stealing from Emacs.
  ;; This is ok:
  (define-key global-map (kbd "M-W") 'delete-frame))

;;;; ___________________________________________________________________________
;;;; ---- Frame title ----

(when (display-graphic-p)
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

;;;; ___________________________________________________________________________
;;;; ---- Frame size ----

(defvar nomis-extra-width-for-each-window 91)

(defvar nomis-single-window-frame-width 85)
(defvar nomis-double-window-frame-width (+ nomis-single-window-frame-width
                                           nomis-extra-width-for-each-window))
(defvar nomis-triple-window-frame-width (+ nomis-double-window-frame-width
                                           nomis-extra-width-for-each-window))

;;;; ___________________________________________________________________________
;;;; ---- Cycle frames ----

;;;; Would use OS stuff for this, but various combinations of OS X and Emacs
;;;; give various different behaviours, including stack backtraces, going to
;;;; Emacs menus and even, in some cases (Lion and 24.2 IIRC), cycling frames.

(defun other-frame-backwards ()
    (interactive)
    (other-frame -1))

(define-key global-map (kbd "M-`") 'other-frame)
(define-key global-map (kbd "M-~") 'other-frame-backwards)

;;;; ___________________________________________________________________________
;;;; ---- Default frame size ----

(defvar nomis-window-height
  (cond ((string-equal (system-name) "CHIVERS")
         ;; 1200 pixels
         72)
        ((string-equal (system-name) "GILZEAN2")
         ;; 1050 pixels
         62)
        ((string-equal (system-name) "JENNINGS")
         ;; 800 pixels
         47)
        ((string-equal (system-name) "Simon-Katzs-MacBook-Pro.local")
         ;; 1050 pixels - menu bar
         66)
        ((member (system-name) ; this keeps changing --why? Ah! At the time of writing it's "188.28.48.230.threembb.co.uk", which mentions "three" and I'm on my data connection with 3connect
                 (list "unknown-70-56-81-a2-7a-0f.home"
                       "Perryman.local"
                       "perryman.home"
                       "lonmaclt002.home"))
         ;; 900 pixels - menu bar
         56)
        ((member (system-name) ; this keeps changing --why? Ah! At the time of writing it's "188.28.48.230.threembb.co.uk", which mentions "three" and I'm on my data connection with 3connect
                 (list "unknown-3c-15-c2-e6-e3-64.home" ; sheringham sometimes
                       "sheringham.local"
                       "sheringham.home"))
         ;; 900 pixels - menu bar
         60)
        ((equal system-type 'windows-nt)
         ;; probably at the Windows work place
         61)
        (t
         66)))

(defvar nomis-frame-prefs (append
                           (if i-am-nomis-p
                               `((height . ,nomis-window-height) ; Broken when people have thingy bar at the bottom of the screen.  (Also, this depends on a particular font size.)
                                 )
                             '())
                           `((width  . ,nomis-single-window-frame-width)
                             (top . 0)
                             ;; (left . 140)
                             ;; (font . "4.System VIO")
                             ;; (foreground-color . "Black")
                             (background-color . "#f5f5f5")
                             ;;(cursor-color . "SkyBlue")
                             )))
;; (setq initial-frame-alist (append nomis-frame-prefs initial-frame-alist))
(setq default-frame-alist (append nomis-frame-prefs default-frame-alist))

;;;; ___________________________________________________________________________
;;;; ---- Commands to adjust frames ----

(require 'cl)

(progn

  (defun reasonable-string-for-frame-width-or-height-p (string)
    (eql (string-match-p "^[1-9][0-9]\\{0,2\\}$"
                         string)
         0))
  
  (assert (equal (mapcar 'reasonable-string-for-frame-width-or-height-p
                         '("0" "1" "12" "123" "1234" "xyz12"))
                 '(nil t t t nil nil)))
  
  (defun read-reasonable-frame-width-or-height (kind current-value)
    (let* ((string (read-from-minibuffer
                    (format "Enter new frame %s (currently %s): "
                            kind
                            current-value))))
      (if (reasonable-string-for-frame-width-or-height-p string)
          (string-to-number string)
        (error "Silly %s: %s" kind string))))
    
  (defun nomis-set-frame-width* (width)
    (set-frame-width (selected-frame) width))
  
  (defun nomis-set-frame-width ()
    (interactive "")
    (nomis-set-frame-width*
     (read-reasonable-frame-width-or-height "width" (frame-width))))
   
  (defun nomis-w-single ()
    (interactive)
    (nomis-set-frame-width* nomis-single-window-frame-width))

  (defun nomis-w-double ()
    (interactive)
    (nomis-set-frame-width* nomis-double-window-frame-width))

  (defun nomis-w-triple ()
    (interactive)
    (nomis-set-frame-width* nomis-triple-window-frame-width))

  (defun nomis-set-frame-height* (height)
    (set-frame-height (selected-frame) height))
  
  (defun nomis-set-frame-height ()
    (interactive "")
    (nomis-set-frame-height*
     (read-reasonable-frame-width-or-height "height" (frame-height))))
  
  (defun nomis-maximize-frame-vertically-assuming-toolbar-of-size-arg (arg)
    (interactive "P")
    (maximize-frame-vertically)
    (redisplay)
    (nomis-set-frame-height* (- (frame-height) (or arg 2))))

  (defun nomis-h62 ()
    (interactive)
    (nomis-set-frame-height* 62))

  (defun nomis-h29 ()
    (interactive)
    (nomis-set-frame-height* 29)))

(defun nomis/move-frame-to-screen-top (n)
  (interactive (list (if current-prefix-arg
                         (* (frame-char-height)
                            (prefix-numeric-value current-prefix-arg))
                       0)))
  (move-frame-to-screen-top n))

(defun nomis/move-frame-to-screen-bottom (n)
  (interactive (list (if current-prefix-arg
                         (* (frame-char-height)
                            (prefix-numeric-value current-prefix-arg))
                       0)))
  (move-frame-to-screen-bottom n))

(defun nomis/move-frame-to-screen-left (n)
  (interactive (list (if current-prefix-arg
                         (* (frame-char-width)
                            (prefix-numeric-value current-prefix-arg))
                       0)))
  (move-frame-to-screen-left n))

(defun nomis/move-frame-to-screen-right (n)
  (interactive (list (if current-prefix-arg
                         (* (frame-char-width)
                            (prefix-numeric-value current-prefix-arg))
                       0)))
  (move-frame-to-screen-right n))

;;;; ___________________________________________________________________________

(defun nomis/frame-l-t-w-h ()
  (list (frame-parameter nil 'left)
        (frame-parameter nil 'top)
        (frame-parameter nil 'width)
        (frame-parameter nil 'height)))

(defun nomis/modify-frame-l-t-w-h (l-t-w-h)
  (modify-frame-parameters
   nil
   `((left   . ,(first l-t-w-h))
     (top    . ,(second l-t-w-h))
     (width  . ,(third l-t-w-h))
     (height . ,(fourth l-t-w-h)))))

;;;; ___________________________________________________________________________

(require 'nomis-hydra)

(defvar nomis/modify-frame/initial-state nil)

(defun nomis/modify-frame/init-state-if-unset ()
  (when (null nomis/modify-frame/initial-state)
    (setq nomis/modify-frame/initial-state
          (nomis/frame-l-t-w-h))))

(defun nomis/modify-frame/handle-quit ()
  (setq nomis/modify-frame/initial-state nil))

(defun nomis/modify-frame/handle-cancel ()
  (nomis/modify-frame-l-t-w-h nomis/modify-frame/initial-state)
  (setq nomis/modify-frame/initial-state nil))

(define-nomis-hydra nomis/modify-frame/resize
  :name-as-string "Resize frame"
  :key "H-M-Z" ; Want no key, but not sure if Hydra allows that. So use a ridiculous key chord.
  :init-form   (nomis/modify-frame/init-state-if-unset)
  :cancel-form (nomis/modify-frame/handle-cancel)
  :quit-form   (nomis/modify-frame/handle-quit)
  :hydra-heads (("<up>"        shrink-frame                      "Shrink vertically")
                ("<down>"      enlarge-frame                     "Enlarge vertically")
                ("<left>"      shrink-frame-horizontally         "Shrink horizontally")
                ("<right>"     enlarge-frame-horizontally        "Enlarge horizontally")
                ("M-<up>"      (shrink-frame 5)                  "Shrink vertically 5 times")
                ("M-<down>"    (enlarge-frame 5)                 "Enlarge vertically 5 times")
                ("M-<left>"    (shrink-frame-horizontally 5)     "Shrink horizontally 5 times")
                ("M-<right>"   (enlarge-frame-horizontally 5)    "Enlarge horizontally 5 times")
                ("C-<up>"      (shrink-frame 20)                 "Shrink vertically 20 times")
                ("C-<down>"    (enlarge-frame 20)                "Enlarge vertically 20 times")
                ("C-<left>"    (shrink-frame-horizontally 20)    "Shrink horizontally 20 times")
                ("C-<right>"   (enlarge-frame-horizontally 20)   "Enlarge horizontally 20 times")
                ("M-S-<up>"    restore-frame-vertically          "Max or restore vertically")
                ("M-S-<down>"  restore-frame-vertically          "Max or restore vertically")
                ("M-S-<left>"  restore-frame-horizontally        "Max or restore horizontally")
                ("M-S-<right>" restore-frame-horizontally        "Max or restore horizontally")
                ("M-Z"         nomis/modify-frame/move/body      "Move"   :exit t)))

(define-nomis-hydra nomis/modify-frame/move
  :name-as-string "Move frame"
  :key "M-Z"
  :init-form   (nomis/modify-frame/init-state-if-unset)
  :cancel-form (nomis/modify-frame/handle-cancel)
  :quit-form   (nomis/modify-frame/handle-quit)
  :hydra-heads (("<up>"        move-frame-up                     "Up")
                ("<down>"      move-frame-down                   "Down")
                ("<left>"      move-frame-left                   "Left")
                ("<right>"     move-frame-right                  "Right")
                ("M-<up>"      (move-frame-up 5)                 "Up 5 times")
                ("M-<down>"    (move-frame-down 5)               "Down 5 times")
                ("M-<left>"    (move-frame-left 5)               "Left 5 times")
                ("M-<right>"   (move-frame-right 5)              "Right 5 times")
                ("C-<up>"      (move-frame-up 20)                "Up 20 times")
                ("C-<down>"    (move-frame-down 20)              "Down 20 times")
                ("C-<left>"    (move-frame-left 20)              "Left 20 times")
                ("C-<right>"   (move-frame-right 20)             "Right 20 times")
                ("M-S-<up>"    nomis/move-frame-to-screen-top    "Top")
                ("M-S-<down>"  nomis/move-frame-to-screen-bottom "Bottom")
                ("M-S-<left>"  nomis/move-frame-to-screen-left   "Far left")
                ("M-S-<right>" nomis/move-frame-to-screen-right  "Far right")
                ("M-Z"         nomis/modify-frame/resize/body    "Resize" :exit t)))

;;;; ___________________________________________________________________________

(defun nomis-maximize-all-frame-heights ()
  (interactive)
  (mapc (lambda (frame) (maximize-frame-vertically frame t))
        (frame-list)))

;;;; ___________________________________________________________________________

(define-key global-map (kbd "H-q 1") 'nomis-w-single)
(define-key global-map (kbd "H-q 2") 'nomis-w-double)
(define-key global-map (kbd "H-q 3") 'nomis-w-triple)
(define-key global-map (kbd "H-q v") 'maximize-frame-vertically)
(define-key global-map (kbd "H-q V") 'nomis-maximize-frame-vertically-assuming-toolbar-of-size-arg)
(define-key global-map (kbd "H-q h") 'maximize-frame-horizontally)

;;;; ___________________________________________________________________________

(provide 'nomis-frames)
