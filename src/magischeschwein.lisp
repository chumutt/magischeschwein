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

;; The naming with a "/" is just our convention.
(defun cli/options ()
  "Returns a list of options for our main command"
  (list
   (clingon:make-option
    :flag
    :description "short help."
    :short-name #\h
    :key :help)
   (clingon:make-option
    :string              ;; <--- string type: expects one parameter on the CLI.
    :description "Name to greet"
    :short-name #\n
    :long-name "name"
    :env-vars '("USER")     ;; <-- takes this default value if the env var exists.
    :initial-value "lisper" ;; <-- default value if nothing else is set.
    :key :name)))

(defun cli/command ()
  "A command to say hello to someone"
  (clingon:make-command
   :name "hello"
   :description "say hello"
   :version "0.0.0"
   :authors '("John Doe <john.doe@example.org")
   :license "BSD 2-Clause"
   :options (cli/options) ;; <-- our options
   :handler #'cli/handler))  ;; <--  to change. See below.

(defun cli/handler (cmd)
  "The handler function of our top-level command"
  (let ((free-args (clingon:command-arguments cmd))
        (name (clingon:getopt cmd :name)))  ;; <-- using the option's :key
    (format t "Hello, ~a!~%" name)
    (format t "You have provided ~a more free arguments~%" (length free-args))
    (format t "Bye!~%")))

(defun main ()
  "Entry point for the executable.
  Reads command line arguments."
  ;; uiop:command-line-arguments returns a list of arguments (sans the script name).
  ;; We defer the work of parsing to %main because we call it also from the Roswell script.
  (clingon:run (cli/command)))
