(require 'package)

;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/")
;;              t)

;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/")
;;              t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa-stable.milkbox.net/packages/")
             t)

(package-initialize)
