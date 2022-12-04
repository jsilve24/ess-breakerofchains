;;; ess-breakerofchains.el --- summary -*- lexical-binding: t -*-

;; Author: Justin Silverman (justinsilverman@psu.edu)
;; Maintainer: Justin Silverman (justinsilverman@psu.edu)
;; Version: version
;; Package-Requires: (dependencies)
;; Homepage: homepage
;; Keywords: keywords


;; This file is not part of GNU Emacs
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; commentary

;;; Code:

(require 'ess)

(defun ess-boc-break-chain (&optional print-result assign-result)
    "Elisp port of break_chains."
  (interactive)
  (let* ((doc-lines (ess-boc--get-doc-lines))
	 (doc-cursor-line (line-number-at-pos))
	 (proc (ess-get-process))
	 (print-result-p (if print-result "TRUE" "FALSE"))
	 (assign-result-p (if assign-result "TRUE" "FALSE"))
	 ;; doc-lines to formated R vector
	 (doc-lines-r (ess-boc--parse-doc-lines doc-lines)))
    ;; make sure breakerofchains and ess-breakerofchains is installed
    ;; ...
    ;; pass to R for further processing
    (ess-send-string proc (format "ess_break_chains(%s, %s, %s, %s)"
				  doc-lines-r
				  doc-cursor-line
				  print-result-p
				  assign-result-p)))
  )

(defun ess-boc--get-doc-lines ()
    "Return list of buffer lines from line 1 to current line."
    (split-string (buffer-string) "\n" t)) ; t omits nulls

(defun ess-boc--parse-doc-lines (doc-lines)
    "Parse output of ESS-BOC--GET-DOC-LINES and format into string
formated as R vector."
    (let* ((lines (mapconcat (lambda (x) (format "'%s'" x))
			     doc-lines ",")))
      (format "c(%s)" lines)))

(provide 'ess-breakerofchains)

;;; ess-breakerofchains.el ends here

