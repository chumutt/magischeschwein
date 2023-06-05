(in-package :magischeschwein)

;; Define your project functionality here...

(defparameter *new-headers* '("date,payee,account,amount,currency,description"))

(defun test-read-in-pathname ()
  (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/example-input-file.csv"))

(defun remove-last-strings ()
  (mapcar #'butlast
          (mapcar #'butlast
                  (mapcar #'butlast (remove-first-string-over-list)))))

(defun remove-first-string-over-list ()
  (mapcar #'cdr (grab-sans-headers)))

(defun grab-sans-headers ()
  (cddddr (test-read-in-pathname)))

(defun put-new-headers ()
  (cons *new-headers* (grab-sans-headers)))

(defun slurp-pathname (pathname)
  (uiop:read-file-lines (merge-pathnames (car pathname) (uiop/os:getcwd))))

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
  (slurp-pathname argv)
  (uiop:quit))

(defun main ()
  "Entry point for the executable.
  Reads command line arguments."
  ;; uiop:command-line-arguments returns a list of arguments (sans the script name).
  ;; We defer the work of parsing to %main because we call it also from the Roswell script.
  (%main (uiop:command-line-arguments)))
