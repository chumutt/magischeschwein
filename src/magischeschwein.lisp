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

(defun top-level/handler (cmd)
  (let ((args (clingon:command-arguments cmd))
        (input-file (clingon:getopt cmd :input-file))
        (output-file (clingon:getopt cmd :output-file))
        (verbose (clingon:getopt cmd :verbose)))
    (when (> verbose 0)
      (format T "The current verbosity level is set to ~A~%" verbose)
      (format T "You have provided ~A arguments~%" (length args))
      (format T "Input file: ~A!~%" input-file)
      (format T "Output file location: ~A!~%" output-file))
    (if (uiop:file-exists-p input-file)
      (format T (uiop:merge-pathnames* input-file (uiop/os:getcwd)))
      (format T "no file was inputted"))))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-v] [-i <INPUT-FILE>] [-o <OUTPUT-LOCATION>]"
    :options (top-level/options)
    :handler #'top-level/handler))

(defparameter *app* (top-level/command))

(defun test-cmd-no-opts ()
  (clingon:parse-command-line *app* nil))

(defun test-cmd-verbose-w-no-opts ()
  (clingon:parse-command-line *app* '("-v")))

(defparameter *test-dir*
  (asdf:system-relative-pathname "magischeschwein" "tests/"))

(defparameter *test-input-file*
  (uiop:native-namestring
    (uiop:merge-pathnames* "example-input-file.csv" *test-dir*)))

(defparameter *test-output-file*
  (uiop:native-namestring
    (uiop:merge-pathnames* "example-output-file.csv" *test-dir*)))

(defun test-cmd-input-file-only ()
  (clingon:parse-command-line *app* '("-i" *test-input-file*)))

(defun test-whatis-input-file ()
  (let ((c (test-cmd-input-file-only)))
    (clingon:getopt c :input-file)))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
