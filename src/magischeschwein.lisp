(in-package :magischeschwein)

(defparameter *ledger-cli-date-format*
  '((:year 4) #\/ (:month 2) #\/ (:day 2)))

(defparameter *todays-date*
  (local-time:format-timestring nil
    (local-time:now)
    :format *ledger-cli-date-format*))

(defparameter *new-headers*
  '("date,payee,note,debit,credit,,code,"))

(defun top-level/options ()
  (list
    (clingon:make-option
       :filepath
       :description
      "the input csv file you want to convert"
       :short-name #\i
       :long-name "input-file"
       :key :input-file)
    (clingon:make-option
      :filepath
      :description
      "your pre-existing ledger journal file"
      :short-name #\j
      :long-name "journal-file"
      :key :journal-file)
    (clingon:make-option
      :string
      :description
      "name of primary checking account in ledger"
      :short-name #\a
      :long-name "account-name"
      :initial-value "assets:checking"
      :key :account-name)
    (clingon:make-option
      :counter
      :description "verbosity level"
      :short-name #\v
      :long-name "verbose"
      :key :verbose)))

(defun top-level/handler (cmd)
  (let ((input-file   (clingon:getopt cmd :input-file))
        (journal-file (clingon:getopt cmd :journal-file))
        (account-name (clingon:getopt cmd :account-name))
        (verbosity    (clingon:getopt cmd :verbose)))
    (let* ((input-pathname (pathname input-file))
           (input-csv (cl-csv:read-csv input-pathname))
           (csv-sans-headers (cddddr input-csv))
           (csv-sans-1st-col (mapcar #'cdr csv-sans-headers))
           (csv-with-new-headers (cons *new-headers* csv-sans-1st-col)))
      (cl-csv:write-csv
        (cl-csv:read-csv
          (cl-csv:write-csv csv-with-new-headers))
        :stream #P"/tmp/magischeschwein.tmp"))))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-v] [-i <input-file.csv>] [-j <your-journal.dat>]"
    :options (top-level/options)
    :handler #'top-level/handler))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
