---
published: true
layout: post
title: oshw_culture
category: misc
---

I think any CS/Electronics student should actually be interested in what
they are learning, and so should actually be tinkering with actual 
electronics. How to work with an oscilloscope should be a part of their 
basic toolset.

But it seems to me that how these courses are taught here
makes CS | Electronics two quite distinct subjects, which they are 
absolutely not. They are complimentary, or symbiotic or whatever. 
'Computer engineers' develop systems, and to do that you need to 
know stuff from several fields.

In older days, if you were a 'computer and electronics engineer'(or just 
someone who does that kind of stuff), you would know exactly what you have 
in your computer or any elecronics device you have. Even if you werent, you would 
have access to its schematics and datasheets probably(possibly in print). This was
probably because:

* The computers then were simpler
* Manufacturers didnt really try to hide what was inside their devices or prevent any modifications

Take most consumer device nowadays; not only do the manufacturers put a restriction
on how you can use their device(an example would be of [Sony suing hacker over ps3 jailbreak](http://www.informationweek.com/security/attacks/sony-sues-hackers-over-ps3-jailbreak/229000603) ), 
they hide any information related to the devices which would help users to know much about the device's 
innards or use them in ways not intended by the manufacturer. Which is not fair, since this
restricts people's freedom, they cannot even do things they want with things that they own.

Adafruit, spirit of oneupmanship, show and tell.etc.

incomplete blogpost - missing middle section.

This maker revolution seems to have started with arduino, with it as its
poster child. Arduino is an 8-bit AVR based microcontroller developed by
[arduino development team](http://en.wikipedia.org/wiki/Arduino#Development_team), they created it
for non technically inclned students to get started with building
interactive stuff fast. They released all schematics, and sources to
people. It has now become probably the most popular microcontroller 
platform for beginners. Many derivative boards, or boards which aim to 
provide a simplified envoronment have come up since. 

Although don't think that this is the best in terms of price, or 
performance, or features. Its great to get started with it, but you 
not not be satisfied with only an 8-bit cotroller which gives you 
a kind of black box environmnet. You would possibly never need to 
even read the atmega datasheet to use much of the functionality 
of the AVR since most things have user/arduino made libraries available.
Nor should you be contnt with it, since there awaits a whole lot of different
architectures out there, ARMs from many manufacturers, PIC8/16/32, 
to strange multicore ones. Look a this for some help [hackaday article](http://hackaday.com/2011/02/01/what-development-board-to-use/),
there's a part 2 too, find it yourself. As an example, if you use an 
arm, say from ST, you will have a lots of peripherals in the chip, and to 
use them, you will probably get libraries and example code.
It is always convenient to be working on linux when developing systems stuff
since you have all the tools you will be needing, free GNU toolchains, 
tools needed to build stuff(like make, autotools etc). You will learn a lot
about how a C langauege works. How does the first instruction get executed?
When does main get called? Is main anything special? How do stack and heap work?
You will at some point want to be able to include the c standard library.
How do you do that on an embedded system with no standard input/outputs?
This is some stuff I could recall. You will be reading a lot of others code
because there probably will be no other shortcut.

When you are finished with working with just plain barebones code,
you can look into running an RTOS on your board, embedded RTOS are usually pretty compact
and so also very readable, and you can see how the basicoperating systems 
constructs have been written. If you have something capable of running linux, then it is
a great learning experience just getting it to boot. You will probably
not be able to able to wrap your head around how linux code is arranged, where what is located,
how do I change something, add a new driver, etc., but you can always follow the
steps first to get an overview. Read a primer on how the kernel compilation system is worked, how
the codebase is arranged. At this point, you will probably need to be comfortable
with Git, because you will most likely be needing it; more likely to keep track of
other people's work than your own.

