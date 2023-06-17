(in-package :magischeschwein)

(defun top-level/options ()
  "Creates and returns the options for the top-level command"
  (list
   (clingon:make-option
    :counter
    :description "verbosity level"
    :short-name #\v
    :long-name "verbose"
    :initial-value 0
    :key :verbose)
   (clingon:make-option
    :filepath
    :description "the input csv file you want to convert"
    :short-name #\i
    :long-name "input-file"
    :initial-value NIL
    :key :input-file)
   (clingon:make-option
    :filepath
    :description "where you want to save the converted csv"
    :short-name #\o
    :long-name "output-file"
    :initial-value NIL
    :key :output-file)))

(defun top-level/verbose (&optional args verbose input-file output-file)
  (when (> verbose 0)
    (format T "The current verbosity level is set to ~A~%" verbose)
    (format T "You have provided ~A arguments~%" (length args))
    (format T "Input file: ~A!~%" input-file)
    (format T "Output file location: ~A!~%" output-file)))

(defun top-level/handler (cmd)
  (let ((args (clingon:command-arguments cmd))
        (input-file (clingon:getopt cmd :input-file))
        (output-file (clingon:getopt cmd :output-file))
        (verbose (clingon:getopt cmd :verbose)))
    (top-level/verbose args verbose input-file output-file)))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-h] [-v] [-i <INPUT-FILE>] [-o <OUTPUT-LOCATION>]"
    :options (top-level/options)
    :handler #'top-level/handler))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
