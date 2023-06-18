(in-package :magischeschwein)

(defparameter *date-format*
  '((:month 2) #\/ (:day 2) #\/ (:year 4)))

(defparameter *todays-date* (local-time:format-timestring nil (local-time:now) :format *date-format*))

(defparameter *new-headers* '("date,payee,note,debit,credit,,code,"))

(defun top-level/options ()
  (list
   (clingon:make-option
    :filepath
    :description "the input csv file you want to convert"
    :short-name #\i
    :long-name "input-file"
    :key :input-file)
   (clingon:make-option
    :filepath
    :description "where you want to save the converted csv"
    :short-name #\o
    :long-name "output-file"
    :key :output-file)))

(defun with-new-headers (lst)
  (cons *new-headers* lst))

(defun read-csv-string-from-file (file)
  (cl-csv:read-csv (uiop:read-file-string file)))

(defun strip-headers-and-1st-col (lst)
  (mapcar #'cdr (cddddr lst)))

(defun process-csv (file)
  (with-new-headers (strip-headers-and-1st-col (read-csv-string-from-file file))))

(defun top-level/handler (cmd)
  (let ((input-file (clingon:getopt cmd :input-file))
        (output-file (clingon:getopt cmd :output-file)))
    (process-csv input-file)))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-h] [-i <INPUT-FILE>] [-o <OUTPUT-LOCATION>]"
    :options (top-level/options)
    :handler #'top-level/handler))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
