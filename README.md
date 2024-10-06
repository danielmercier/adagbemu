# AdaGBEmu

Gameboy emulator written in Ada.

## SDL2

Make sure you have SDL2 >= 2.0.22 if you're using a recent version of sdlada

## Building

You can build the project using alire

```sh
$ alr build
```

## State

Neither the CPU nor the GPU are finished for now. Tasks for both of them do
not exist yet. Some notes on the design, and things to be done:

tasks:
 - CPU task
 - GPU task
 - Main task

clock waiters:
 - one for the gpu
 - one for the cpu
 - Will_Wait sets clock to the given amount
 - Wait waits until clock is zero
 - Decrement instead of Increment (do not decrement lower than 0)

Main task:
 - SDL rendering
 - Increment each clock waiters
