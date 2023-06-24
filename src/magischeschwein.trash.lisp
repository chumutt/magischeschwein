    (when (= 1 verbosity)
      (format T "input-file: ~s~%" input-file)
      (format T "journal-file: ~s~%" journal-file)
      (format T "account-name: ~s~%" account-name)
      (format T "verbosity: ~s~%" verbosity)
      (format T "input-file contents:~%~s~%"
        (cl-csv:read-csv
          (pathname input-file)))
      (format T "output list to be written:~%~s~%"
        (cons *new-headers*
          (mapcar #'cdr
            (cddddr
              (cl-csv:read-csv
                (pathname input-file))))))
      (format T "output csv to be written: ~%~s"
        (cl-csv:write-csv
          (cons *new-headers*
            (mapcar #'cdr
              (cddddr
                (cl-csv:read-csv
                  (pathname input-file))))))))
    (cl-csv:write-csv
      (cons *new-headers*
        (mapcar #'cdr
          (cddddr
            (cl-csv:read-csv (pathname input-file)))))
      :stream #P"/tmp/magischeschwein.tmp")

(defparameter *new-headers* '("date,payee,note,debit,credit,,code,"))

(defparameter *ledger-cli-date-format*
  '((:year 4) #\/ (:month 2) #\/ (:day 2)))

(defparameter *todays-date*
  (local-time:format-timestring nil
    (local-time:now)
    :format *ledger-cli-date-format*))

(defparameter *temporary-file* "magischeschwein.tmp")

(defparameter *temporary-file-and-dir*
  (uiop:merge-pathnames*
    uiop:*temporary-directory*
    *temporary-file*))

(defun top-level/handler (cmd)
  (let ((input-file   (clingon:getopt cmd :input-file))
        (journal-file (clingon:getopt cmd :journal-file))
        (account-name (clingon:getopt cmd :account-name))
        (verbose      (clingon:getopt cmd :verbose)))
    (with-open-file (s *temporary-file-and-dir*
                      :direction :output
                      :if-exists :overwrite
                      :if-does-not-exist :create)
      (format s "~a"
        (cl-csv:write-csv
          (cons *new-headers*
            (mapcar #'cdr
              (cddddr
                (cl-csv:read-csv
                  (uiop:read-file-string input-file)))))))
      (uiop:launch-program
        (list
          "ledger"
          "convert"
          (format nil "~a" *temporary-file-and-dir*)
          "--input-date-format"
          "%m/%d/%Y"
          "--invert"
          "--account"
          (format nil "~a" account-name)
          "--rich-data"
          "--file"
          (format nil "~a" journal-file)
          (format nil "--now=~a" *todays-date*))
        :output *standard-output*
        :error-output *standard-output*))))

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

(defparameter *new-headers* '("date,payee,note,debit,credit,,code,"))

(defparameter *ledger-cli-date-format*
  '((:year 4) #\/ (:month 2) #\/ (:day 2)))

(defparameter *todays-date*
  (local-time:format-timestring nil
    (local-time:now)
    :format *ledger-cli-date-format*))

(defparameter *temporary-file* "magischeschwein.tmp")

(defparameter *temporary-file-and-dir*
  (uiop:merge-pathnames*
    uiop:*temporary-directory*
    *temporary-file*))

(defun top-level/handler (cmd)
  (let ((input-file   (clingon:getopt cmd :input-file))
        (journal-file (clingon:getopt cmd :journal-file))
        (account-name (clingon:getopt cmd :account-name))
        (verbose      (clingon:getopt cmd :verbose)))
    (with-open-file (s *temporary-file-and-dir*
                      :direction :output
                      :if-exists :overwrite
                      :if-does-not-exist :create)
      (format s "~a"
        (cl-csv:write-csv
          (cons *new-headers*
            (mapcar #'cdr
              (cddddr
                (cl-csv:read-csv
                  (uiop:read-file-string input-file)))))))
      (uiop:launch-program
        (list
          "ledger"
          "convert"
          (format nil "~a" *temporary-file-and-dir*)
          "--input-date-format"
          "%m/%d/%Y"
          "--invert"
          "--account"
          (format nil "~a" account-name)
          "--rich-data"
          "--file"
          (format nil "~a" journal-file)
          (format nil "--now=~a" *todays-date*))
        :output *standard-output*
        :error-output *standard-output*))))

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

(defparameter *temporary-file* #P"/tmp/magischeschwein.tmp")

(defparameter *date-format*
  '((:month 2) #\/ (:day 2) #\/ (:year 4)))

(defparameter *todays-date* (local-time:format-timestring nil (local-time:now) :format *date-format*))

(defparameter *new-headers* '("date,payee,note,debit,credit,,code,"))

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

(defun put-new-headers (lst)
  (cons *new-headers* lst))

(defun read-csv-string-from-file (file)
  (cl-csv:read-csv (uiop:read-file-string file)))

(defun strip-headers-and-1st-col (lst)
  (mapcar #'cdr (cddddr lst)))

(defun process-csv (file)
  (put-new-headers (strip-headers-and-1st-col (read-csv-string-from-file file))))

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

(defparameter *ledger-cli-args* '("ledger"
                                   "convert"
                                   'NIL
                                   "--input-date-format"
                                   "\"%m/%d/%Y\" "
                                   "--invert"
                                   "--account"
                                   "assets:checking"
                                   "--rich-data"
                                   "--now"
                                   'NIL))

(defun ledger-convert (csvin csvout)
  (let ((args (cons
                (cons '("ledger" "convert") csvin)
                (cons '("--input-date-format "%m/%d/%Y""
                        "--invert"
                        "--account " "assets:checking"
                        "--rich-data"
                        "--file")
                  (cons csvout
                    (uiop:strcat "--now " *todays-date*))))))
    (uiop:run-program args)

    (let* ((input-table (mapcar #'cdr (cddddr (cl-csv:read-csv input-file))))
           (output-table (cons *new-headers* input-table)))
      (ledger-convert output-table output-file))

    (top-level/verbose args verbose input-file output-file)
    (top-level/convert input-file output-file)

   (clingon:make-option
    :counter
    :description "verbosity level"
    :short-name #\v
    :long-name "verbose"
    :initial-value 0
    :key :verbose)))

(defun top-level/verbose (&optional args verbose input-file output-file)
  (when (> verbose 0)
    (format T "The current verbosity level is set to ~A~%" verbose)
    (format T "You have provided ~A arguments~%" (length args))
    (format T "Input file: ~A!~%" input-file)
    (format T "Output file location: ~A!~%" output-file)))

(defun there-is-an-input-file-p (input-file)
  (if (uiop:file-exists-p input-file)
    T
    NIL))

(defun there-is-an-output-file-p (output-file)
  (if (uiop:file-exists-p output-file)
    T
    NIL

    (when (> verbose 0)
      (format T "The current verbosity level is set to ~A~%" verbose)
      (format T "You have provided ~A arguments~%" (length args))
      (format T "Input file: ~A!~%" input-file)
      (format T "Output file location: ~A!~%" output-file))))

(defun there-is-an-input-file-p (input-file)
  (if (uiop:file-exists-p input-file)
    T
    NIL))

(defun there-is-an-output-file-p (output-file)
  (if (uiop:file-exists-p output-file)
    T
    NIL))

(defun test-input-file-tester (input-file)
  (if (uiop:file-exists-p input-file)
    (format T "~A~%" (uiop:merge-pathnames* input-file (uiop/os:getcwd)))
    (format T "no file was inputted")))

(defun test-output-file-tester (output-file)
  (if (uiop:file-exists-p output-file)
    (format T "~A~%" (uiop:merge-pathnames* output-file (uiop/os:getcwd)))
    (format T "no location was specified for output file (and that's okay.)")))

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

;; $ ledger convert download.csv --input-date-format "%m/%d/%Y" \
;;   --invert --account Assets:MyBank --rich-data \
;;   --file sample.dat --now=2012/01/13

(defun ledger-convert (csvin csvout)
  (uiop:run-program '("ledger"
                       "convert"
                       csvin
                       "--input-date-format "%m/%d/%Y""
                       "--invert"
                       "--account" "Assets:MyBank"
                       "--rich-data"
                       "--file" csvout
                       (concatenate :string "--now=" *todays-date*))))

(defparameter *output-table*
  (cons *input-headers* *input-table*)
  "Contains the result of combining the new *input-headers* with *input-table*
(the latter having its original headers removed).")

(defun barf-test ()
  (cl-csv:write-csv *output-table* :stream #P"../tests/example-output-file.csv"))

(defparameter *input-table*
  (mapcar #'cdr (cddddr (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/example-input-file.csv")))
  "Contains the original table (the csv file to be inputted) in list form with
the original header rows removed and the first column of values (transaction ids) removed as well.")

(defparameter *input-headers* (car (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/headers.csv"))
  "Contains the new (ledger-cli compatible) headers.")
