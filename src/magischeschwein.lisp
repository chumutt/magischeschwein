(in-package :magischeschwein)

(defparameter *temporary-file* #P"/tmp/magischeschwein.tmp")

(defparameter *date-format*
  '((:month 2) #\/ (:day 2) #\/ (:year 4)))

(defparameter *todays-date* (local-time:format-timestring nil (local-time:now) :format *date-format*))

(defparameter *new-headers* '("date,payee,note,debit,credit,,code,"))

(defparameter *ledger-cli-args* '("ledger"
                                   "convert"
                                   "/tmp/magischeschwein.tmp"
                                   "--input-date-format"
                                   "%m/%d/%Y"
                                   "--invert"
                                   "--account"
                                   "assets:checking"
                                   "--rich-data"
                                   "--now"
                                   NIL))

(defun replace-at-index (lst index new-value)
  (if (zerop index)
    (cons new-value (cdr lst))
    (cons (car lst)
      (replace-at-index (cdr lst) (1- index) new-value))))

(defun csvin-to-cli-args (lst csvin)
  (replace-at-index lst 2 (uiop:native-namestring csvin)))

(defun current-date-to-cli-args (lst datespec)
  (replace-at-index lst 10 datespec))

(defun with-cli-args (csvin)
  (let ((lst1 (csvin-to-cli-args *ledger-cli-args* (uiop:native-namestring csvin))))
    (let ((lst2 (current-date-to-cli-args lst1 *todays-date*)))
      lst2)))

(defun ledger-convert (csvin)
  (uiop:run-program (with-cli-args csvin) :output T))

(defun with-new-headers (lst)
  (cons *new-headers* lst))

(defun read-csv-string-from-file (file)
  (cl-csv:read-csv (uiop:read-file-string file)))

(defun strip-headers-and-1st-col (lst)
  (mapcar #'cdr (cddddr lst)))

(defun process-csv (file)
  (with-new-headers (strip-headers-and-1st-col (read-csv-string-from-file file))))

(defun top-level/handler (cmd)
  (let ((input-file (clingon:getopt cmd :input-file)))
    (prog2
      (cl-csv:write-csv (process-csv input-file) :stream *temporary-file*)
      (ledger-convert *temporary-file*))))

(defun top-level/options ()
  (list
   (clingon:make-option
    :filepath
    :description "the input csv file you want to convert"
    :short-name #\i
    :long-name "input-file"
    :key :input-file)))

(defun top-level/command ()
  (clingon:make-command
    :name "magischeschwein"
    :description "csv to ledger converter for first farmers and merchants bank"
    :version "0.0.1"
    :license "GNU GPL-3.0"
    :authors '("Chu the Pup <chufilthymutt@gmail.com>")
    :usage "[-h] [-i <INPUT-FILE>]"
    :options (top-level/options)
    :handler #'top-level/handler))

(defun main ()
  (let ((app (top-level/command)))
    (clingon:run app)))
