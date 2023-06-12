(in-package :magischeschwein-tests)

;; Define your project tests here...

(def-suite testmain
    :description "test suite 1")

(in-suite testmain)

(test test1
  (is (= (+ 1 1)
         2)))

(test test2
  (is (equal (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/example-output-file.csv")
             (cl-csv:read-csv #P"/home/chu/.local/share/roswell/local-projects/chus/magischeschwein/tests/correct-output-file.csv"))))
