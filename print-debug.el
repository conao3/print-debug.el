;;; print-debug.el --- Assisted printf debugging  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience
;; Package-Requires: ((emacs "26.1"))
;; URL: https://github.com/conao3/print-debug.el

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Assisted printf debugging.

;; This package is inspired by [[https://github.com/sentriz/vim-print-debug][sentriz/vim-print-debug]].


;;; Code:

(require 'cl-lib)
(require 'format-spec)

(defgroup print-debug nil
  "Assisted printf debugging."
  :prefix "print-debug-"
  :group 'tools
  :link '(url-link :tag "Github" "https://github.com/conao3/print-debug.el"))

(defcustom print-debug-header-length 10
  "Header length."
  :group 'print-debug
  :type 'integer)

(defcustom print-debug-ext-template
  '((el . "(message \"+++ %S\")")
    (go . "fmt.Printf(\"+++ %S\\n\")")
    (py . "print(f\"+++ %S\")")
    (js . "console.log(`+++ %S`);")
    (c . "printf(\"+++ %S\\n\");"))
  "Print debug template alist based on file extension.

The following %-sequences are supported:
`%S' The header that changes every time
     (Length is `print-debug-header-length'.).

`%s' The char that changes every time."
  :group 'print-debug
  :type 'sexp)

(defcustom print-debug-major-mode-template
  '((c++-mode . c))
  "Print debug template alist based on `major-mode'."
  :group 'print-debug
  :type 'sexp)


;; functions

(defvar print-debug-count -1)
(defvar print-debug-chars
  "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&*+,-.~/:;<=>?@^_`|")

(defun print-debug-incf-count()
  "Incf `print-debug-count'."
  (cl-incf print-debug-count)
  (setq print-debug-count (mod print-debug-count (length print-debug-chars))))

(defun print-debug-get-template ()
  "Get appropriate template."
  (or
   (when-let (ext (file-name-extension (buffer-file-name)))
     (alist-get (intern ext) print-debug-ext-template))

   (when-let (obj (alist-get major-mode print-debug-major-mode-template))
     (if (symbolp obj)
         (alist-get obj print-debug-ext-template)
       obj))

   (error "Cannot find appropriate template!")))

(defun print-debug-insert-1 ()
  "Internal function of `print-debug-insert'."
  (save-excursion
    (beginning-of-line)
    (let ((indent (skip-chars-forward " " (line-end-position))))
      (insert (format-spec
               (print-debug-get-template)
               (let ((char (elt print-debug-chars print-debug-count)))
                 `((?S . ,(make-string print-debug-header-length char))
                   (?s . ,char)))))
      (newline)
      (insert (make-string indent ?\s)))))

;;;###autoload
(defun print-debug-insert (&optional arg)
  "Insert print debug template.
ARG is prefix argument."
  (interactive "p")
  (let (wrap)
    (cl-case arg
      (1 (print-debug-incf-count))
      (4 (setq print-debug-count 0))
      (16 (setq wrap t)))

  (if (not wrap)
      (print-debug-insert-1)
    (print-debug-insert-1)
    (print-debug-incf-count)
    (save-excursion
      (forward-line)
      (print-debug-insert-1)))))

(provide 'print-debug)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; print-debug.el ends here
