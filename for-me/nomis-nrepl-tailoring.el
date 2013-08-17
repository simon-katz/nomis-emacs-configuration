;;;; Init stuff -- nrepl tailoring

(require 'nrepl)
(require 'nomis-define-lispy-modes)

;;;; ___________________________________________________________________________
;;;; ---- Basics ----

;;;; See https://github.com/kingtim/nrepl.el

;;;; ---------------------------------------------------------------------------
;;;; ---- Stuff for the REPL ----

(setq nrepl-history-file "~/.nrepl-history.eld")

(add-to-list 'same-window-buffer-names "*nrepl*")

(add-hook 'nrepl-mode-hook 'nomis-lispy-repl-setup)
(add-hook 'nrepl-mode-hook 'nomis-clojure-setup)

;;;; ---------------------------------------------------------------------------
;;;; ---- Stuff for when connected to nrepl       ----
;;;; ---- (for repl and for Clojure source files) ----

(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)

;; TODO: I've seen this a lot. Do I want it?
;; (setq nrepl-popup-stacktraces nil)

;;;; ___________________________________________________________________________

(provide 'nomis-nrepl-tailoring)
