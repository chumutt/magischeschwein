(in-package :magischeschwein)

;; Testing start

(defparameter *test-pathname* '("../tests/example-input-file.csv"))
(defparameter *test-output-pathname* '("../tests/example-output-file.csv"))

(defun test ()
  (commence-with *test-pathname*))

(defun barf-csv-test (pathname)
  (with-open-file (file (car pathname)
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)
    (write-sequence (test) file)))

;; Testing end

;; Define your project functionality here...

(defparameter *new-headers* '("date,payee,note,debit,credit,,code,"))

(defun slurp-pathname (pathname)
  (with-open-file (str (car pathname)
                       :direction :input)
    (cl-csv:read-csv str)))


(defun put-new-headers (seq)
  (cons *new-headers* seq))

(defun remove-first-column (seq)
  (mapcar #'cdr seq))

(defun remove-first-row (seq)
  (cddddr seq))

(defun commence-with (argv)
  (put-new-headers
   (remove-first-column
    (remove-first-row
     (remove-first-row
      (slurp-pathname argv))))))

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
