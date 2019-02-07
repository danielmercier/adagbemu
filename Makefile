all: native

native:
	gprbuild -P gbemu -Xbackend=pure_sdl

test: native
	./tools/run-tests

clean:
	gprclean -P gbemu
