(in-package :magischeschwein-tests)

;; Define your project tests here...

(defun truepathname (filename)
  (uiop:native-namestring
    (uiop:merge-pathnames*
      (asdf:system-relative-pathname
        "magischeschwein"
        filename))))

(defparameter *app* (magischeschwein::top-level/command))

(defparameter *test-input-file-filepath-string*
  "../res/example-input-file.csv")

(defparameter *test-input-full-filepath*
  (truepathname *test-input-file-filepath-string*))

(defparameter *test-journal-file-filepath-string*
  "../res/example-journal-file.dat")

(defparameter *test-journal-full-filepath*
  (truepathname *test-journal-file-filepath-string*))

(defun test-print-usage ()
  (clingon:print-usage *app* T))

(defun pcl (largs)
  (clingon:parse-command-line *app* largs))

(defun rcl (largs)
  (clingon:run *app* largs))

(defun test-parse-command-line-no-args ()
  (pcl nil))

(defun test-run-command-line-no-args ()
  (rcl nil))

(defun test-parse-command-line-long-help ()
  (pcl (list "--help")))

(defun test-run-command-line-long-help ()
  (rcl (list "--help")))

(defun test-parse-command-line-short-help ()
  (pcl (list "-h")))

(defun test-run-command-line-short-help ()
  (rcl (list "-h")))

(defun test-parse-command-line-verbose-only ()
  (pcl (list "-v")))

(defun test-run-command-line-verbose-only ()
  (rcl (list "-v")))

(defun test-parse-command-line-input-file-journal-file-and-verbose ()
  (pcl (list
         "-v"
         "-i"
         *test-input-file-filepath-string*
         "-j"
         *test-journal-file-filepath-string*)))

(defun test-run-command-line-input-file-journal-file-and-verbose ()
  (rcl (list
         "-v"
         "-i"
         *test-input-file-filepath-string*
         "-j"
         *test-journal-file-filepath-string*)))

(def-suite testmain
    :description "test suite 1")

(in-suite testmain)

(test test1
  (is (= (+ 1 1)
         2)))
