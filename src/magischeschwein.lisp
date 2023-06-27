(in-package :magischeschwein)

(defparameter *ledger-cli-date-format*
  '((:year 4) #\/ (:month 2) #\/ (:day 2)))

(defparameter *todays-date*
  (local-time:format-timestring nil
    (local-time:now)
    :format *ledger-cli-date-format*))

(defparameter *new-headers*
  "date,payee,note,debit,credit,,code,")

(defparameter *temporary-headers-filename*
  "magischeschwein-headers.tmp")

(defun temp-filename (filename)
  (uiop:merge-pathnames* filename (uiop:temporary-directory)))

(defparameter *temporary-headers-filepath*
  (temp-filename *temporary-headers-filename*))

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
      :key :verbose
      :initial-value 0)))

(defun is-file-real? (filepath)
  (if (uiop:file-exists-p filepath)
    "YES"
    "NO"))

(defun be-verbose-about (input-file journal-file account-name verbosity)
  (format T "input-file: ~a~%journal-file: ~a~%account-name: ~a~%verbosity: ~a~%"
    input-file
    journal-file
    account-name
    verbosity)
  (format T "input-file real?: ~a~%" (is-file-real? input-file)))


(defun write-new-headers-to (stream)
  (format stream "~a" *new-headers*))

(defun write-headers-to-temp-file ()
  (with-open-file (s *temporary-headers-filepath*
                    :direction :output
                    :if-exists :supersede
                    :if-does-not-exist :create)
    (write-new-headers-to s)))

(defun top-level/handler (cmd)
  (let ((input-file   (clingon:getopt cmd :input-file))
        (journal-file (clingon:getopt cmd :journal-file))
        (account-name (clingon:getopt cmd :account-name))
        (verbosity    (clingon:getopt cmd :verbose)))
    (when (= verbosity 1)
      (be-verbose-about input-file journal-file account-name verbosity))
    (write-headers-to-temp-file)))

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
