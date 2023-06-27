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
  "magischeschwein-csv-headers.tmp")

(defparameter *temporary-csv-filename*
  "magischeschwein-csv-body.tmp")

(defparameter *temporary-filename*
  "magischeschwein.tmp")

(defun temp-filename (filename)
  (uiop:merge-pathnames* filename
    (uiop:temporary-directory)))

(defparameter *temporary-headers-filepath*
  (temp-filename *temporary-headers-filename*))

(defparameter *temporary-csv-filepath*
  (temp-filename *temporary-csv-filename*))

(defparameter *temporary-file-filepath*
  (temp-filename *temporary-filename*))

(defparameter *temporary-file-filepath-string*
  (uiop:native-namestring (temp-filename *temporary-filename*)))

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

(defun convert-input-csv (input-file)
  (cl-csv:write-csv
    (cddddr
      (mapcar 'cdr
        (cl-csv:read-csv input-file)))))

(defun write-converted-input-csv-to (stream input-file)
  (format stream "~a" (convert-input-csv (pathname input-file))))

(defun write-converted-input-csv-to-temp-file (input-file)
  (with-open-file (s *temporary-csv-filepath*
                    :direction :output
                    :if-exists :supersede
                    :if-does-not-exist :create)
    (write-converted-input-csv-to s input-file)))

(defun read-csv-headers ()
  (cl-csv:read-csv *temporary-headers-filepath*))

(defun read-converted-csv-body ()
  (cl-csv:read-csv *temporary-csv-filepath*))

(defun combine-headers-and-csv ()
  (cons
    (car (read-csv-headers))
    (read-converted-csv-body)))

(defun write-combined-headers-and-csv (stream)
  (cl-csv:write-csv
    (combine-headers-and-csv)
    :stream stream))

(defun write-combined-headers-and-csv-to-temp-file ()
  (with-open-file (s *temporary-file-filepath*
                    :direction :output
                    :if-exists :supersede
                    :if-does-not-exist :create)
    (write-combined-headers-and-csv s)))

(defun ledger (journal-file account-name)
  (uiop:run-program (list
                      "ledger"
                      "convert"
                      *temporary-file-filepath-string*
                      "-f"
                      journal-file
                      "--input-date-format"
                      "%m/%d/%Y"
                      "--invert"
                      "--account"
                      account-name
                      "--rich-data"
                      "--now"
                      *todays-date*)
    :output :string
    :error-output :string))


(defun write-temp-files (input-file)
  (write-headers-to-temp-file)
  (write-converted-input-csv-to-temp-file input-file)
  (write-combined-headers-and-csv-to-temp-file))

(defun cleanup-temp-files ()
  (uiop:delete-file-if-exists *temporary-headers-filepath*)
  (uiop:delete-file-if-exists *temporary-csv-filepath*)
  (uiop:delete-file-if-exists *temporary-file-filepath*))

(defun top-level/handler (cmd)
  (let ((input-file   (clingon:getopt cmd :input-file))
        (journal-file (clingon:getopt cmd :journal-file))
        (account-name (clingon:getopt cmd :account-name))
        (verbosity    (clingon:getopt cmd :verbose)))
    (when (= verbosity 1)
      (be-verbose-about
        input-file
        journal-file
        account-name
        verbosity))
    (write-temp-files input-file)
    (princ
      (ledger journal-file account-name))
    (cleanup-temp-files)))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-i <input-file.csv>] [-j <your-journal.dat>] [-a \"account:name\"] [-v] [--help]"
    :options (top-level/options)
    :handler #'top-level/handler))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
