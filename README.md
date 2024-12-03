# AdaGBEmu

Gameboy emulator written in Ada.

## SDL2

Make sure you have SDL2 >= 2.0.22 if you're using a recent version of sdlada

## Building

You can build the project using alire

```sh
$ alr build
```

## Testing CPU without Video

Uses the github project gbit for testing cpu instructions

```sh
$ alr exec -- gprbuild -P test_instrs/test.gpr
```

Then run the test_adagbemu binary to see if all tests passes

## State

Simple cartridge are supported and some games already work. Remaining work:
 - Emulation of sound
 - Implement more cartridge
 - Bugfix on existing cartridge (MB5 doesn't seem to work properly)
