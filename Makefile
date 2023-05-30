LISP ?= sbcl

all: test

run:
	rlwrap $(LISP) --load run.lisp

build:
	$(LISP)	--non-interactive \
		--load magischeschwein.asd \
		--eval '(ql:quickload :magischeschwein)' \
		--eval '(asdf:make :magischeschwein)'

test:
	$(LISP) --non-interactive \
		--load run-tests.lisp
