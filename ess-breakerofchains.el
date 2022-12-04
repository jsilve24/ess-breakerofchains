;;; ess-breakerofchains.el --- summary -*- lexical-binding: t -*-

;; Author: Justin Silverman (justinsilverman@psu.edu)
;; Maintainer: Justin Silverman (justinsilverman@psu.edu)
;; Version: 0.1
;; Package-Requires: (ess)
;; Homepage: https://github.com/jsilve24/ess-breakerofchains
;; Keywords: R ESS 


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
;; See README.org

;;; Code:

(require 'ess)

(defun ess-boc-break-chain (&optional dont-print-result dont-assign-result)
    "Elisp port of break_chains. Do not print result if universal-argument passed."
  (interactive "P")
  (let* ((doc-lines (ess-boc--get-doc-lines))
	 (doc-cursor-line (line-number-at-pos))
	 (proc (ess-get-process))
	 (dont-print-result-p (if dont-print-result  "FALSE" "TRUE"))
	 (dont-assign-result-p (if dont-assign-result "FALSE" "TRUE"))
	 ;; doc-lines to formated R vector
	 (doc-lines-r (ess-boc--parse-doc-lines doc-lines)))
    ;; make sure breakerofchains and ess-breakerofchains is installed
    ;; TODO make this smarter, if not installed, then install. 
    (ess-load-library--override "ESSBreakerOfChains")
    ;; pass to R for further processing
    (message (format "%s" dont-assign-result-p))
    (ess-send-string proc (format "ess_break_chains(%s, %s, %s, %s)"
				  doc-lines-r
				  doc-cursor-line
				  dont-print-result-p
				  dont-assign-result-p)))
  )

(defun ess-boc--get-doc-lines ()
    "Return list of buffer lines from line 1 to current line."
    (split-string (buffer-string) "\n" nil)) ; t omits nulls

(defun ess-boc--parse-doc-lines (doc-lines)
    "Parse output of ESS-BOC--GET-DOC-LINES and format into string
formated as R vector."
    (let* ((lines (mapconcat (lambda (x) (format "'%s'" x))
			     doc-lines ",")))
      (format "c(%s)" lines)))

(defun ess-boc-install-r-package ()
  "Install the ESSBreakerOfChains R Package if not already installed."
  (interactive)
  (let* ((dir (file-name-directory (buffer-file-name))))
    (ess-r-package-eval-linewise
     (format  "devtools::install('%s')\n" dir) "Installing %s")))

(provide 'ess-breakerofchains)

;;; ess-breakerofchains.el ends here



