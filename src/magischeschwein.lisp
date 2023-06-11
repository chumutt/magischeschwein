(in-package :magischeschwein)

;; Define your project functionality here...

(defparameter *input-headers* (car (cl-csv:read-csv #P"../tests/headers.csv"))
  "Contains the new (ledger-cli compatible) headers.")

(defparameter *input-table*
  (mapcar #'cdr (cddddr (cl-csv:read-csv #P"../tests/example-input-file.csv")))
  "Contains the original table (the csv file to be inputted) in list form with
the original header rows removed and the first column of values (transaction ids) removed as well.")

(defparameter *output-table*
  (cons *input-headers* *input-table*)
  "Contains the result of combining the new *input-headers* with *input-table*
(the latter having its original headers removed).")

(defun barf ()
  (cl-csv:write-csv *output-table* :stream #P"../tests/example-output-file.csv"))

(defun help ()
  (format T "~&Usage:

  magischeschwein [name]~&"))

(defun %main (argv)
  "Parse CLI args."
  (when (member "-h" argv :test #'equal)
    ;; To properly parse command line arguments, use a third-party library such as
    ;; clingon, unix-opts, defmain, adopt… when needed.
    (help)
    (uiop:quit))
  (commence-with argv)
  (uiop:quit))

(defun main ()
  "Entry point for the executable.
  Reads command line arguments."
  ;; uiop:command-line-arguments returns a list of arguments (sans the script name).
  ;; We defer the work of parsing to %main because we call it also from the Roswell script.
  (%main (uiop:command-line-arguments)))
