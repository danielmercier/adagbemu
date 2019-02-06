all: native

native:
	gprbuild -P gbemu -Xbackend=pure_sdl

clean:
	gprclean -P gbemu
