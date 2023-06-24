(in-package :asdf-user)

(defsystem "magischeschwein-tests"
  :description "Test suite for the magischeschwein system"
  :author "Chu the Pup <chufilthymutt@gmail.com>"
  :version "0.0.1"
  :depends-on (:magischeschwein
               :fiveam
               :cl-csv
               :clingon)
  :license "GNU GPL-3.0"
  :serial T
  :components ((:module "tests"
                        :serial T
                        :components ((:file "packages")
                                     (:file "test-magischeschwein")))))

  ;; The following would not return the right exit code on error, but still 0.
  ;; :perform (test-op (op _) (symbol-call :fiveam :run-all-tests))
  
