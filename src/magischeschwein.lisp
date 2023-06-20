(in-package :magischeschwein)

(defparameter *ledger-cli-date-format*
  '((:year 4) #\/ (:month 2) #\/ (:day 2)))

(defparameter *todays-date*
  (local-time:format-timestring nil
    (local-time:now)
    :format *ledger-cli-date-format*))

(defun test-launch ()
   (uiop:launch-program
     (list
       "ledger"
       "convert"
       "/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/example-output-file.csv"
       "--input-date-format"
       "%m/%d/%Y"
       "--invert"
       "--account"
       "assets:checking"
       "--rich-data"
       "--file"
       "/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/example-journal.dat"
       "--now=2023/06/20")
     :output *standard-output*))

(defun top-level/handler (cmd)
  (let ((input-file   (clingon:getopt cmd :input-file))
        (journal-file (clingon:getopt cmd :journal-file))
        (account-name (clingon:getopt cmd :account-name))
        (verbose      (clingon:getopt cmd :verbose)))
    (uiop:launch-program
      (list
        "ledger"
        "convert"
        (format nil "~a" input-file)
        "--input-date-format"
        "%m/%d/%Y"
        "--invert"
        "--account"
        (format nil "~a" account-name)
        "--rich-data"
        "--file"
        (format nil "~a" journal-file)
        (format nil "--now=~a" *todays-date*)))))

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
     :description "your pre-existing ledger journal file"
     :short-name #\j
     :long-name "journal-file"
     :key :journal-file)
   (clingon:make-option
     :string
     :description "name of primary checking account in ledger"
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

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "FIXME"
    :options (top-level/options)
    :handler #'top-level/handler))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
