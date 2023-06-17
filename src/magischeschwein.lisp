(in-package :magischeschwein)

(defparameter *date-format*
  '((:month 2) #\/ (:day 2) #\/ (:year 4)))

(defparameter *new-headers* "date,payee,note,debit,credit,,code,")

(defparameter *todays-date* (local-time:format-timestring nil (local-time:now)
                              :format *date-format*))

(defun ledger-convert (csvin csvout)
  (let ((args (cons
                (cons '("ledger" "convert") csvin)
                (cons '("--input-date-format "%m/%d/%Y""
                        "--invert"
                        "--account" "assets:checking"
                        "--rich-data"
                        "--file")
                  (cons csvout
                    (uiop:strcat "--now" *todays-date*))))))
    (format T "~A" args)))

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

(defun top-level/handler (cmd)
  (let ((input-file (clingon:getopt cmd :input-file))
        (output-file (clingon:getopt cmd :output-file)))
    (let* ((input-table (mapcar #'cdr (cddddr (cl-csv:read-csv input-file))))
           (output-table (cons *new-headers* input-table)))
      (ledger-convert output-table output-file))))

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
