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

(defgroup print-debug nil
  "Assisted printf debugging."
  :prefix "print-debug-"
  :group 'tools
  :link '(url-link :tag "Github" "https://github.com/conao3/print-debug.el"))

(provide 'print-debug)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; print-debug.el ends here
