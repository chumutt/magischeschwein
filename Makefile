LISP ?= ros -Q run

run:
	rlwrap $(LISP) --load run.lisp

build:
	$(LISP)	--non-interactive \
		--load magischeschwein.asd \
		--eval '(ql:quickload :magischeschwein)' \
		--eval '(asdf:make :magischeschwein)'
