
(load "magischeschwein.asd")
(load "magischeschwein-tests.asd")

(ql:quickload "magischeschwein-tests")

(in-package :magischeschwein-tests)

(uiop:quit (if (run-all-tests) 0 1))
