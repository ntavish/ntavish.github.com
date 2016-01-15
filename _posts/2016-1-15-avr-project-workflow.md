---
published: true
layout: post
title: avr project workflow
category: blog
---

When I start working on a microcontroller project, there are some basic things that 
are nice to haves. Basic things like a serial port for debug messages, a continuously
running timer for getting time difference between two points of time(for things like
timeout; or delays). Then most of the time, you need SPI, or I2C, or some other 
peripheral.

Unless you have been using the same platform for some time and have your own personal
stash of code snippets to do this, (and unless you wrote then well enough to be
reusable with other projects, might still need some work to make it work too) you'll
be doing the same things again and it takes time before you get to do the thing you 
wanted to do.

Although C++ is not my prferred language for writing code for microcontrollers, I
write much of AVR code in C++(except 'modules' deliberately written in .c/.h files to 
make them reusable in other c projects), just to be able to use arduino libraries. 
This post is to explain the arduino code/libraries build process in some detail and 
adapting it to one's favourite tools.

Having used a simple makefile based compilation system which replicated the arduino 
compilation steps(which I made a long time ago for an internship), I was looking for 
something a bit more robust and configurable. Found [Inotool](http://inotool.org) 
randmonly and this was exactly what I wanted. Usage is simple, create a file ino.ino to 
specify configuration(board, serial port, baud etc.). 

A sample config file could be like:

	[build]
	board-model = yourcustomboard

	[upload]
	board-model = yourcustomboard
	serial-port = usb

(The setting `serial-port = usb` in the above is not standard)

Usage is simple, write your code in src/, add any libraries(arduino compatible format
so that the build system can find it), write config in ino.ini, and:

	ino build
	ino upload
	(also) ino clean

The overall stucture is then like:

	code/
	    |--ino.ini
	    |
	    |--src/
	    |     |--sketch.ino     (arduino style c++/wiring code)
	    |     |--file1.cpp
	    |     |--file1.h
	    |     |--file2.c
	    |     |--file2.h
	    |
	    |--lib/
	          |--ArduinoLib/    (arduino style library)

Ino seems to be unmaintained now, but it works fine with arduino1.0.6(1.5.x and later
ones should work too, but I haven't tried), which ships with avr-gcc 4.3.2. It was only
missing a way to program devices via a programmer instead of using the serial bootloader.
I sent a pull request which enables use of usb programmers from the config, you can
checkout my version from https://github.com/ntavish/ino/ branch patch-1(unmerged), make
sure to checkout this branch.

In the config example above, there is the name `yourcustomboard`, which could have been
one of the board names listed inside the file `/usr/local/share/arduino/hardware/arduino/boards.txt`, 
for example:

	uno
	atmega328
	diecimila
	mega2560
	mega
	leonardo
	...

To make our own custom board available in this list, first create a 'profile' for your own board
in any location. The structure for the files in this is:

	yourcustomboard/
	|
	|---boards.txt
	|---variants/
	            |
	            |--standard/
	                       |--pins_arduino.h

(Note: you might need to copy the directory `cores/` from `/usr/local/share/arduino/hardware/arduino/cores/` 
as `yourcustomboard/cores/`)

The file `pins_arduino.h` is pretty self-explanatory, it is the utility header defined for all supported 
boards by arduino IDE so that you can write have straight numbers in `digitalRead/Write` etc. instead of
actual MCU pin port/numbers, `A0/A1/A2/..`, `SS/MOSI/MISO`, `SDA/SCL`, and utility macros like 
`digitalPinToPCICR/digitalPinToPCICRbit/..` etc. Customising this you can map pins to your 
preference/circuit.

A sample custom `boards.txt` file for a custom board, set for programming with a usb programmer is:

	##############################################################

	yourcustomboard.name=Your custom board (ATmega1280) 14.745MHz

	yourcustomboard.upload.protocol=usbasp
	yourcustomboard.upload.maximum_size=126976
	yourcustomboard.upload.speed=57600

	yourcustomboard.bootloader.low_fuses=0xCE
	yourcustomboard.bootloader.high_fuses=0x99
	yourcustomboard.bootloader.extended_fuses=0xFF
	yourcustomboard.bootloader.path=atmega
	yourcustomboard.bootloader.file=ATmegaBOOT_168_atmega1280.hex
	yourcustomboard.bootloader.unlock_bits=0x3F
	yourcustomboard.bootloader.lock_bits=0x0F

	yourcustomboard.build.mcu=atmega1280
	yourcustomboard.build.f_cpu=14745600L
	yourcustomboard.build.core=arduino
	yourcustomboard.build.variant=standard

In this config all of the bootloader settings can be ignored(the fuse settings are only for documentation too).
The setting `protocol` is the name of the usb programmer(as listed by `avrdude`) you plan to use for this board.
The setting `maximum_size` might be incorrect in this example, since it subtracts bootloader flash size. The 
other important settings are `mcu` and `f_cpu`.

To create your own board's `boards.txt`, just use the nearest board from yours in 
`/usr/local/share/arduino/hardware/arduino/boards.txt` as a template and modify.

I use my favourite editor and jsut use `ino build/ino upload` and the workflow is greatly simplified. 
Hope you too find it useful!