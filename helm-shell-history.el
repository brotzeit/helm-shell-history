;;; helm-shell-history.el --- Helm interface for shell history -*- lexical-binding: t -*-

;; Copyright (C) 2018  Fritz Stelzer <brotzeitmacher@gmail.com>

;; Author: Fritz Stelzer <brotzeitmacher@gmail.com>
;; URL: https://github.com/brotzeit/helm-shell-history
;; Version: 0.1
;; Package-Requires: ((emacs "25.1") (helm "1.9.4"))

;;; License:
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;;; Code:

(require 'helm)

(defun helm-shell-history-items ()
  "Get candidates for helm source."
  (let ((history (-slice (split-string (shell-command-to-string "sh -ic 'echo $HISTFILE' |xargs cat")
                                       "\n") 
                         1 -1))
        items
        (line 0))
    (dolist (item history)
      (setq line (+ line 1))
      (push (concat (propertize (int-to-string line) 'font-lock-face '(:foreground "#6e8b3d"))
                    " "
                    item)
            items))
    items))
 
(defun helm-shell-history-source ()
  "Helm source for shell history."
  (helm-build-sync-source "Helm shell history"
    :candidates (lambda ()
                  (helm-shell-history-items))
    :action (lambda (candidate)
              (goto-char (point-max))
              (insert (nth 1 (split-string candidate "^[0-9]+\s"))))
    :persistent-action (lambda (candidate)
                         (goto-char (point-max))
                         (insert (nth 1 (split-string candidate "^[0-9]+\s")))
                         (comint-send-input))
    :candidate-number-limit 99999))

(defun helm-shell-history ()
  "Preconfigured helm for shell history."
  (interactive)
  (helm :sources (helm-shell-history-source)
        :truncate-lines t
        :buffer "*helm-shell-hist*"))

(provide 'helm-shell-history)
;;; helm-helm-shell-history.el ends here
