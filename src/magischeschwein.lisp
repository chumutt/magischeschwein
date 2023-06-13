(in-package :magischeschwein)

;; Define your project functionality here...

(defparameter *input-headers* (car (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/headers.csv"))
  "Contains the new (ledger-cli compatible) headers.")

(defparameter *input-table*
  (mapcar #'cdr (cddddr (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/example-input-file.csv")))
  "Contains the original table (the csv file to be inputted) in list form with
the original header rows removed and the first column of values (transaction ids) removed as well.")

(defparameter *output-table*
  (cons *input-headers* *input-table*)
  "Contains the result of combining the new *input-headers* with *input-table*
(the latter having its original headers removed).")

(defun barf-test ()
  (cl-csv:write-csv *output-table* :stream #P"../tests/example-output-file.csv"))

(defun cli/options ()
  "Returns a list of options for our main command"
  (list
   (clingon:make-option
    :string
    :description ".csv file to input"
    :short-name #\i
    :long-name "input-file"
    :key :input-file)
   (clingon:make-option
    :string
    :description "file to output converted .csv to"
    :short-name #\o
    :long-name "output-file"
    :key :output-file)))

(defun cli/handler (cmd)
  "The handler function of our top-level command"
  (let ((free-args (clingon:command-arguments cmd))
        (input-file (clingon:getopt cmd :input-file)))
    (format t "INPUT FILE IS: ~a!~%" input-file)
    (format t "You have provided ~a more free arguments~%" (length free-args))
    (format t "Bye!~%")
    (uiop:quit)))

(defun cli/command ()
  "A command to convert a file"
  (clingon:make-command
   :name "convert"
   :description "convert a file"
   :version "0.0.1"
   :authors '("Chu the Pup <chufilthymutt@gmail.com>")
   :license "GNU GPL-3.0"
   :options (cli/options)
   :handler #'cli/handler))

(defun main ()
  "Entry point for the executable.
  Reads command line arguments."
  ;; uiop:command-line-arguments returns a list of arguments (sans the script name).
  ;; We defer the work of parsing to %main because we call it also from the Roswell script.
  (clingon:run (cli/command)))
