test:
	shellspec
.PHONY: test

test-watch:
	while :; do inotifywait -e modify,close_write,move $$(fd .sh); shellspec; done
.PHONY: test-watch
