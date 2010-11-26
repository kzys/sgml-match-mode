test: FORCE
	for i in test/*.el; do emacs --batch -q -L lisp -l $$i; done

FORCE:
