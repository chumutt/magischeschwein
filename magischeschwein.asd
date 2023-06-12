(in-package :asdf-user)

(defsystem "magischeschwein"
  :author "Chu the Pup <chufilthymutt@gmail.com>"
  :version "0.0.1"
  :license "GNU GPL-3.0"
  :description "csv to ledger converter for first farmers and merchants bank"
  :homepage ""
  :bug-tracker ""
  :source-control (:git "")

  ;; Dependencies.
  :depends-on (:cl-csv)

  ;; Project stucture.
  :serial T
  :components ((:module "src"
                        :serial T
                        :components ((:file "packages")
                                     (:file "magischeschwein"))))

  ;; Build a binary:
  ;; don't change this line.
  :build-operation "program-op"
  ;; binary name: adapt.
  :build-pathname "magischeschwein"
  ;; entry point: here "main" is an exported symbol. Otherwise, use a double ::
  :entry-point "magischeschwein:main")
