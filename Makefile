all: native

native:
	alr build

test: native
	./tools/run-tests

clean:
	alr clean
